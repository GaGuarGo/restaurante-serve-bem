// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';

class InfoTab extends StatefulWidget {
  @override
  State<InfoTab> createState() => _InfoTabState();
}

class _InfoTabState extends State<InfoTab> {
  @override
  Widget build(BuildContext context) {
    final _style = TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.04,
        fontWeight: FontWeight.w300);

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Fechar",
              style: TextStyle(color: Colors.red),
            ))
      ],
      title: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            child: Image.asset(
              'assets/logoof.png',
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "° Tamanho Pequeno Acompanha: \n - 1 Prato Principal\n - 1 Guarnição",
            style: _style,
          ),
          SizedBox(
            height: 12.0,
          ),
          Text(
            "° Tamanho Médio Acompanha: \n - 1 Prato Principal\n - 1 ou 2 Guarnições",
            style: _style,
          ),
          SizedBox(
            height: 12.0,
          ),
          Text(
            "° Tamanho Grande Acompanha: \n - 1 Prato Principal e 1 ou 2 Guarnições \n - 1 ou 2 Pratos Principais e 1 Guarnição",
            style: _style,
          ),
        ],
      ),
    );
  }
}
