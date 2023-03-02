import 'package:family_tasks/model/familia.dart';
import 'package:family_tasks/widgets/familia_snapshots.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/widgets_home/calendario_semanal.dart';
import '../widgets/widgets_home/familia_home.dart';
import '../widgets/widgets_home/saludo_principal.dart';
import '../widgets/widgets_home/widget_tareas_hoy.dart';

List<Widget> usersTexts = [];

final user = FirebaseAuth.instance.currentUser!;
final userId = user.uid;
var userPos = 0;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //DateTime _defDate = DateTime(_selectedDate.year, 12, 11);
  Map<String, List> mySelectedEvents = {};

  String descTareas = "";
  List<Widget> familiares = [];

  @override
  @override
  Widget build(BuildContext context) {
    return FamiliaSnapshots(
      idFamilia: 'ndvkGX5jcyzEkRC3QmoO',
      builder: (Familia familia) {
        var admin = false;
        var contUsers = 0;
        for (var i = 0; i < familia.miembros.length; i++) {
          contUsers++;
          if (familia.miembros[i].uid == userId) {
            userPos = i;
            admin = familia.miembros[i].admin;
          }
        }

        return Scaffold(
          body: SingleChildScrollView(
            child: DecoratedBox(
              decoration: const BoxDecoration(color: Color.fromARGB(255, 255, 255, 255)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    SaludoPrincipal(familia: familia, userPos: userPos),
                    const SizedBox(
                      height: 15,
                    ),
                    WidgetTareasHoy(admin: admin, userPos: userPos, contUsers: contUsers),
                    WidgetCalendarioSemanal(userPos: userPos, admin: admin),
                    const WidgetHomeFamilia(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
