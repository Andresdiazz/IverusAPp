import 'dart:developer';

import 'package:cocreacion/Ideas/ui/screens/home_page.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

import 'EditProfile/ui/screens/edit_profile.dart';
import 'Ideas/ui/screens/home.dart';
import 'Users/bloc/bloc_user.dart';
import 'Users/model/user.dart';

class Authphone extends StatefulWidget {
  @override
  _AuthphoneState createState() => _AuthphoneState();
}

class _AuthphoneState extends State<Authphone> {


  UserBloc userBloc;

  final TextEditingController _phoneController = new TextEditingController();
  final TextEditingController _smsController = new TextEditingController();

  String _phonecode;

  String verificationId;
  FirebaseUser user;

  @override
  void initState() {
    super.initState();
    _phoneController.text = "";

  }

  var _keyField = GlobalKey<FormFieldState>();

  _buildCountryPickerDropdown() => Row(
        children: <Widget>[
          CountryPickerDropdown(
            initialValue: 'mx',
            itemBuilder: _buildDropdownItem,
            onValuePicked: (Country country) {
              print("${country.name}");
              print("${country.phoneCode}");
              setState(() {
                this._phonecode = country.phoneCode;
              });
            },
          ),
          SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: TextFormField(
              key: _keyField,
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: "Phone Number",
                  labelStyle: TextStyle(
                    fontFamily: "Aileron",
                    fontWeight: FontWeight.w600,
              )),
              validator: (val) {
                if (val.isEmpty) {
                  return "this field cannot be empty";
                }
              },
            ),
          ),
        ],
      );

  Widget _buildDropdownItem(Country country) => Container(
        child: Row(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            SizedBox(
              width: 8.0,
            ),
            Text("+${country.phoneCode}(${country.isoCode})"),
          ],
        ),
      );

//Verificar_Telefono

  Future<void> verifyPhone(BuildContext context) async {
    try {
      final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
        this.verificationId = verId;
      };

      final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
        this.verificationId = verId;
        smsCodeDialog(context).then((value) {
          print('Signed in');
        });
      };

      final PhoneVerificationCompleted verifiedSuccess = (AuthCredential user) {
        print('Successful verification');
        if (user != null) {
          complete(user);
        } else {
          print('user is null');
        }
      };

      final PhoneVerificationFailed veriFailed = (AuthException exception) {
        print('Failed verification: ${exception.message}');
      };

      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '+${_phonecode + _phoneController.text.trim()}',
          timeout: const Duration(seconds: 5),
          verificationCompleted: verifiedSuccess,
          verificationFailed: veriFailed,
          codeSent: smsCodeSent,
          codeAutoRetrievalTimeout: autoRetrieve);
    } catch (e) {
      print("error: $e");
    }
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter sms Code'),
            content: TextField(
              keyboardType: TextInputType.number,
              controller: _smsController,
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              new FlatButton(
                child: Text('Done'),
                onPressed: () async {
                  AuthCredential credential = PhoneAuthProvider.getCredential(
                    verificationId: this.verificationId,
                    smsCode: _smsController.text.trim(),
                  );

                  complete(credential);
                },
              ),
            ],
          );
        });
  }

  flushBarMessage(BuildContext context, String msg) {
    Flushbar(
        message: "$msg",
        duration: Duration(seconds: 4),
        leftBarIndicatorColor: Colors.blue[300])
      ..show(context);
  }

  complete(AuthCredential user) {
    if (user != null) {
      FirebaseAuth.instance.signInWithCredential(user).then((user) {
        userBloc.checkIfAlreadyExists(user.user.uid).then((snapshot) {
          if (snapshot.exists) {
//            user signed in and exited
            User user = User.fromJson(snapshot.data);
            if (user.name.isEmpty || user.photoURL.isEmpty) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => EditProfile(true)),
                  (_) => false);
            } else {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => HomePage()),
                  (_) => false);
            }
          } else {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => EditProfile(true)),
                (_) => false);
          }
        });
//        userBloc.updateUserData(User(
//          uid: user.user.uid,
//          name: user.user.displayName,
//          email: user.user.email,
//          photoURL: user.user.photoUrl,
//          phone: user.user.phoneNumber,
//        ));
//        Navigator.push(context,
//            MaterialPageRoute(builder: (context) => EditProfile(true)));
//            Navigator.of(context).pop({"user": user});
      });
    } else {
      print('user is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    var deviceSize = MediaQuery.of(context).size;

    userBloc = BlocProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        //const Color(0xFF05C3DD),
        title: Text(
          "Autenticación Telefono",
          style: TextStyle(color: Colors.black,
              fontFamily: "Aileron",
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Center(
        child: Container(
            color: Colors.white,
            child: Center(
                child: Container(
              margin: EdgeInsets.only(top: 20),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: deviceSize.width - 200,

                        child: Image(
                            image: NetworkImage(
                          "https://firebasestorage.googleapis.com/v0/b/cocreacion-f17df.appspot.com/o/Assets%2Fimg%2FLOGO-IVERUS-NEGRO.png?alt=media&token=af898df2-cd8d-44f8-bc83-864000bab447",
                        ),
                        height: deviceSize.height/10,),
                      ),
                      SizedBox(height: deviceSize.height / 100),
                      ListTile(title: _buildCountryPickerDropdown()),
                    ],
                  ),
                  SizedBox(
                    height: deviceSize.height / 20 ,
                  ),
                  InkWell(
                    onTap: () {
                      if (_phonecode != null) {
                        if (_keyField.currentState.validate()) {
                          print(
                              "+${_phonecode + _phoneController.text.trim()}");
                          verifyPhone(context);
                          log("funcion correctamente verificar");
                        }
                      } else {
                        flushBarMessage(
                            context, "please select your code country");
                        log("error");
                      }
                    },
                    child: Container(
                        width: 200,
                        height: 40,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF05C3DD),
                                  //Colors.deepPurpleAccent,
                                  const Color(0xFF87189d),
                                ],
                                //stops: [0.2, 0.7],
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft),
                            borderRadius: BorderRadius.circular(30)),
                        child: Center(
                          child: Text(
                            "Verificación",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                fontFamily: "Aileron"
                            ),
                          ),
                        )),
                  )
                ],
              ),
            ))),
      ),
    );
  }
}

