// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpField extends StatefulWidget {
  TextInputType textType;
  String labelText;
  Icon icon;
  bool obscure;
  TextEditingController controller;
  List<TextInputFormatter> formatter;
  String hintText;
  int maxLength;
  Stream<String> stream;
  Function(String text) onChanged;
  String? Function(String? text) validator;
  SignUpField({
    required this.textType,
    required this.labelText,
    required this.icon,
    required this.obscure,
    required this.controller,
    required this.formatter,
    required this.hintText,
    required this.maxLength,
    required this.stream,
    required this.onChanged,
    required this.validator,
  });

  @override
  State<SignUpField> createState() => _SignUpFieldState();
}

class _SignUpFieldState extends State<SignUpField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: StreamBuilder<String>(
          stream: widget.stream,
          builder: (context, snapshot) {
            return TextFormField(
              validator: widget.validator,
              onChanged: widget.onChanged,
              maxLength: widget.maxLength,
              controller: widget.controller,
              inputFormatters: widget.formatter,
              keyboardType: widget.textType,
              obscureText: widget.obscure,
              decoration: InputDecoration(
                  hintText: widget.hintText,
                  focusColor: const Color.fromARGB(255, 255, 68, 0),
                  // ignore: prefer_const_constructors
                  floatingLabelStyle: TextStyle(
                    color: const Color.fromARGB(255, 255, 68, 0),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Color.fromARGB(255, 255, 68, 0),
                  )),
                  labelText: widget.labelText,
                  icon: widget.icon,
                  border: const UnderlineInputBorder()),
            );
          }),
    );
  }
}
