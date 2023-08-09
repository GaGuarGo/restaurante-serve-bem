// ignore_for_file: prefer_const_constructors, deprecated_member_use, constant_identifier_names, must_be_immutable, use_key_in_widget_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:serve_bem_app/admin/blocs/settings_admin_bloc.dart';
import 'package:serve_bem_app/blocs/menu_bloc.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';

import 'package:serve_bem_app/models/menu_model.dart';
import 'package:serve_bem_app/models/user_model.dart';
import 'package:serve_bem_app/tabs/bebidas_tab.dart';
import 'package:serve_bem_app/tabs/menu_tab.dart';
import 'package:serve_bem_app/widgets/menu_widget.dart';
import 'package:serve_bem_app/widgets/size_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuScreen extends StatefulWidget {
  String telefone;
  String localizacao;
  late Function onSuccess;
  List<Map<String, dynamic>> pedidos;
  var homeController = PageController();
  int pageIndex;

  MenuScreen({
    required this.pedidos,
    required this.homeController,
    required this.pageIndex,
    required this.onSuccess,
    required this.telefone,
    required this.localizacao,
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  static const IconData whatsapp_rounded =
      IconData(0xf03b8, fontFamily: 'MaterialIcons');

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;

  int _selectedIndex = 0;

  final _pageController = PageController();

  String tamanho = "Pequena";

  final _settingsBloc = SettingBloc();
  final _menuBloc = MenuBloc();

  @override
  void initState() {
    super.initState();

    UserModel.of(context).addListener(() {
      if (mounted) {
        setState(() {
          widget.pedidos = UserModel.of(context).pedindo;
        });
      }
    });
    // _userModel.signOut(context: context);
  }

  List<Map<String, String>> listaOp = [];

  final _controller = DraggableScrollableController();

  _abrirWhatsApp({required String telefone}) async {
    final whatsappUrl =
        "whatsapp://send?phone=+55$telefone&text=Olá, tudo bem?";

    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  _fazerLigacao({required String telefone}) async {
    final url = "tel:$telefone";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _abrirLocalizacao({required String localizacao}) async {
    final urlMap = localizacao;
    if (await canLaunch(urlMap)) {
      await launch(urlMap);
    } else {
      throw 'Could not launch Maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MenuModel>(
        builder: (context, snapshot, model) {
      return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
              elevation: 0.0,
              centerTitle: false,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12))),
              actions: [
                IconButton(
                  onPressed: () async {
                    await _abrirWhatsApp(telefone: widget.telefone);
                  },
                  icon: Icon(
                    whatsapp_rounded,
                    color: MyColors.backGround,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await _fazerLigacao(telefone: widget.telefone);
                  },
                  icon: Icon(
                    Icons.phone,
                    color: MyColors.backGround,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await _abrirLocalizacao(localizacao: widget.localizacao);
                  },
                  icon: Icon(
                    Icons.store,
                    color: MyColors.backGround,
                  ),
                ),
              ],
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: Image.asset(
                    'assets/logoof.png',
                    fit: BoxFit.fill,
                  ),
                ),
              )),
          body: SafeArea(
              child: //MenuModel.of(context).isLoading == false?
                  Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.12,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _foodTab(Icons.food_bank, "Comida", 0),
                        _foodTab(Icons.local_drink, "Bebidas", 1),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.58,
                    child: PageView(
                      controller: _pageController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(vertical: 0),
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  'Escolha um Tamanho:',
                                  style: TextStyle(
                                    color: Color.fromARGB(221, 61, 59, 59),
                                    fontWeight: FontWeight.w200,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(),
                                alignment: Alignment.center,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 10),
                                height:
                                    MediaQuery.of(context).size.height * 0.34,
                                width: MediaQuery.of(context).size.width,
                                child: SizeChoice(value: tamanho),
                              ),
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(vertical: 0),
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  'Escolha um Prato Principal:',
                                  style: TextStyle(
                                    color: Color.fromARGB(221, 61, 59, 59),
                                    fontWeight: FontWeight.w200,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              _foodChoice(stream: _menuBloc.outPrincipalItems),
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(vertical: 4),
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  'Escolha uma Guarnição:',
                                  style: TextStyle(
                                    color: Color.fromARGB(221, 61, 59, 59),
                                    fontWeight: FontWeight.w200,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              _foodChoice(stream: _menuBloc.outGuarnicaoItems),
                            ],
                          ),
                        ),
                        BebidasTab(
                          controller: _controller,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              MenuTab(
                  pedidos: widget.pedidos,
                  tamanho: tamanho,
                  controller: _controller,
                  homeController: widget.homeController,
                  pageIndex: widget.pageIndex,
                  onSuccess: widget.onSuccess),
            ],
          )));
    });
  }

  Widget _foodChoice({required Stream<List<Map<String, dynamic>>>? stream}) =>
      Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        height: MediaQuery.of(context).size.height * 0.18,
        width: MediaQuery.of(context).size.width * 0.9,
        child: StreamBuilder<Map<String, dynamic>>(
            stream: _settingsBloc.outSettings,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(MyColors.backGround)),
                );
              } else if (snapshot.data!['funcionamentoState'] == false) {
                return Text(
                  "Estamos Fechados no Momento \n Horário de Funcionamento 11:00 - 14:30",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: MyColors.backGround,
                      fontSize: 22,
                      fontWeight: FontWeight.w700),
                );
              } else {
                return StreamBuilder<List<Map<String, dynamic>>>(
                    stream: stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation(MyColors.backGround)),
                        );
                      } else {
                        return ListView(
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data!
                              .map((op) =>
                                  MenuWidget(op: op, controller: _controller))
                              .toList(),
                        );
                      }
                    });
              }
            }),
      );

  Widget _foodTab(IconData icon, String text, int index) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
              _pageController.animateToPage(_selectedIndex,
                  duration: Duration(milliseconds: 200), curve: Curves.easeIn);
            },
            child: ClipOval(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black45, width: 0.15),
                  color: _selectedIndex == index
                      ? MyColors.backGround
                      : Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      blurStyle: BlurStyle.outer,
                      blurRadius: 2,
                    )
                  ],
                ),
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.height * 0.08,
                child: Center(
                    child: Icon(
                  icon,
                  color: _selectedIndex == index
                      ? Colors.white
                      : MyColors.backGround,
                )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              text,
              style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                  fontSize: 12),
            ),
          ),
        ],
      );
}
