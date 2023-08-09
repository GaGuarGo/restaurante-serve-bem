// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:serve_bem_app/admin/tabs/users_tab_admin.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';
import 'package:serve_bem_app/models/user_model.dart';

import '../blocs/users_admin_bloc.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final _userBloc = UserAdminBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.exit_to_app_rounded,
              color: MyColors.backGround,
            ),
            onPressed: () {
              UserModel.of(context).signOut(context: context);
            },
          )
        ],
        centerTitle: true,
        backgroundColor: Colors.grey.shade800,
        elevation: 0.0,
        title: SizedBox(
          width: MediaQuery.of(context).size.width * 0.35,
          child: Image.asset(
            'assets/logoof.png',
            fit: BoxFit.fill,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            margin: EdgeInsets.symmetric(horizontal: 6.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  hintText: 'Pesquisar Clientes',
                  hintStyle: TextStyle(color: Colors.white),
                  icon: Icon(Icons.search, color: Colors.white),
                  border: InputBorder.none),
              onChanged: _userBloc.onChangedSearch,
            ),
          ),
          Expanded(
            child: StreamBuilder<List>(
              stream: _userBloc.outUsers,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(MyColors.backGround),
                    ),
                  );
                } else if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'Nenhum Usuário Encontrado',
                      style: TextStyle(color: MyColors.backGround),
                    ),
                  );
                } else {
                  return ListView(
                    children: snapshot.data!
                        .map((user) => UsersTab(
                              user: user,
                            ))
                        .toList(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
