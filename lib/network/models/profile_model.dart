import 'package:mihu/home-flow/add_user/add_user_model.dart';

import 'package:mihu/home-flow/add-business_user/add_business_model.dart'
    as addBusiness;

class Profile {
  int? id;
  String? name;
  String? profilePic;
  String? email;
  String? phone;
  String? whatsapp;
  String? instagram;
  String? twitter;
  String? youtube;
  String? about;
  String? website;
  String? address;

  Profile({
    this.id,
    this.name,
    this.profilePic,
    this.email,
    this.phone,
    this.whatsapp,
    this.instagram,
    this.twitter,
    this.youtube,
    this.about,
    this.website,
    this.address,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      name: json['name'],
      profilePic: json['profile_image'],
      email: json['email'],
      phone: json['phone'],
      whatsapp: json["whatsapp"],
      instagram: json["instagram"],
      twitter: json["twitter"],
      youtube: json["youtube"],
      about: json["about"],
      website: json["website"],
      address: json["address"],
    );
  }

  // For DatumAddUser
  factory Profile.fromDatum(DatumAddUser datum) {
    return Profile(
      id: datum.profileId,
      name: datum.name,
      profilePic: datum.profileImage,
      email: datum.email,
      phone: datum.phone,
      whatsapp: datum.whatsapp,
      instagram: datum.instagram,
      twitter: datum.twitter,
      youtube: datum.youtube,
      about: datum.about,
      website: datum.website,
      address: datum.address,
    );
  }

  // For the other Datum class
  factory Profile.fromDatumBasic(addBusiness.BusinessDatum datum) {
    return Profile(
      id: datum.id,
      name: datum.name,
      profilePic: datum.logo,
      email: null,
      // or a default value
      phone: null, // or a default value
    );
  }

  // Convert Profile instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile_image': profilePic,
      'email': email,
      'phone': phone,
    };
  }
}

class Datum {
  int id; // or String depending on your API response
  String name;
  String logo;

  Datum({
    required this.id,
    required this.name,
    required this.logo,
  });
}
