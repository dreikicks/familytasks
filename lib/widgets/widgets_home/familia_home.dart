import 'package:flutter/material.dart';
import '../../model/familia.dart';
import '../familia_snapshots.dart';
import '../lista_tareas_snapshots.dart';

class WidgetHomeFamilia extends StatelessWidget {
  const WidgetHomeFamilia({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    return Column(
      children: [
        Row(
          children: const [
            Padding(
              padding: EdgeInsets.only(top: 30, bottom: 15),
              child: Text(
                "Mi Familia hoy",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 83, 122, 118)),
              ),
            ),
          ],
        ),
        Stack(children: [
          Container(
            height: 220,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 209, 227, 225),
              borderRadius: BorderRadius.all(Radius.circular(14)),
              boxShadow: [
                BoxShadow(color: Color.fromARGB(115, 175, 175, 175), offset: Offset(0, 6), blurRadius: 6),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: FamiliaSnapshots(
                idFamilia: "ndvkGX5jcyzEkRC3QmoO",
                builder: (Familia familia) {
                  final miembros = familia.miembros;
                  return ListaTareasSnapshots(
                      idFamilia: 'ndvkGX5jcyzEkRC3QmoO',
                      builder: (tareas) {
                        return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: miembros.length,
                            itemBuilder: (context, index) {
                              final miembro = miembros[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 140,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(155, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 7, bottom: 7, left: 7),
                                        child: Row(
                                          children: [
                                            Text(miembro.nombre,
                                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16), overflow: TextOverflow.clip,),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          child: MediaQuery.removePadding(
                                        removeTop: true,
                                        context: context,
                                        child: ListView.builder(
                                            itemCount: tareas.length,
                                            itemBuilder: (context, index2) {
                                              final tarea = tareas[index2];
                                              DateTime dl = tarea.deadline;
                                              if (tarea.toca[index] == true &&
                                                  DateTime(dl.year, dl.month, dl.day) ==
                                                      DateTime(today.year, today.month, today.day)) {
                                                return ListTile(
                                                  contentPadding: const EdgeInsets.all(1),
                                                  horizontalTitleGap: 0,
                                                  minLeadingWidth: 15,
                                                  visualDensity: const VisualDensity(vertical: -4, horizontal: 4),
                                                  leading: tarea.hecho[index]
                                                      ? const Icon(
                                                          Icons.check_box_outlined,
                                                          size: 15,
                                                        )
                                                      : const Icon(
                                                          Icons.check_box_outline_blank,
                                                          size: 15,
                                                        ),
                                                  title: Text(
                                                    tarea.nombre,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(fontSize: 15),
                                                  ),
                                                );
                                              }
                                              return Container();
                                            }),
                                      ))
                                    ]),
                                  ),
                                ),
                              );
                            });
                      });
                },
              ),
            ),
          ),
          Align(
            heightFactor: 6.3,
            alignment: const Alignment(1.02, 1.05),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  '/FamilyScreen',
                );
              },
              child: Container(
                width: 37,
                height: 37,
                decoration: const BoxDecoration(color: Color.fromARGB(255, 83, 122, 118), shape: BoxShape.circle),
                child: Stack(
                  alignment: Alignment.center,
                  children: const [
                    Icon(
                      Icons.emoji_events,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          )
        ]),
      ],
    );
  }
}
