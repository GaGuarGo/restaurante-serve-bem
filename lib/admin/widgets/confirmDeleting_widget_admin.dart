// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:serve_bem_app/admin/blocs/grafico_admin_bloc.dart';
import 'package:serve_bem_app/helpers/color_helper.dart';

class ConfirmingDeleting extends StatefulWidget {
  const ConfirmingDeleting({Key? key}) : super(key: key);

  @override
  State<ConfirmingDeleting> createState() => _ConfirmingDeletingState();
}

class _ConfirmingDeletingState extends State<ConfirmingDeleting> {
  final _graficoBloc = GraficoBlocADM();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey.shade800,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        "Você Deseja Realmente Deletar o Relatório?",
        style: TextStyle(color: MyColors.backGround),
      ),
      scrollable: false,
      content: StreamBuilder<GraficoState>(
          stream: _graficoBloc.outState,
          initialData: GraficoState.IDLE,
          builder: (context, snapshot) {
            switch (snapshot.data) {
              case GraficoState.LOADING:
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(MyColors.backGround),
                  ),
                );

              case GraficoState.SUCCESS:
                return const Text(
                  "DADOS DELETADOS COM SUCESSO!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green),
                );
              case GraficoState.FAIL:
                return const Text(
                  "ERRO AO DELETAR RELATÓRIO!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                );
              case GraficoState.IDLE:
              default:
                return const Text(
                  "Todos os dados do relatório, de todos os meses, serão deletados para sempre.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: MyColors.backGround),
                );
            }
          }),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "Fechar",
              style: TextStyle(color: Colors.red),
            )),
        TextButton(
            onPressed: () {
              _graficoBloc.deleteRelatorio();
            },
            child: const Text("Deletar")),
      ],
    );
  }
}
