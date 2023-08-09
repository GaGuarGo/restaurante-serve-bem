import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';
import 'package:serve_bem_app/models/menu_model.dart';
import 'package:serve_bem_app/models/user_model.dart';
import 'package:serve_bem_app/screens/initial_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  mudarCores();
  runApp(MyApp());
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

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModel<MenuModel>(
        model: MenuModel(),
        child: MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: MyColors.backGround,
            indicatorColor: MyColors.backGround,
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Color.fromARGB(255, 255, 68, 0),
              selectionColor: MyColors.backGround,
            ),
          ),
          home: const InitialScreen(),
        ),
      ),
    );
  }
}
