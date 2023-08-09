// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';

class AddMenuDialogADM extends StatefulWidget {
  const AddMenuDialogADM({Key? key}) : super(key: key);

  @override
  State<AddMenuDialogADM> createState() => _AddMenuDialogADMState();
}

class _AddMenuDialogADMState extends State<AddMenuDialogADM> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  String itemMenuValue = "";
  String itemMenu = "Escolhe o tipo do item:";

  XFile? _pickedFile;
  CroppedFile? _croppedFile;

  bool _inProcess = false;

  Future<void> _cropImage() async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 520,
              height: 520,
            ),
            viewPort:
                const CroppieViewPort(width: 480, height: 480, type: 'circle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),
        ],
      );
      setState(() {
        _inProcess = false;
      });

      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
        });
        setState(() {
          _inProcess = false;
        });
      }
    }
  }

  Future<void> _uploadImage(ImageSource source) async {
    setState(() {
      _inProcess = true;
    });

    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
      _cropImage();
    } else {
      setState(() {
        setState(() {
          _inProcess = false;
        });
      });
    }
  }

  bool _isLoading = false;
  String error = "";
  String _url = "";

  Future<void> savePhoto() async {
    setState(() {
      _inProcess = true;
    });
    if (_croppedFile != null) {
      
    
      final storageRef = FirebaseStorage.instance.ref();
      final imageRef = storageRef.child(_nameController.text.trim());

      TaskSnapshot task = await imageRef.putFile(File(_croppedFile!.path));

      final url = await task.ref.getDownloadURL();

      setState(() {
        _url = url;
        _inProcess = false;
      });
    } else {
      setState(() {
        _url = "";
        _inProcess = false;
      });
    }
  }

  _addFoodDrinkItem(
      {required bool choice, required Map<String, String> item}) async {
    try {
      setState(() {
        _isLoading = true;
      });

      if (choice == true) {
        await FirebaseFirestore.instance.collection('cardapio').add(item);
      } else {
        await FirebaseFirestore.instance.collection('bebidas').add(item);
      }

      setState(() {
        _isLoading = false;
      });
      clear();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void clear() {

    File(_croppedFile!.path).delete();
    _nameController.clear();
    _priceController.clear();

  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        RaisedButton(
          onPressed: () {
            if (itemMenuValue == "bebida") {
              if (_croppedFile != null &&
                  _nameController.text.isNotEmpty &&
                  itemMenuValue.isNotEmpty &&
                  _priceController.text.isNotEmpty) {
                savePhoto().then((_) {
                  final Map<String, String> item = {
                    "nome": _nameController.text,
                    "preco": _priceController.text,
                    "foto": _url
                  };

                  _addFoodDrinkItem(choice: false, item: item);
                });
              } else {
                setState(() {
                  error = 'Preencha Todos os Campos!';
                });
              }
            } else {
              if (_croppedFile != null &&
                  _nameController.text.isNotEmpty &&
                  itemMenuValue.isNotEmpty) {
                savePhoto().then((_) {
                  final Map<String, String> item = {
                    "nome": _nameController.text,
                    "tipo": itemMenuValue,
                    "foto": _url
                  };

                  _addFoodDrinkItem(choice: true, item: item);
                });
              } else {
                setState(() {
                  error = 'Preencha Todos os Campos!';
                });
              }
            }
          },
          color: MyColors.backGround,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              "Adicionar",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              "Fechar",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
      backgroundColor: Colors.grey.shade800,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        "Adicionar ao Cardápio:",
        style: TextStyle(
          color: MyColors.backGround,
          fontWeight: FontWeight.bold,
          fontSize: MediaQuery.of(context).size.width * 0.06,
        ),
      ),
      content: _isLoading == false
          ? SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _inProcess == true
                      ? Container(
                          margin: EdgeInsets.all(12),
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation(MyColors.backGround),
                          ),
                        )
                      : _croppedFile == null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                  InkWell(
                                    onTap: () {
                                      _uploadImage(ImageSource.camera);
                                    },
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.15,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.15,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: MyColors.backGround,
                                        borderRadius: BorderRadius.circular(20),
                                        // ignore: prefer_const_literals_to_create_immutables
                                      ),
                                      child: Icon(
                                        Icons.add_a_photo,
                                        color: Colors.white,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.12,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _uploadImage(ImageSource.gallery);
                                    },
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.15,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.15,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: MyColors.backGround,
                                        borderRadius: BorderRadius.circular(20),
                                        // ignore: prefer_const_literals_to_create_immutables
                                      ),
                                      child: Icon(
                                        Icons.photo,
                                        color: Colors.white,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.12,
                                      ),
                                    ),
                                  ),
                                ])
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.height * 0.15,
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: MyColors.backGround,
                                    borderRadius: BorderRadius.circular(20),
                                    // ignore: prefer_const_literals_to_create_immutables
                                  ),
                                  child: Image.file(
                                    File(_croppedFile!.path),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _croppedFile = null;
                                    });
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.height *
                                        0.15,
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: MyColors.backGround,
                                      borderRadius: BorderRadius.circular(20),
                                      // ignore: prefer_const_literals_to_create_immutables
                                    ),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: MediaQuery.of(context).size.width *
                                          0.12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 0.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade600,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          hintText: 'Digite o nome:',
                          hintStyle: TextStyle(color: Colors.white),
                          icon: Icon(Icons.search, color: Colors.white),
                          border: InputBorder.none),
                      // onChanged: _userBloc.onChangedSearch,
                    ),
                  ),
                  itemMenuValue == "bebida"
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 0.0, vertical: 0.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade600,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _priceController,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                hintText: 'Digite o preço R\$:',
                                hintStyle: TextStyle(color: Colors.white),
                                icon: Icon(Icons.search, color: Colors.white),
                                border: InputBorder.none),
                            // onChanged: _userBloc.onChangedSearch,
                          ),
                        )
                      : Container(),
                  Container(
                    margin: const EdgeInsets.only(top: 12.0),
                    padding: const EdgeInsets.all(8.0),
                    // width: MediaQuery.of(context).size.width * 0.7,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade600,
                    ),
                    child: DropdownButton<String>(
                      // value: tipoItemMenu,
                      dropdownColor: Colors.grey.shade800,
                      iconDisabledColor: Colors.white,
                      iconEnabledColor: Colors.white,
                      focusColor: Colors.white,
                      hint: Text(
                        itemMenu,
                        style: const TextStyle(color: Colors.white),
                      ),
                      items: [
                        DropdownMenuItem<String>(
                          value: "principal",
                          child: const Text(
                            "Prato Principal",
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            setState(() {
                              itemMenu = "Prato Principal";
                            });
                          },
                        ),
                        DropdownMenuItem<String>(
                          value: "guarnicao",
                          child: const Text(
                            "Guarnição",
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            setState(() {
                              itemMenu = "Guarnição";
                            });
                          },
                        ),
                        DropdownMenuItem<String>(
                          value: "bebida",
                          child: const Text(
                            "Bebida",
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            setState(() {
                              itemMenu = "Bebida";
                            });
                          },
                        ),
                      ],
                      onChanged: (item) {
                        setState(() {
                          itemMenuValue = item!;
                        });
                      },
                    ),
                  ),
                  error.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            error,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(MyColors.backGround),
              ),
            ),
    );
  }
}
