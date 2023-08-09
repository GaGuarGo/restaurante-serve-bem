// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:serve_bem_app/helpers/color_helper.dart';

import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:serve_bem_app/admin/blocs/settings_admin_bloc.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';
import 'package:serve_bem_app/models/menu_model.dart';
import 'package:serve_bem_app/models/user_model.dart';
import 'package:serve_bem_app/screens/cardapio_screen.dart';
import 'package:serve_bem_app/screens/menu_screen.dart';
import 'package:serve_bem_app/screens/order_screen.dart';
import 'package:serve_bem_app/screens/perfil_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController();
  int _index = 0;

  String url = "";

  List<Map<String, dynamic>> pedidos = [];

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

  final _settingsBloc = SettingBloc();

  @override
  void initState() {
    super.initState();
    mudarCores();
    setState(() {
      url = MenuModel.of(context).fotoCard;
    });

    UserModel.of(context).addListener(() {
      if (mounted) {
        setState(() {
          pedidos = UserModel.of(context).pedindo;
        });
      }
    });
    //UserModel.of(context).signOut(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: GNav(
        rippleColor: Colors.grey[300]!,
        hoverColor: Colors.grey[100]!,
        gap: 8,
        activeColor: Colors.black,
        iconSize: 24,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        duration: Duration(milliseconds: 400),
        tabBackgroundColor: Colors.grey[100]!,
        color: Colors.black,
        tabs: [
          GButton(
            icon: Icons.chrome_reader_mode,
            text: 'Menu',
          ),
          GButton(
            icon: CupertinoIcons.cart_fill_badge_plus,
            text: 'Pedidos',
          ),
          GButton(
            icon: CupertinoIcons.book_solid,
            text: 'Cardápio',
          ),
          GButton(
            icon: CupertinoIcons.person,
            text: 'Perfil',
          ),
        ],
        selectedIndex: _index,
        onTabChange: (index) {
          setState(() {
            _index = index;
          });
          _pageController.animateToPage(_index,
              duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        },
      ),
      body: StreamBuilder<Map<String, dynamic>>(
          stream: _settingsBloc.outSettings,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(MyColors.backGround)),
              );
            } else {
              return PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: [
                  MenuScreen(
                    pedidos: pedidos,
                    homeController: _pageController,
                    pageIndex: _index,
                    onSuccess: onSucess,
                    telefone: snapshot.data!["telefoneContato"],
                    localizacao: snapshot.data!['localizacao'],
                  ),
                  OrderScreen(),
                  CardapioScreen(),
                  PerfilScreen(),
                ],
              );
            }
          }),
    );
  }

  onSucess() {
    setState(() {
      _index = 1;
    });
    _pageController.animateToPage(_index,
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);
  }
}
