import 'dart:io';

import 'package:cocreacion/EditProfile/bloc/edit_profile_bloc.dart';
import 'package:cocreacion/EditProfile/model/image_model.dart';
import 'package:cocreacion/EditProfile/ui/widgets/edit_profile_header.dart';
import 'package:cocreacion/Ideas/ui/screens/home.dart';
import 'package:cocreacion/Ideas/ui/screens/home_page.dart';
import 'package:cocreacion/Users/ui/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

class EditProfile extends StatefulWidget {
  bool completeProfile;

  EditProfile(this.completeProfile);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool _validateName = false;
  bool _validatePhoto = false;
  bool _validatePhone = false;
  bool _validateEmail = false;
  EditProfileBloc _editProfileBloc;
  FocusNode _nameFocus = FocusNode();
  FocusNode _emailFocus = FocusNode();
  FocusNode _phoneFocus = FocusNode();
  FocusNode _aboutYouFocus = FocusNode();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _editProfileBloc = EditProfileBloc(this.widget.completeProfile);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(height: 230, child: EditProfileHeader()),
                StreamBuilder<bool>(
                    stream: _editProfileBloc.isEditing,
                    builder: (context, snapshot) {
                      bool d = snapshot.data == null || !snapshot.data;
                      return Column(
                        children: <Widget>[
                          getUpper(context, snapshot),
                          SizedBox(
                            height: 40,
                          ),
                          getName(context, !d),
                          SizedBox(
                            height: 20,
                          ),
                          getEmail(context, !d),
                          SizedBox(
                            height: 20,
                          ),
                          getPhone(context, !d),
                          SizedBox(
                            height: 20,
                          ),
                          getDesc(context, !d),
                          SizedBox(
                            height: 30,
                          ),
                          !d ? getSave(context) : Container()
                        ],
                      );
                    }),
                BackButton(
                  color: Colors.white,
                )
              ],
            )
          ],
        ),
      ),
      onWillPop: () {
        Navigator.of(context).pop(false);
      },
    );
  }

  getUpper(context, snapshot) {
    return Container(
      height: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Align(
            child: GestureDetector(
              child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: StreamBuilder<bool>(
                      stream: _editProfileBloc.isEditing,
                      builder: (context, AsyncSnapshot snapshot) {
                        return snapshot.data == null || !snapshot.data
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Image(
                                    image: NetworkImage("https://firebasestorage.googleapis.com/v0/b/cocreacion-f17df.appspot.com/o/Assets%2Fimg%2Fedit.png?alt=media&token=bceadb9e-4866-45c8-8f56-1739811e211e"),
                                    width: 20,
                                    color: Colors.deepPurple,
                                  ),
                                  Text(
                                    "Edit Profile",
                                    style: Theme.of(context)
                                        .textTheme
                                        .body1
                                        .copyWith(color: Colors.black87),
                                  ),
                                ],
                              )
                            : Container();
                      })),
              onTap: () {
                _editProfileBloc.editClicked();
              },
            ),
            alignment: Alignment(1, 1),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Align(
              alignment: Alignment(0, 1),
              child: Stack(
                alignment: Alignment(1, -1),
                children: <Widget>[
                  Card(
                    child: StreamBuilder<ImageModel>(
                        stream: _editProfileBloc.imageController,
                        builder: (context, AsyncSnapshot<ImageModel> snapshot) {
                          return CircleAvatar(
                            maxRadius: 60,
                            backgroundImage: snapshot.data == null
                                ? NetworkImage("https://firebasestorage.googleapis.com/v0/b/cocreacion-f17df.appspot.com/o/Assets%2Fimg%2Fprofile.jpg?alt=media&token=7621fac2-a428-44df-ab06-0336740602d7")
                                : snapshot.data.file == null
                                    ? NetworkImage(snapshot.data.path)
                                    : FileImage(snapshot.data.file),
//                            FileImage(_image)
//                          AssetImage("assets/img/bienestar.jpg"),
                          );
                        }),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80)),
                    elevation: 8,
                  ),
                  snapshot.data == null || !snapshot.data
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                        )
                      : GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        )
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ProfileScreen(
                  color: Colors.deepPurple,
                  size: 25.0,
                  margin: 50.0,
                ),
                Text(
                  "Logout",
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) _editProfileBloc.updateImage(image);
    });
  }

  getName(context, bool sn) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.1,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                  color: Colors.blueGrey,
                  width: 0.5,
                  style: BorderStyle.solid)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.person,
                  color: Colors.blue,
                  size: 22,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  "Name",
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.grey),
                ),
                SizedBox(
                  width: 12,
                ),
                Flexible(
                  child: StreamBuilder(
                      stream: _editProfileBloc.name,
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        _nameController.value =
                            _nameController.value.copyWith(text: snapshot.data);
                        return TextField(
                          controller: _nameController,
                          focusNode: _nameFocus,
                          onSubmitted: (value) {
                            _nameFocus.unfocus();
                            FocusScope.of(context).requestFocus(_emailFocus);
                          },
                          enabled: sn,
                          onChanged: _editProfileBloc.changeName,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            errorText: _validateName
                                ? "This field cannot be empty."
                                : null,
                            border: InputBorder.none,
                          ),
                          style: Theme.of(context).textTheme.body2,
                        );
                      }),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  getEmail(context, bool sn) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.1,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                  color: Colors.blueGrey,
                  width: 0.5,
                  style: BorderStyle.solid)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.email,
                  color: Colors.blue,
                  size: 22,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  "Email",
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.grey),
                ),
                SizedBox(
                  width: 12,
                ),
                Flexible(
                  child: StreamBuilder(
                      stream: _editProfileBloc.email,
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        _emailController.value = _emailController.value
                            .copyWith(text: snapshot.data);
                        return TextField(
                          controller: _emailController,
                          focusNode: _emailFocus,
                          onSubmitted: (value) {
                            _emailFocus.unfocus();
                            FocusScope.of(context).requestFocus(_phoneFocus);
                          },
                          onChanged: _editProfileBloc.changeEmail,
                          keyboardType: TextInputType.emailAddress,
                          enabled: sn,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            errorText: _validateEmail ? "Invalid email" : null,
                            border: InputBorder.none,
                          ),
                          style: Theme.of(context).textTheme.body2,
                        );
                      }),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  getPhone(context, bool sn) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.1,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                  color: Colors.blueGrey,
                  width: 0.5,
                  style: BorderStyle.solid)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.phone,
                  color: Colors.blue,
                  size: 22,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  "Phone",
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.grey),
                ),
                SizedBox(
                  width: 12,
                ),
                Flexible(
                  child: StreamBuilder(
                      stream: _editProfileBloc.phone,
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        _phoneController.value = _phoneController.value
                            .copyWith(text: snapshot.data);
                        return TextField(
                          controller: _phoneController,
                          focusNode: _phoneFocus,
                          onSubmitted: (value) {
                            _phoneFocus.unfocus();
                            FocusScope.of(context).requestFocus(_aboutYouFocus);
                          },
                          onChanged: _editProfileBloc.changePhone,
                          enabled: sn,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            errorText: _validatePhone ? "Invalid phone." : null,
                            border: InputBorder.none,
                          ),
                          style: Theme.of(context).textTheme.body2,
                        );
                      }),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  getDesc(context, bool sn) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.1,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                  color: Colors.blueGrey,
                  width: 0.5,
                  style: BorderStyle.solid)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.description,
                  color: Colors.blue,
                  size: 22,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  "About you",
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.grey),
                ),
                SizedBox(
                  width: 12,
                ),
                Flexible(
                  child: StreamBuilder(
                      stream: _editProfileBloc.desc,
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        _descController.value =
                            _descController.value.copyWith(text: snapshot.data);
                        return TextField(
                          controller: _descController,
                          focusNode: _aboutYouFocus,
                          onSubmitted: (value) {
                            _aboutYouFocus.unfocus();
                          },
                          minLines: 1,
                          maxLines: 3,
                          onChanged: _editProfileBloc.changeDesc,
                          enabled: sn,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          style: Theme.of(context).textTheme.body2,
                        );
                      }),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  getSave(context) {
    return StreamBuilder(
      stream: _editProfileBloc.isLoadingController,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        return Container(
          margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.27,
              right: MediaQuery.of(context).size.width * 0.27),
          decoration: new BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurpleAccent,
                  Colors.deepPurple,
                ],
              ),
              borderRadius: new BorderRadius.all(const Radius.circular(20.0))),
          child: InkWell(
            onTap: () {
              setState(() {
                if (this.widget.completeProfile) {
                  if (_editProfileBloc.imageController.value == null ||
                      _editProfileBloc.imageController.value.path == null &&
                          _editProfileBloc.imageController.value.file == null) {
                    _validatePhoto = false;
                    Toast.show("Please select profile photo!", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  } else
                    _validatePhoto = true;
                }
                _validateName = _nameController.text.isEmpty;
                _validateEmail = (_emailController.text.isNotEmpty &&
                    !_editProfileBloc.validateEmail(_emailController.text));

                _validatePhone = (_phoneController.text.isNotEmpty &&
                    !_editProfileBloc.validatePhone(_phoneController.text));
              });

              if (!_validateName && !_validatePhone && !_validateEmail) {
                if (this.widget.completeProfile) {
                  if (_validatePhoto) {
                    _editProfileBloc.updateData().then((_) {
                      if (this.widget.completeProfile) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) => HomePage()),
                            (_) => false);
                      }
                    });
                  }
                } else {
                  _editProfileBloc.updateData().then((_) {
                    if (this.widget.completeProfile) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) => HomePage()),
                          (_) => false);
                    }
                  });
                }
              }
            },
            splashColor: Colors.white30,
            child: Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.all(12),
              child: snapshot.data != null && snapshot.data
                  ? Container(
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                      height: 20,
                      width: 20,
                    )
                  : Text(
                      "Save",
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: Colors.white),
                    ),
            ),
          ),
        );
      },
    );
  }
}
