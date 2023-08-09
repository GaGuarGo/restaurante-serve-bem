// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';
import 'package:serve_bem_app/models/user_model.dart';

class ForgetPassword extends StatefulWidget {
  Function forget;
  ForgetPassword({required this.forget});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return UserModel.of(context).isLoading == false
        ? Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: const Text(
                    "**OBS: Coloque uma senha maior que 6 dígitos!**",
                    textAlign: TextAlign.center,
                    ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 18.0),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      focusColor: Color.fromARGB(255, 255, 68, 0),
                      floatingLabelStyle: TextStyle(
                        color: Color.fromARGB(255, 255, 68, 0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Color.fromARGB(255, 255, 68, 0),
                      )),
                      labelText: "Digite o email da conta cadastrada!",
                      labelStyle: TextStyle(),
                      icon: Icon(
                        CupertinoIcons.person,
                      ),
                      border: UnderlineInputBorder()),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      widget.forget();
                    },
                    icon: Icon(
                      Icons.exit_to_app,
                      color: MyColors.backGround,
                      size: MediaQuery.of(context).size.width * 0.075,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width * 0.7,
                    margin: EdgeInsets.symmetric(vertical: 4),
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      color: Color.fromARGB(255, 255, 68, 0),
                      child: Text(
                        'Enviar email de recuperação',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: MediaQuery.of(context).size.width * 0.045,
                        ),
                      ),
                      onPressed: () {
                        if (_emailController.text.isEmpty) {
                          onFail();
                        } else {
                          UserModel.of(context).recoverPass(
                              email: _emailController.text,
                              onSuccess: onSuccess,
                              onFail: onFail);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(MyColors.backGround),
              ),
            ),
          );
  }

  onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        "Email enviado com Sucesso!",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
    ));
    _emailController.clear();
  }

  onFail() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        "Erro ao enviar email!",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    ));
  }
}
