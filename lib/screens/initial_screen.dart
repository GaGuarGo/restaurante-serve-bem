// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:serve_bem_app/blocs/login_bloc.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';
import 'package:serve_bem_app/models/user_model.dart';
import 'package:serve_bem_app/screens/home_screen.dart';
import 'package:serve_bem_app/screens/login_screen.dart';
import 'package:serve_bem_app/screens/signUp_screen.dart';

import '../admin/screens/home_screen_admin.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  final loginBloc = LoginBloc();

  final _userModel = UserModel();

  @override
  void initState() {
  
    super.initState();

    mudarCores();

    loginBloc.outState.listen((state) async {
      switch (state) {
        case LoginState.SUCCESSADM:
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreenADM()));
          break;
        case LoginState.SUCCESS:
          _userModel.loadCurrentUser();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()));

          break;
        case LoginState.FAIL:

        case LoginState.LOADING:
        case LoginState.IDLE:
      }
    });
  }

  void mudarCores() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarContrastEnforced: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<LoginState>(
          stream: loginBloc.outState,
          initialData: LoginState.IDLE,
          builder: (context, snapshot) {
            switch (snapshot.data) {
              case LoginState.LOADING:
                return Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(MyColors.backGround),
                  ),
                );

              case LoginState.SUCCESS:
              case LoginState.SUCCESSADM:
              case LoginState.IDLE:
              case LoginState.FAIL:
              default:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.82,
                      height: MediaQuery.of(context).size.height * 0.30,
                      child: Image.asset(
                        "assets/logoof.png",
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.09,
                      margin: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 40),
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        color: MyColors.backGround,
                        child: const Center(
                          child: Text(
                            "Entrar",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        },
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.09,
                      margin: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 40),
                      // ignore: deprecated_member_use
                      child: OutlineButton(
                        highlightedBorderColor: MyColors.backGround,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        borderSide:
                            const BorderSide(color: MyColors.backGround),
                        child: const Center(
                          child: Text(
                            "Cadastrar",
                            style: TextStyle(
                                color: MyColors.backGround,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()));
                        },
                      ),
                    )
                  ],
                );
            }
          }),
    );
  }
}
