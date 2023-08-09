// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';

class WarningTab extends StatefulWidget {
  String title;
  String description;

  WarningTab({required this.title, required this.description});

  @override
  State<WarningTab> createState() => _WarningTabState();
}

class _WarningTabState extends State<WarningTab> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Fechar",
              style: TextStyle(color: Colors.red),
            )),
      ],
      title: Text(
        widget.title,
        style: TextStyle(
            color: Colors.black54,
            fontSize: MediaQuery.of(context).size.width * 0.08,
            fontWeight: FontWeight.w400),
      ),
      content: Container(
        margin: const EdgeInsets.all(8),
        child: Text(
          widget.description,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black54,
              fontSize: MediaQuery.of(context).size.width * 0.06,
              fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}
