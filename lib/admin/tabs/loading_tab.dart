import 'package:flutter/material.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';

class LoadingTab extends StatefulWidget {
  const LoadingTab({Key? key}) : super(key: key);

  @override
  State<LoadingTab> createState() => _LoadingTabState();
}

class _LoadingTabState extends State<LoadingTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(8),
                width: MediaQuery.of(context).size.width * 0.7,
                child: Image.asset(
                  'assets/logoof.png',
                  filterQuality: FilterQuality.high,
                )),
            const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(MyColors.backGround),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                "Fazendo Relatório...",
                style: TextStyle(
                  color: MyColors.backGround,
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width * 0.08,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
