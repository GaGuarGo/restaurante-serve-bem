// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
//import 'package:flare_flutter/flare_actor.dart';

class CheckTab extends StatefulWidget {
  const CheckTab({Key? key}) : super(key: key);

  @override
  State<CheckTab> createState() => _CheckTabState();
}

class _CheckTabState extends State<CheckTab> {
  @override
  void initState() {
    
    super.initState();

    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      /*
      color: CupertinoColors.activeGreen,
      child: const Center(
        child: SizedBox(
          height: 300,
          width: 300,
          child: FlareActor(
            "assets/Check.flr",
            animation: "Check",
          ),
        ),
      ),
      */
    );
  }
}
