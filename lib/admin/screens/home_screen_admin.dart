// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:serve_bem_app/admin/blocs/settings_admin_bloc.dart';
import 'package:serve_bem_app/admin/screens/screen_grafico/grafico_screen_admin.dart';
import 'package:serve_bem_app/admin/screens/menu_screen_adm.dart';
import 'package:serve_bem_app/admin/screens/pedidos_screen_admin.dart';
import 'package:serve_bem_app/admin/screens/settings_screen_admin.dart';
import 'package:serve_bem_app/admin/screens/users_screen_admin.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';

class HomeScreenADM extends StatefulWidget {
  const HomeScreenADM({Key? key}) : super(key: key);

  @override
  State<HomeScreenADM> createState() => _HomeScreenADMState();
}

class _HomeScreenADMState extends State<HomeScreenADM> {
  final _pageController = PageController();
  int _index = 0;

  final _settingsBloc = SettingBloc();

  mudarCores() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Color.fromARGB(255, 66, 66, 66),
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Color.fromARGB(255, 66, 66, 66),
          systemNavigationBarIconBrightness: Brightness.light,
          systemNavigationBarContrastEnforced: true),
    );
  }

  @override
  void initState() {
    super.initState();
    mudarCores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: GNav(
          textStyle: TextStyle(color: Colors.white),
          rippleColor: Colors.grey[300]!,
          hoverColor: Colors.grey[100]!,
          gap: 8,
          activeColor: Colors.white,
          iconSize: 24,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          duration: Duration(milliseconds: 400),
          tabBackgroundColor: MyColors.backGround,
          color: MyColors.backGround,
          // ignore: prefer_const_literals_to_create_immutables
          tabs: [
            GButton(
              icon: CupertinoIcons.person_2_square_stack,
              text: '',
            ),
            GButton(
              icon: Icons.list_alt_rounded,
              text: '',
            ),
            GButton(
              icon: Icons.menu_book_rounded,
              text: '',
            ),
            GButton(
              icon: Icons.settings,
              text: '',
            ),
            GButton(
              icon: CupertinoIcons.graph_square,
              text: '',
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
                  UsersScreen(),
                  PedidosScreenADM(),
                  MenuScreenADM(
                    isOpen: snapshot.data!['funcionamentoState'],
                  ),
                  SettingsScrennADM(),
                  GraficoScreenADM(),
                ],
              );
            }
          }),
    );
  }
}
