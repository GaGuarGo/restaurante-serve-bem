// ignore_for_file: file_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:serve_bem_app/models/menu_model.dart';
import 'package:serve_bem_app/screens/cardapio_screen.dart';

import '../../helpers/color_helper.dart';

class MenuPhotoTabADM extends StatefulWidget {
  const MenuPhotoTabADM({Key? key}) : super(key: key);

  @override
  State<MenuPhotoTabADM> createState() => _MenuPhotoTabADMState();
}

class _MenuPhotoTabADMState extends State<MenuPhotoTabADM> {
  bool _inProcess = false;
  XFile? _pickedFile;

  Future<void> _uploadImage(ImageSource source) async {
    setState(() {
      _inProcess = true;
    });

    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });

      savePhoto();
      setState(() {
        _inProcess = false;
      });
    } else {
      setState(() {
        setState(() {
          _inProcess = false;
        });
      });
    }
  }

  String _url = "";

  Future<void> savePhoto() async {
    if (_pickedFile != null) {
      final storageRef = FirebaseStorage.instance.ref();
      final imageRef = storageRef.child("menu");

      await imageRef.delete();

      TaskSnapshot task = await imageRef.putFile(File(_pickedFile!.path));

      final url = await task.ref.getDownloadURL();

      setState(() {
        _url = url;
      });

      await FirebaseFirestore.instance
          .collection('menu')
          .doc('fotoMenu')
          .update({"foto": _url});

      MenuModel.of(context).getMenu();
    } else {
      setState(() {
        _url = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.backGround,
        onPressed: () {
          _uploadImage(ImageSource.gallery);
        },
        child: const Center(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      body: _inProcess == false
          ? CardapioScreen()
          : const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(MyColors.backGround),
              ),
            ),
    );
  }
}
