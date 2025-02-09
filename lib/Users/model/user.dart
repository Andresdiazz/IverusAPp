import 'dart:convert';

import 'package:flutter/material.dart';

import '../../ideas.dart';

class User {
  String uid;
  String name;
  String email;
  String photoURL;
  String gift;
  String phone;
  String desc;
  int points;
  int puntos;
  int rank;
  Map<dynamic, dynamic> likes;
  List<dynamic> shares;
  List<dynamic> watchedVideos;
  List<Ideas> myIdeas;
  List<Ideas> myFavoriteIdeas;

  User(
      {Key key,
      @required this.uid,
      @required this.name,
      @required this.photoURL,
      @required this.points,
      @required this.email,
      @required this.puntos,
      this.gift,
      @required this.phone,
      @required this.desc,
      this.likes,
      this.shares,
      this.watchedVideos,
      this.myIdeas,
      this.myFavoriteIdeas});

  @override
  String toString() {
    return JsonCodec().encode({
      'uid': uid,
      'name': name,
      'email': email,
      'puntos': puntos,
      'photoURL': photoURL,
      'points': points,
      'phone': phone,
      'desc': desc,
      'likes': likes,
      'shares': shares,
      'watchedVideos': watchedVideos,
    });
  }

  static User stringToObject(String json) {
    var data = JsonCodec().decode(json) as Map<String, dynamic>;
    return User.fromJson(data);
  }

  User.fromJson(Map<dynamic, dynamic> json) {
    if (json == null) return;
    uid = json['uid'] == null ? null : json['uid'];
    name = json['name'] == null ? null : json['name'];
    email = json['email'] == null ? null : json['email'];
    photoURL = json['photoURL'] == null ? null : json['photoURL'];
    points = json['points'] == null ? 0 : json['points'];
    puntos = json['puntos'] == null ? 0 : json['puntos'];
    phone = json['phone'] == null ? null : json['phone'];
    desc = json['desc'] == null ? null : json['desc'];
    likes = json['likes'] != null ? json['likes'] : null;
    shares = json['shares'] != null ? json['shares'] : null;
    watchedVideos =
        json['watchedVideos'] != null ? json['watchedVideos'] : null;
  }

  Map<String, dynamic> getMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['uid'] = this.uid;

    if (this.name != null) data['name'] = this.name;

    if (this.email != null) data['email'] = this.email;

    if (this.photoURL != null) data['photoURL'] = this.photoURL;

    if (this.points != null) data['points'] = this.points;
    if (this.puntos != null) data['puntos'] = this.puntos;
    if (this.phone != null) data['phone'] = this.phone;
    if (this.desc != null) data['desc'] = this.desc;
    if (this.likes != null) data['likes'] = this.likes;
    if (this.shares != null) data['shares'] = this.shares;
    if (this.watchedVideos != null) data['watchedVideos'] = this.watchedVideos;

    return data;
  }
}
