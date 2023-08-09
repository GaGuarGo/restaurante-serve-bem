// ignore_for_file: prefer_const_constructors, deprecated_member_use, use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';
import 'package:serve_bem_app/models/user_model.dart';

class ChangeField extends StatefulWidget {
  bool change;
  String changeText;
  String labelText;
  TextEditingController controller;
  String hintText;
  int maxLines;
  TextInputType textType;

  ChangeField({
    required this.change,
    required this.changeText,
    required this.labelText,
    required this.controller,
    required this.hintText,
    required this.maxLines,
    required this.textType,
  });

  @override
  State<ChangeField> createState() => _ChangeFieldState();
}

class _ChangeFieldState extends State<ChangeField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      width: MediaQuery.of(context).size.width * 0.7,
      height: widget.change == false
          ? MediaQuery.of(context).size.height * 0.1
          : MediaQuery.of(context).size.height * 0.12,
      child: widget.change == false
          ? RaisedButton(
              elevation: 5.0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              onPressed: () {
                setState(() {
                  widget.change = !widget.change;
                });
              },
              child: Center(
                child: Text(
                  widget.changeText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: MyColors.backGround,
                      fontSize: MediaQuery.of(context).size.width * 0.045),
                ),
              ),
            )
          : TextField(
              controller: widget.controller,
              keyboardType: widget.textType,
              maxLength: widget.maxLines,
              style: TextStyle(),
              decoration: InputDecoration(
                hintText: widget.hintText,
                focusColor: Color.fromARGB(255, 255, 68, 0),
                floatingLabelStyle: TextStyle(
                  color: Color.fromARGB(255, 255, 68, 0),
                ),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: Color.fromARGB(255, 255, 68, 0),
                )),
                labelText: widget.labelText,
                labelStyle: TextStyle(),
                icon: Icon(
                  CupertinoIcons.bookmark,
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
    );
  }
}

class RemoveSecondAddress extends StatefulWidget {
  void Function() onSuccess;
  void Function() onFail;

  RemoveSecondAddress({required this.onSuccess, required this.onFail});

  @override
  State<RemoveSecondAddress> createState() => _RemoveSecondAddressState();
}

class _RemoveSecondAddressState extends State<RemoveSecondAddress> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.1,
        child: RaisedButton(
          elevation: 5.0,
          color: MyColors.backGround,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onPressed: () {
            UserModel.of(context).removeSecondAdress(
                onSuccess: widget.onSuccess, onFail: widget.onFail);
          },
          child: Center(
            child: Text(
              "Remover 2° endereço",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.045),
            ),
          ),
        ));
  }
}
