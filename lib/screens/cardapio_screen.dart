// ignore_for_file: use_key_in_widget_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:serve_bem_app/blocs/menu_bloc.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';

// import '../models/menu_model.dart';

class CardapioScreen extends StatefulWidget {
  @override
  State<CardapioScreen> createState() => _CardapioScreenState();
}

class _CardapioScreenState extends State<CardapioScreen> {


  final _menuBloc = MenuBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<String>(
          stream: _menuBloc.outCardpioUrl,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(MyColors.backGround)),
              );
            } else {
              return CachedNetworkImage(
                imageUrl: snapshot.data!,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(MyColors.backGround),
                )),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              );
            }
          }),
    );
  }
}
