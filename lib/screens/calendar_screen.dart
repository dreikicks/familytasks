import 'package:family_tasks/model/familia.dart';
import 'package:family_tasks/model/tarea.dart';
import 'package:family_tasks/widgets/familia_snapshots.dart';
import 'package:family_tasks/widgets/lista_tareas_snapshots.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

DateTime today = DateTime.now();
DateTime _focusedDay = DateTime.now();
DateTime? _selectedDate;
var userPos = 0;
final userId = user.uid;
final user = FirebaseAuth.instance.currentUser!;

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  void initState() {
    super.initState();
    _selectedDate = _focusedDay;
  }

  var admin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendario"),
      ),
      body: SingleChildScrollView(
        child: DecoratedBox(
          decoration: const BoxDecoration(color: Color.fromARGB(255, 255, 255, 255)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TableCalendar(
                    calendarStyle: const CalendarStyle(
                        selectedDecoration:
                            BoxDecoration(color: Color.fromARGB(255, 182, 202, 200), shape: BoxShape.circle)),
                    rowHeight: 50,
                    headerVisible: true,
                    calendarFormat: CalendarFormat.month,
                    availableGestures: AvailableGestures.all,
                    focusedDay: _focusedDay,
                    firstDay: DateTime.utc(_focusedDay.year),
                    lastDay: DateTime.utc(_focusedDay.year + 1),
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDate, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      if (!isSameDay(_selectedDate, selectedDay)) {
                        // Call `setState()` when updating the selected day
                        setState(() {
                          _selectedDate = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      }
                    },
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, day, events) {
                        return ListaTareasSnapshots(
                          idFamilia: "ndvkGX5jcyzEkRC3QmoO",
                          builder: (tareas) {
                            if(admin){
                              for (var i = 0; i < tareas.length; i++) {
                              DateTime dl = (tareas[i].deadline);
                              if (DateTime(day.year, day.month, day.day) == DateTime(dl.year, dl.month, dl.day)) {
                                return Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 252, 190, 119), shape: BoxShape.circle),
                                );
                              }
                            }
                            return Container();
                            } else{
                              for (var i = 0; i < tareas.length; i++) {
                              DateTime dl = (tareas[i].deadline);
                              if (tareas[i].toca[userPos] == true &&
                                  DateTime(day.year, day.month, day.day) == DateTime(dl.year, dl.month, dl.day)) {
                                return Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 252, 190, 119), shape: BoxShape.circle),
                                );
                              }
                            }
                            return Container();
                            }
                            
                          },
                        );
                      },
                    )),
                const SizedBox(height: 25),
                SizedBox(
                  child: FamiliaSnapshots(
                    idFamilia: "ndvkGX5jcyzEkRC3QmoO",
                    builder: (Familia familia) {
                      for (var i = 0; i < familia.miembros.length; i++) {
                        if (familia.miembros[i].uid == userId) {
                          userPos = i;
                          admin = familia.miembros[i].admin;
                        }
                      }

                      return Row(
                        children: [
                          Text(
                            "Tareas para el día ${_selectedDate!.day}",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 83, 122, 118)),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: const Color.fromARGB(255, 209, 227, 225)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FamiliaSnapshots(
                        idFamilia: 'ndvkGX5jcyzEkRC3QmoO',
                        builder: (Familia familia) {
                          final miembros = familia.miembros;
                          return ListaTareasSnapshots(
                            idFamilia: "ndvkGX5jcyzEkRC3QmoO",
                            builder: (tareas) {
                              return ListView.builder(
                                itemCount: tareas.length,
                                itemBuilder: (context, index) {
                                  bool todoshecho = false;
                                  var numhechos = 0;
                                  final tarea = tareas[index];
                                  List<HechoFamiliar> listaQuienToca = quienLeToca(miembros, tarea);

                                  for (var i = 0; i < listaQuienToca.length; i++) {
                                    if (listaQuienToca[i].hecho) {
                                      numhechos++;
                                    }
                                  }

                                  if (numhechos == listaQuienToca.length) {
                                    todoshecho = true;
                                  }

                                  DateTime dl = (tarea.deadline);

                                  if (admin) {
                                    if (DateTime(dl.year, dl.month, dl.day) ==
                                        DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day)) {
                                      return ListTile(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                            '/DetallesTasks',
                                            arguments: tarea.id,
                                          );
                                        },
                                        leading: const Icon(Icons.arrow_forward),
                                        title: Text(
                                          tarea.nombre,
                                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                                        ),
                                        subtitle: SizedBox(
                                            height: 20,
                                            width: 1000,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: listaQuienToca.length,
                                              itemBuilder: (context, index) {
                                                final miembroFamilia = listaQuienToca[index];

                                                if (miembroFamilia.hecho) {
                                                  numhechos++;
                                                }

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
                                            )),
                                      );
                                    }

                                    return Container();
                                  } else {
                                    if (tarea.toca[userPos] == true &&
                                        DateTime(dl.year, dl.month, dl.day) ==
                                            DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day)) {
                                      return ListTile(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                            '/DetallesTasks',
                                            arguments: tarea.id,
                                          );
                                        },
                                        tileColor: const Color.fromARGB(255, 214, 214, 214),
                                        leading: todoshecho
                                            ? const Icon(
                                                Icons.circle,
                                                color: Colors.black45,
                                                size: 18,
                                              )
                                            : const Icon(
                                                Icons.circle_outlined,
                                                color: Colors.black45,
                                                size: 18,
                                              ),
                                        title: Text(
                                          tarea.nombre,
                                          style: const TextStyle(fontSize: 17),
                                        ),
                                        subtitle: SizedBox(
                                            height: 20,
                                            width: 1000,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: listaQuienToca.length,
                                              itemBuilder: (context, index) {
                                                final miembroFamilia = listaQuienToca[index];

                                                if (miembroFamilia.hecho) {
                                                  numhechos++;
                                                }

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
                                            )),
                                      );
                                    }

                                    return Container();
                                  }
                                },
                              );
                            },
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
