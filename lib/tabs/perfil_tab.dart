// ignore_for_file: prefer_const_constructors, deprecated_member_use, prefer_final_fields, use_key_in_widget_constructors
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:serve_bem_app/models/user_model.dart';
import 'package:serve_bem_app/widgets/changeField_widget.dart';

class PerfilTab extends StatefulWidget {
  @override
  State<PerfilTab> createState() => _PerfilTabState();
}

class _PerfilTabState extends State<PerfilTab> {
  bool _changeName = false;
  bool _addAddress = false;
  bool _addPhone = false;
  bool _changeAddress = false;
  bool _changeAdedAddress = false;

  final _newName = TextEditingController();
  final _newAddress = TextEditingController();
  final _secondAddress = TextEditingController();
  final _newPhone = TextEditingController();

  String result = "";

  void _sendData() {
    final Map<String, dynamic> data;

    if (_newName.text.isNotEmpty) {
      data = {"nome": _newName.text};

      UserModel.of(context)
          .updateInfo(data: data, onSuccess: onSuccess, onFail: onFail);
    } else if (_newAddress.text.isNotEmpty) {
      data = {"endereco": _newAddress.text};

      UserModel.of(context)
          .updateInfo(data: data, onSuccess: onSuccess, onFail: onFail);
    } else if (_secondAddress.text.isNotEmpty) {
      data = {"endereco2": _secondAddress.text};

      UserModel.of(context)
          .updateInfo(data: data, onSuccess: onSuccess, onFail: onFail);
    } else if (_newPhone.text.isNotEmpty) {
      data = {"celular": _newPhone.text};

      UserModel.of(context)
          .updateInfo(data: data, onSuccess: onSuccess, onFail: onFail);
    } else {
      onFail();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
        builder: (context, snapshot, model) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          "*Obs*: Mudar um campo por vez!",
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Fechar",
                style: TextStyle(
                  color: Colors.red,
                ),
              )),
          TextButton(
              onPressed: _sendData,
              child: Text(
                "Salvar",
                style: TextStyle(
                  color: Colors.blue,
                ),
              )),
        ],
        content: result.isEmpty
            ? SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ChangeField(
                      change: _changeName,
                      changeText: "Mudar Nome",
                      labelText: 'Digite seu novo Nome',
                      controller: _newName,
                      hintText: '',
                      textType: TextInputType.name,
                      maxLines: 50,
                    ),
                    SizedBox(
                      height: 6.0,
                    ),
                    ChangeField(
                      change: _changeAddress,
                      changeText: "Mudar Primeiro Endereço",
                      labelText: 'Digite seu novo Endereço',
                      controller: _newAddress,
                      hintText: 'Ex: Bairo ABC, Rua DEFG 520',
                      textType: TextInputType.streetAddress,
                      maxLines: 50,
                    ),
                    SizedBox(
                      height: 6.0,
                    ),
                    model.userData['endereco2'] == ''
                        ? ChangeField(
                            change: _addAddress,
                            changeText: "Adicionar Segundo Endereço",
                            labelText: 'Digite seu segundo endereço:',
                            controller: _secondAddress,
                            hintText: 'Ex: Bairo ABC, Rua DEFG 520',
                            textType: TextInputType.streetAddress,
                            maxLines: 50,
                          )
                        : ChangeField(
                            change: _changeAdedAddress,
                            changeText: "Mudar Segundo Endereço",
                            labelText: 'Digite seu segundo endereço:',
                            controller: _secondAddress,
                            hintText: 'Ex: Bairo ABC, Rua DEFG 520',
                            textType: TextInputType.streetAddress,
                            maxLines: 50,
                          ),
                    SizedBox(
                      height: 6.0,
                    ),
                    ChangeField(
                      change: _addPhone,
                      changeText: "Mudar Telefone",
                      labelText: 'Digite seu novo número',
                      controller: _newPhone,
                      hintText: '11965821478',
                      textType: TextInputType.number,
                      maxLines: 11,
                    ),
                    model.userData['endereco2'] != ''
                        ? RemoveSecondAddress(
                            onSuccess: onSuccess, onFail: onFail)
                        : Container(),
                  ],
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(8),
                    alignment: Alignment.center,
                    child: Text(
                      result,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: CupertinoColors.activeGreen,
                          fontWeight: FontWeight.w300,
                          fontSize: MediaQuery.of(context).size.width * 0.05),
                    ),
                  ),
                ],
              ),
      );
    });
  }

  /*
  Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(MyColors.backGround)),
              ),

  */

  void onSuccess() {
    setState(() {
      result =
          'Dados atualizados com Sucesso, reinicie o app para ver as mudanças!';
      _changeName = false;
      _addAddress = false;
      _addPhone = false;
      _changeAddress = false;
      _changeAdedAddress = false;

      _newName.clear();

      _newAddress.clear();

      _newPhone.clear();

      _secondAddress.clear();
    });
  }

  void onFail() {
    setState(() {
      result = 'Erro ao Atualizar os Dados, Tente Novamente!';
    });
  }
}
/*

  Mudar no Cadastro: Juntar o numero da residencia no mesmo campo que o endereço no firebase

*/