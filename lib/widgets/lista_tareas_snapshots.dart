import 'package:family_tasks/model/tarea.dart';
import 'package:flutter/material.dart';

class ListaTareasSnapshots extends StatelessWidget {
  final String idFamilia;
  final Widget Function(List<Tarea>) builder;

  const ListaTareasSnapshots({
    super.key,
    required this.idFamilia,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: dbGetTareasFamilia(idFamilia),
      builder: (BuildContext context, AsyncSnapshot<List<Tarea>> snapshot) {
        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error.toString());
        }
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        final listTareas = snapshot.data!;
        // final miembros = familia.miembros;
        return builder(listTareas);
      },
    );
  }
}
