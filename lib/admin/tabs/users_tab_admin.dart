// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helpers/color_helper.dart';

class UsersTab extends StatefulWidget {
  Map<String, dynamic> user;

  UsersTab({required this.user});

  @override
  State<UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends State<UsersTab> {
  // ignore: constant_identifier_names
  static const IconData whatsapp_rounded =
      IconData(0xf03b8, fontFamily: 'MaterialIcons');

  _abrirWhatsApp({required String phone}) async {
    var whatsappUrl = "whatsapp://send?phone=+55$phone&text=Olá, tudo bem ?";

    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    final _style = TextStyle(
      color: Colors.white,
      fontSize: MediaQuery.of(context).size.width * 0.035,
      fontWeight: FontWeight.w400,
    );

    return Container(
      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12)
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.grey.shade600,
        elevation: 10.0,
        child: ExpansionTile(
          initiallyExpanded: false,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          expandedAlignment: Alignment.centerLeft,
          backgroundColor: Colors.grey.shade600,
          title: Text(
            "${widget.user['nome']}",
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            "${widget.user["email"]}",
            style: TextStyle(color: Colors.white),
          ),
          trailing: IconButton(
            onPressed: () {
              _abrirWhatsApp(phone: widget.user['celular']);
            },
            icon: Icon(
              whatsapp_rounded,
              color: MyColors.backGround,
            ),
          ),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
              child: Text(
                "Celular: ${widget.user['celular']}",
                style: _style,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
              child: Text(
                "Primeiro Endereço: ${widget.user['endereco']}",
                style: _style,
              ),
            ),
            widget.user['endereco2'] != ""
                ? Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
                    child: Text(
                      "Segundo Endereço: ${widget.user['endereco2']}",
                      style: _style,
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
