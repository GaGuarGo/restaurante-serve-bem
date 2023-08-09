// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, deprecated_member_use, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:serve_bem_app/admin/blocs/settings_admin_bloc.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';
import 'package:serve_bem_app/models/user_model.dart';

enum Sizes { pequena, media, grande }

class SizeChoice extends StatefulWidget {
  /*
  bool choice;
  String text;
  int price;
  double size;
  */
  String value;

  SizeChoice({
    required this.value,
  });

  @override
  State<SizeChoice> createState() => _SizeChoiceState();
}

class _SizeChoiceState extends State<SizeChoice> {
  Sizes size = Sizes.pequena;
  final _settingsBloc = SettingBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
        stream: _settingsBloc.outSettings,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(MyColors.backGround)),
            );
          } else {
            return Column(
              children: <Widget>[
                ListTile(
                    title: Text("Pequena"),
                    subtitle: Text(
                        "R\$ ${snapshot.data!["precoP"]},00 + R\$ ${snapshot.data!["entregaP"]},00 Entrega"),
                    trailing: Icon(
                      Icons.dinner_dining_outlined,
                      color: MyColors.backGround,
                    ),
                    leading: Radio<Sizes>(
                      activeColor: MyColors.backGround,
                      value: Sizes.pequena,
                      groupValue: size,
                      onChanged: (Sizes? value) {
                        setState(() {
                          size = value!;
                        });
                        UserModel.of(context).getSize(tamanho: "Pequena");
                      },
                    )),
                ListTile(
                    title: Text("Média"),
                    subtitle: Text(
                        "R\$ ${snapshot.data!["precoM"]},00 + R\$ ${snapshot.data!["entregaM"]},00 Entrega"),
                    trailing: Icon(
                      Icons.dinner_dining_outlined,
                      color: MyColors.backGround,
                    ),
                    leading: Radio<Sizes>(
                      activeColor: MyColors.backGround,
                      value: Sizes.media,
                      groupValue: size,
                      onChanged: (Sizes? value) {
                        setState(() {
                          size = value!;
                        });
                        UserModel.of(context).getSize(tamanho: "Média");
                     
                      },
                    )),
                ListTile(
                    title: Text("Grande"),
                    subtitle: Text(
                        "R\$ ${snapshot.data!["precoG"]},00 + R\$ ${snapshot.data!["entregaG"]},00 Entrega"),
                    trailing: Icon(
                      Icons.dinner_dining_outlined,
                      color: MyColors.backGround,
                    ),
                    leading: Radio<Sizes>(
                      activeColor: MyColors.backGround,
                      value: Sizes.grande,
                      groupValue: size,
                      onChanged: (Sizes? value) {
                        setState(() {
                          size = value!;
                        });
                        UserModel.of(context).getSize(tamanho: "Grande");
                   
                      },
                    ))
              ],
            );
          }
        });
  }
}
/*
ListTile(
        title: Text(widget.text),
        subtitle: Text("R\$ ${widget.price},00"),
        trailing: Icon(
          Icons.dinner_dining_outlined,
          color: MyColors.backGround,
        ),
        leading: Radio<Sizes>(
          activeColor: MyColors.backGround,
          value: Sizes.values[widget.index],
          groupValue: size,
          onChanged: (Sizes? value) {
            setState(() {
              size = value!;
            });
            print(size);
          },
        ));
        */
/*
OutlineButton(
      onPressed: () {},
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Text(
          "${widget.text} \n R\$ ${widget.price},00",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: MediaQuery.of(context).size.width * 0.04,
            color: (value == widget.index) ? MyColors.backGround : Colors.black,
          ),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      borderSide: BorderSide(
        color: (value == widget.index) ? MyColors.backGround : Colors.black,
        width: 0.5,
      ),
    );
*/

/*
GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = widget.index;
        });
        print(selectedIndex);
      },
      child: Container(
        alignment: Alignment.centerLeft,
        width: MediaQuery.of(context).size.width * 0.25,
        child: Card(
          color: widget.index != selectedIndex ? Colors.white : Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8.0,
          child: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              // ignore: prefer_const_literals_to_create_immutables
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.dinner_dining,
                  color: widget.index != selectedIndex
                      ? Colors.black87
                      : Colors.white,
                  size: widget.size,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      color: widget.index != selectedIndex
                          ? Colors.black87
                          : Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(
                    "R\$${widget.price},00",
                    style: TextStyle(
                      color: widget.index != selectedIndex
                          ? Colors.black87
                          : Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
*/