import 'package:cocreacion/EditProfile/ui/screens/edit_profile.dart';
import 'package:cocreacion/Ideas/ui/screens/home_page.dart';
import 'package:cocreacion/Users/bloc/home_bloc.dart';
import 'package:cocreacion/Users/model/user.dart';
import 'package:cocreacion/Users/ui/widgets/background_login.dart';
import 'package:cocreacion/Users/ui/widgets/button_login.dart';
import 'package:cocreacion/authphone.dart';
import 'package:flutter/material.dart';
import 'package:cocreacion/Users/bloc/bloc_user.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserBloc userBloc;

  //Facebook sign in
  void startFacebookLogin() async {
    var facebooklogin = new FacebookLogin();
    var result = await facebooklogin.logIn(['email', 'public_profile']);
//    var result = await facebooklogin
//        .logInWithReadPermissions(['email', 'public_profile']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        AuthCredential credential =
            FacebookAuthProvider.getCredential(accessToken: accessToken.token);
        FirebaseAuth.instance.signInWithCredential(credential).then((user) {
          userBloc.updateUserData(User(
            uid: user.user.uid,
            name: user.user.displayName,
            email: user.user.email,
            photoURL: user.user.photoUrl,
          ));
        });
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Facebook sign in cancelled by user');
        break;
      case FacebookLoginStatus.error:
        print('Facebook sign in failed');
        break;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);

    return _handleCurrentSession();
  }

  Widget _handleCurrentSession() {
    return StreamBuilder(
      stream: userBloc.authStatus,
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        //snapshot - data - Object User
        if (!snapshot.hasData || snapshot.hasError) {
          return signIn();
        } else {
          return HomePage();
        }
      },
    );
  }

  Widget signIn() {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          BackgroundImage(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 200.0),
                width: 200,
                child: Image(
                    image: AssetImage(
                  "assets/img/iverus2.png",
                )),
              ),
              Container(
                margin: EdgeInsets.only(top: 100.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Icon(
                        FontAwesomeIcons.gripLines,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      child: Icon(
                        FontAwesomeIcons.gripLines,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      child: Icon(
                        FontAwesomeIcons.gripLines,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 10.0),
                      child: Icon(
                        FontAwesomeIcons.gripLines,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Login with",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Aileron",
                          fontSize: 20.0),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.0),
                      child: Icon(
                        FontAwesomeIcons.gripLines,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      child: Icon(
                        FontAwesomeIcons.gripLines,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      child: Icon(
                        FontAwesomeIcons.gripLines,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      child: Icon(
                        FontAwesomeIcons.gripLines,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ButtonLogin(
                      iconData: FontAwesomeIcons.google,
                      top: 10.0,
                      onPressed: () {
                        userBloc.signOut();
                        userBloc.signIn().then((FirebaseUser user) {
                          userBloc.updateUserData(User(
                            uid: user.uid,
                            name: user.displayName,
                            email: user.email,
                            photoURL: user.photoUrl,
                          ));
                        });
                      }),
                  ButtonLogin(
                    iconData: FontAwesomeIcons.facebookF,
                    top: 10.0,
                    onPressed: () {
                      userBloc.signOut();
                      startFacebookLogin();
                    },
                  ),
                  ButtonLogin(
                    iconData: FontAwesomeIcons.phoneAlt,
                    top: 10.0,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Authphone()));

                      // Navigator.push(context, MaterialPageRoute(builder: (context)=> ));
                    },
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
