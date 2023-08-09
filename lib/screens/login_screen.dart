// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:serve_bem_app/admin/screens/home_screen_admin.dart';
import 'package:serve_bem_app/blocs/login_bloc.dart';
import 'package:serve_bem_app/models/user_model.dart';
import 'package:serve_bem_app/screens/home_screen.dart';
import 'package:serve_bem_app/screens/initial_screen.dart';
import 'package:serve_bem_app/tabs/forget_password_tab.dart';

import '../helpers/color_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final RoundedLoadingButtonController _buttonController =
      RoundedLoadingButtonController();

  bool _seePassword = true;
  final _loginBloc = LoginBloc();
  bool forget = false;

  mudarCores() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: MyColors.backGround,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarContrastEnforced: true),
    );
  }

  @override
  void initState() {
    super.initState();
    mudarCores();

    _loginBloc.outState.listen((state) async {
      switch (state) {
        case LoginState.SUCCESSADM:
          _buttonController.success();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreenADM()));
          break;
        case LoginState.SUCCESS:
          _buttonController.success();
          UserModel.of(context).loadCurrentUser().then((_) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          });

          break;
        case LoginState.FAIL:
          _buttonController.error();
          break;
        case LoginState.LOADING:
        case LoginState.IDLE:
      }
    });
  }

  _login() {
    _buttonController.start();
    _loginBloc.submit(onFail: () {
      _buttonController.error();
      _buttonController.reset();
    });
  }

  void _onForget() {
    setState(() {
      forget = !forget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: MyColors.backGround,
        automaticallyImplyLeading: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const InitialScreen()));
            }),
      ),
      backgroundColor: MyColors.backGround,
      body: StreamBuilder<LoginState>(
          stream: _loginBloc.outState,
          initialData: LoginState.IDLE,
          builder: (context, snapshot) {
            switch (snapshot.data) {
              case LoginState.IDLE:
              case LoginState.LOADING:
              case LoginState.SUCCESS:
              case LoginState.SUCCESSADM:
              case LoginState.FAIL:
              default:
                return Stack(
                  children: [
                    Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.10),
                        height: MediaQuery.of(context).size.height * 0.45,
                        //width: MediaQuery.of(context).size.width * 0.45,
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: [
                            Image.asset('assets/logoof.png'),
                          ],
                        )),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          //height: MediaQuery.of(context).size.height * 0.4,
                          padding: EdgeInsets.symmetric(
                              horizontal: 22, vertical: 20),
                          // margin: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(32),
                                  topRight: Radius.circular(32)),
                              color: Colors.white),
                          child: SingleChildScrollView(
                              child: forget == false
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      // ignore: prefer_const_literals_to_create_immutables
                                      children: [
                                        StreamBuilder<String>(
                                            stream: _loginBloc.outEmail,
                                            builder: (context, snapshot) {
                                              return TextField(
                                                onChanged:
                                                    _loginBloc.changeEmail,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                decoration: InputDecoration(
                                                    focusColor: Color.fromARGB(
                                                        255, 255, 68, 0),
                                                    floatingLabelStyle:
                                                        TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 255, 68, 0),
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 255, 68, 0),
                                                    )),
                                                    labelText:
                                                        "Digite seu email",
                                                    labelStyle: TextStyle(),
                                                    icon: Icon(
                                                      CupertinoIcons.person,
                                                    ),
                                                    border:
                                                        UnderlineInputBorder()),
                                              );
                                            }),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02,
                                        ),
                                        StreamBuilder<String>(
                                            stream: _loginBloc.outPassword,
                                            builder: (context, snapshot) {
                                              return TextField(
                                                onChanged:
                                                    _loginBloc.changePassword,
                                                keyboardType: TextInputType
                                                    .visiblePassword,
                                                obscureText: _seePassword,
                                                style: TextStyle(),
                                                decoration: InputDecoration(
                                                  focusColor: Color.fromARGB(
                                                      255, 255, 68, 0),
                                                  floatingLabelStyle: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 255, 68, 0),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 255, 68, 0),
                                                  )),
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      _seePassword
                                                          ? CupertinoIcons.eye
                                                          : CupertinoIcons
                                                              .eye_slash,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        _seePassword =
                                                            !_seePassword;
                                                      });
                                                    },
                                                  ),
                                                  labelText: "Digite sua senha",
                                                  labelStyle: TextStyle(),
                                                  icon: Icon(
                                                    CupertinoIcons.lock,
                                                  ),
                                                  border: UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 12.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  _onForget();
                                                },
                                                child: Text(
                                                  "Esqueci minha Senha....",
                                                  style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontStyle:
                                                          FontStyle.normal),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 12),
                                                child: StreamBuilder<bool>(
                                                    stream: _loginBloc
                                                        .outSubmitValid,
                                                    builder:
                                                        (context, snapshot) {
                                                      return RoundedLoadingButton(
                                                        resetAfterDuration:
                                                            true,
                                                        // resetDuration: Duration(
                                                        //     seconds: 4),
                                                        errorColor: Colors.red,
                                                        failedIcon: Icons.close,
                                                        valueColor:
                                                            Colors.white,
                                                        borderRadius: 12.0,
                                                        successColor:
                                                            CupertinoColors
                                                                .activeGreen,
                                                        color: Color.fromARGB(
                                                            255, 255, 68, 0),
                                                        controller:
                                                            _buttonController,
                                                        child: Text('Entrar',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.045,
                                                            )),
                                                        onPressed:
                                                            snapshot.hasData
                                                                ? _login
                                                                : null,
                                                      );
                                                    }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : ForgetPassword(
                                      forget: _onForget,
                                    )),
                        ),
                      ],
                    ),
                  ],
                );
            }
          }),
    );
  }
}
