
import 'dart:io';
import 'package:flutter/material.dart';




class CheckInternet {
  Future<bool> hasNetwork() async {
    try {
      await InternetAddress.lookup('google.com');
      return true;

    } on SocketException catch (_) {
      return false;
    }
  }


  noInterNet(context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:Align(
          alignment: Alignment.topLeft,
          child: Text('No Internet',),
        ),
        content: const Text('Please check your internet connection.',),
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 30.0, bottom: 20,left: 20.0 ),
              child: Text(
                "Ok",
                style: TextStyle(color: Colors.black, fontSize: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }



}