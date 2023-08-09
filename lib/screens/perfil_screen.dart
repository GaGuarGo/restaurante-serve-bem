// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_final_fields, deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:serve_bem_app/models/user_model.dart';
import 'package:serve_bem_app/tabs/perfil_tab.dart';
import '../helpers/color_helper.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({Key? key}) : super(key: key);

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  Widget _title({required String text}) => Container(
        margin: const EdgeInsets.only(top: 4.0),
        child: Text(
          text,
          style: TextStyle(
              color: Colors.black26,
              fontWeight: FontWeight.w400,
              fontSize: MediaQuery.of(context).size.width * 0.03),
        ),
      );

  Widget _subTitle({required String text}) => Container(
        margin: const EdgeInsets.symmetric(vertical: 1.0),
        child: Text(
          text,
          style: TextStyle(
              color: Colors.black26,
              fontWeight: FontWeight.w300,
              fontSize: MediaQuery.of(context).size.width * 0.05),
        ),
      );

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
        builder: (context, snapshot, model) {
      return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0.0,
            centerTitle: true,
            backgroundColor: Colors.white,
            title: SizedBox(
              width: MediaQuery.of(context).size.width * 0.35,
              child: Image.asset(
                'assets/logoof.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          body: SafeArea(
            child: Center(
              child: model.userData.isNotEmpty
                  ? Column(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.person_alt_circle_fill,
                                color: MyColors.backGround,
                                size: MediaQuery.of(context).size.width * 0.3,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Bem-vindo, ${model.userData["nome"]}!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: MyColors.backGround,
                                      fontWeight: FontWeight.w300,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.08),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.1),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _title(text: "Email:"),
                                    _subTitle(text: model.userData["email"]),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    _title(text: "Celular:"),
                                    _subTitle(text: model.userData["celular"]),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    _title(text: "Endereço:"),
                                    _subTitle(
                                        text: '${model.userData["endereco"]}'),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    model.userData["endereco2"] != ""
                                        ? _title(text: "Segundo Endereço:")
                                        : Container(),
                                    model.userData["endereco2"] != ""
                                        ? _subTitle(
                                            text: model.userData["endereco2"])
                                        : Container()
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                width: MediaQuery.of(context).size.width * 0.6,
                                margin: EdgeInsets.symmetric(vertical: 12),
                                child: RaisedButton(
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  color: Color.fromARGB(255, 255, 68, 0),
                                  //controller: _buttonController,
                                  child: Text(
                                    'Atualizar Informações',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.045,
                                    ),
                                  ),

                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => PerfilTab());
                                  },
                                ),
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                width: MediaQuery.of(context).size.width * 0.3,
                                margin: EdgeInsets.symmetric(vertical: 12),
                                child: RaisedButton(
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),

                                  color: Colors.white,
                                  //controller: _buttonController,
                                  child: !_isLoading == true
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Sair',
                                              style: TextStyle(
                                                color: MyColors.backGround,
                                                fontWeight: FontWeight.w400,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.045,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Icon(
                                              Icons.exit_to_app,
                                              color: MyColors.backGround,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.045,
                                            )
                                          ],
                                        )
                                      : SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      Colors.white),
                                            ),
                                          ),
                                        ),
                                  onPressed: () {
                                    model.signOut(context: context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.all(8),
                          alignment: Alignment.center,
                          child: Text(
                            "Renicialize o app para poder ver as suas informações :)",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: CupertinoColors.activeGreen,
                                fontWeight: FontWeight.w300,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05),
                          ),
                        ),
                      ],
                    ),
            ),
          ));
    });
  }
}
