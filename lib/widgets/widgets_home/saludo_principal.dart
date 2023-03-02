import 'package:flutter/material.dart';
import '../../model/familia.dart';
import '../lista_tareas_snapshots.dart';

class SaludoPrincipal extends StatelessWidget {
  final Familia familia;
  final int userPos;
  const SaludoPrincipal({super.key, required this.familia, required this.userPos});

  @override
  Widget build(BuildContext context) {
    int numTareas = 0;
    DateTime today = DateTime.now();
    return Row(children: [
      Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hola, ${familia.miembros[userPos].nombre}",
            style: Theme.of(context).textTheme.headlineMedium,
            overflow: TextOverflow.ellipsis,
          ),
          ListaTareasSnapshots(
              idFamilia: "ndvkGX5jcyzEkRC3QmoO",
              builder: (tareas) {
                numTareas = 0;
                for (final tarea in tareas) {
                  DateTime dl = tarea.deadline;
                  if (tarea.toca[userPos] == true &&
                      tarea.hecho[userPos] == false &&
                      DateTime(dl.year, dl.month, dl.day) == DateTime(today.year, today.month, today.day)) {
                    numTareas++;
                  }
                }

                if(numTareas < 1){
                  return const Text("Parece que no tienes más tareas hoy");
                } else{
                  return Text("Tareas para hoy: $numTareas tareas");
                }
                
              })
        ],
      ),
    ]);
  }
}
