import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../model/familia.dart';
import '../../model/tarea.dart';
import '../familia_snapshots.dart';
import '../lista_tareas_snapshots.dart';

class WidgetTareasHoy extends StatelessWidget {
  final bool admin;
  final int userPos;
  final int contUsers;

  const WidgetTareasHoy({super.key, required this.admin, required this.userPos, required this.contUsers});

  @override
  Widget build(BuildContext context) {
    var db = FirebaseFirestore.instance;
    DateTime today = DateTime.now();
    return Column(
      children: [
        Row(
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Tus tareas de hoy",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 83, 122, 118)),
              ),
            ),
          ],
        ),
        Stack(children: [
          Container(
            height: 250,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 209, 227, 225),
              borderRadius: BorderRadius.all(Radius.circular(14)),
              boxShadow: [
                BoxShadow(color: Color.fromARGB(115, 175, 175, 175), offset: Offset(0, 6), blurRadius: 6),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FamiliaSnapshots(
                  idFamilia: 'ndvkGX5jcyzEkRC3QmoO',
                  builder: (Familia familia) {
                    final miembros = familia.miembros;
                    return ListaTareasSnapshots(
                      idFamilia: "ndvkGX5jcyzEkRC3QmoO",
                      builder: (tareas) {
                        return MediaQuery.removePadding(
                          removeTop: true,
                          context: context,
                          child: ListView.builder(
                            itemCount: tareas.length,
                            itemBuilder: (context, index) {
                              final tarea = tareas[index];
                              DateTime dl = tarea.deadline;
                              List<HechoFamiliar> listaQuienToca = quienLeToca(miembros, tarea);
                              if (tarea.toca[userPos] == true &&
                                  DateTime(dl.year, dl.month, dl.day) == DateTime(today.year, today.month, today.day)) {
                                return Column(
                                  children: [
                                    ListTile(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                            '/DetallesTasks',
                                            arguments: tarea.id,
                                          );
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        leading: Checkbox(
                                          value: tarea.hecho[userPos],
                                          onChanged: (bool? value) {
                                            final hechoNew = [];
                                            for (var i = 0; i < tarea.hecho.length; i++) {
                                              if (i == userPos) {
                                                hechoNew.add(!tarea.hecho[i]);
                                              } else {
                                                hechoNew.add(tarea.hecho[i]);
                                              }
                                            }
                                            db
                                                .doc("/familias/ndvkGX5jcyzEkRC3QmoO/tareas/${tarea.id}")
                                                .update({'hecho': hechoNew});
                                          },
                                        ),
                                        title: Text(
                                          tarea.nombre,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        // tileColor:
                                        //     Color.fromARGB(235, 233, 0, 0),
                                        subtitle: SizedBox(
                                            height: 20,
                                            width: 1000,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: listaQuienToca.length,
                                              itemBuilder: (context, index) {
                                                final miembroFamilia = listaQuienToca[index];
                                                return Row(children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 10),
                                                    child: Text(miembroFamilia.nombre,
                                                        style: TextStyle(
                                                            color:
                                                                miembroFamilia.hecho ? Colors.green : Colors.black45)),
                                                  ),
                                                ]);
                                              },
                                            ))),
                                    const SizedBox(height: 5)
                                  ],
                                );
                              }
                              return Container();
                            },
                          ),
                        );
                      },
                    );
                  }),
            ),
          ),
          Align(
            heightFactor: 7,
            alignment: const Alignment(1.02, 1.1),
            child: Visibility(
              visible: admin,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/AnadirTasks',
                    arguments: contUsers
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
                        Icons.add,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ]),
      ],
    );
  }
}
