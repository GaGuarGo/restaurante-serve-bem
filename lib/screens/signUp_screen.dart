// ignore_for_file: file_names, curly_braces_in_flow_control_structures, body_might_complete_normally_nullable, prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:serve_bem_app/blocs/signUp_bloc.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';
import 'package:serve_bem_app/models/user_model.dart';
import 'package:serve_bem_app/screens/home_screen.dart';
import 'package:serve_bem_app/screens/initial_screen.dart';
import 'package:serve_bem_app/widgets/signUpField_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _signUpBloc = SignUpBloc();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _signUpBloc.outState.listen((state) {
      switch (state) {
        case SignUpState.SUCCESS:
          // UserModel.of(context).loadCurrentUser();
          UserModel.of(context).loadCurrentUser().then((_) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          });
          break;
        case SignUpState.FAIL:
          showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                    title: Text('ERRO!'),
                    content: Text("Erro ao Cadastrar!"),
                  ));
          break;
        case SignUpState.LOADING:
        case SignUpState.IDLE:
      }
    });
  }

  String? _nameValidator(String? text) {
    if (text!.isEmpty || text.length <= 5) {
      return 'Digite um nome válido!';
    }
    return null;
  }

  String? _emailValidator(String? text) {
    if (text!.isEmpty || !text.contains("@")) {
      return 'Digite um email válido!';
    }
    return null;
  }

  String? _passValidator(String? text) {
    if (text!.isEmpty || text.length <= 5) {
      return 'Digite uma senha com pelo menos 6 caracteres!';
    }
    return null;
  }

  String? _phoneValidator(String? text) {
    if (text!.length < 11 || text.isEmpty) {
      return 'Digite um número válido!';
    }
    return null;
  }

  String? _addressValidator(String? text) {
    if (text!.isEmpty) {
      return 'Digite um endereço válido!';
    }
    return null;
  }

  String? _numberValidator(String? text) {
    if (text!.isEmpty) {
      return 'Digite um número válido!';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 255, 68, 0),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const InitialScreen()));
            }),
      ),
      body: StreamBuilder<SignUpState>(
          stream: _signUpBloc.outState,
          initialData: SignUpState.IDLE,
          builder: (context, snapshot) {
            switch (snapshot.data) {
              case SignUpState.LOADING:
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(MyColors.backGround),
                  ),
                );

              case SignUpState.IDLE:
              case SignUpState.SUCCESS:
              case SignUpState.FAIL:
              default:
                return Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          height: MediaQuery.of(context).size.height * 0.14,
                          child: Image.asset('assets/logoof.png'),
                        ),
                        SignUpField(
                          textType: TextInputType.name,
                          labelText: "Digite seu Nome Completo",
                          icon: const Icon(CupertinoIcons.pencil),
                          obscure: false,
                          controller: _nameController,
                          formatter: [],
                          hintText: '',
                          maxLength: 100,
                          stream: _signUpBloc.outName,
                          onChanged: _signUpBloc.changeName,
                          validator: _nameValidator,
                        ),
                        SignUpField(
                          textType: TextInputType.emailAddress,
                          labelText: "Digite seu email",
                          icon: const Icon(CupertinoIcons.person_fill),
                          obscure: false,
                          controller: _emailController,
                          formatter: [],
                          hintText: '',
                          maxLength: 100,
                          stream: _signUpBloc.outEmail,
                          onChanged: _signUpBloc.changeEmail,
                          validator: _emailValidator,
                        ),
                        SignUpField(
                          textType: TextInputType.visiblePassword,
                          labelText: "Digite sua senha",
                          icon: const Icon(CupertinoIcons.lock_fill),
                          obscure: true,
                          controller: _passWordController,
                          formatter: [],
                          hintText: '',
                          maxLength: 100,
                          stream: _signUpBloc.outPassword,
                          onChanged: _signUpBloc.changePassword,
                          validator: _passValidator,
                        ),
                        SignUpField(
                          textType: TextInputType.phone,
                          labelText: "Digite seu Telefone",
                          icon: const Icon(CupertinoIcons.phone_fill),
                          obscure: false,
                          controller: _phoneController,
                          formatter: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          hintText: 'Ex: 11998765678',
                          maxLength: 11,
                          stream: _signUpBloc.outPhone,
                          onChanged: _signUpBloc.changePhone,
                          validator: _phoneValidator,
                        ),
                        SignUpField(
                          textType: TextInputType.streetAddress,
                          labelText: "Digite seu Endereço",
                          icon: const Icon(CupertinoIcons.location),
                          obscure: false,
                          controller: _districtController,
                          formatter: [],
                          hintText: 'Ex: Bairro Jd. ABCDA, Rua DEFG',
                          maxLength: 100,
                          stream: _signUpBloc.outAddress,
                          onChanged: _signUpBloc.changeAddress,
                          validator: _addressValidator,
                        ),
                        SignUpField(
                          textType: TextInputType.number,
                          labelText: "Digite o N° da Residência",
                          icon: const Icon(CupertinoIcons.location),
                          obscure: false,
                          controller: _numberController,
                          formatter: [FilteringTextInputFormatter.digitsOnly],
                          hintText: '',
                          maxLength: 4,
                          stream: _signUpBloc.outNumber,
                          onChanged: _signUpBloc.changeNumber,
                          validator: _numberValidator,
                        ),
                        StreamBuilder<bool>(
                            stream: _signUpBloc.outSubmitValid,
                            builder: (context, snapshot) {
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 16),
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  //errorColor: Colors.red,
                                  // failedIcon: Icons.close,
                                  // valueColor: Colors.white,
                                  // borderRadius: 12.0,
                                  // successColor: CupertinoColors.activeGreen,
                                  color: const Color.fromARGB(255, 255, 68, 0),
                                  // controller: _buttonController,
                                  child: Text('Cadastrar',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.048,
                                      )),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      final Map<String, dynamic> userData = {
                                        "nome": _nameController.text,
                                        "email": _emailController.text,
                                        "celular": _phoneController.text,
                                        "endereco":
                                            "${_districtController.text}, ${_numberController.text}",
                                        "endereco2": ""
                                      };

                                      _signUpBloc.submit(userData: userData);
                                    }
                                  },
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                );
            }
          }),
    );
  }
}
