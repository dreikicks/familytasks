import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../lista_tareas_snapshots.dart';

class WidgetCalendarioSemanal extends StatefulWidget {
  final int userPos;
  final bool admin;
  const WidgetCalendarioSemanal({super.key, required this.userPos, required this.admin});

  @override
  State<WidgetCalendarioSemanal> createState() => _WidgetCalendarioSemanalState();
}

class _WidgetCalendarioSemanalState extends State<WidgetCalendarioSemanal> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Row(
            children: const [
              Text(
                "Tareas de la semana",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 83, 122, 118)),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Stack(children: [
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 209, 227, 225),
              boxShadow: [
                BoxShadow(color: Color.fromARGB(115, 175, 175, 175), offset: Offset(0, 6), blurRadius: 6),
              ],
              borderRadius: BorderRadius.all(Radius.circular(14)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TableCalendar(
                  calendarStyle: const CalendarStyle(
                      selectedDecoration: BoxDecoration(
                          // color: Color.fromARGB(255, 165, 121, 164),
                          color: Color.fromARGB(255, 252, 190, 119),
                          shape: BoxShape.circle)),
                  rowHeight: 60,
                  headerVisible: false,
                  calendarFormat: CalendarFormat.week,
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
                          if(widget.admin){
                            for (var i = 0; i < tareas.length; i++) {
                            DateTime dl = (tareas[i].deadline);
                            if (DateTime(day.year, day.month, day.day) == DateTime(dl.year, dl.month, dl.day)) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 52,
                                  ),
                                  Container(
                                    width: 7.5,
                                    height: 7.5,
                                    decoration: const BoxDecoration(
                                        color: Color.fromARGB(255, 65, 65, 65), shape: BoxShape.circle),
                                  ),
                                ],
                              );
                            }
                          }
                          return Container();
                          } else{
                            for (var i = 0; i < tareas.length; i++) {
                            DateTime dl = (tareas[i].deadline);
                            if (tareas[i].toca[widget.userPos] == true &&
                                DateTime(day.year, day.month, day.day) == DateTime(dl.year, dl.month, dl.day)) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 52,
                                  ),
                                  Container(
                                    width: 7.5,
                                    height: 7.5,
                                    decoration: const BoxDecoration(
                                        color: Color.fromARGB(255, 65, 65, 65), shape: BoxShape.circle),
                                  ),
                                ],
                              );
                            }
                          }
                          return Container();
                          }
                        },
                      );
                    },
                  )),
            ),
          ),
          Align(
            heightFactor: 2.8,
            alignment: const Alignment(1.02, 1.2),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  '/CalendarScreen',
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
                      Icons.calendar_month,
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
