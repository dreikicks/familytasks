import 'package:family_tasks/model/familia.dart';
import 'package:family_tasks/model/tarea.dart';
import 'package:family_tasks/widgets/familia_snapshots.dart';
import 'package:family_tasks/widgets/lista_tareas_snapshots.dart';
import 'package:flutter/material.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ranking de la familia"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text(
                            "Leaderboard",
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.w800, color: Color.fromARGB(255, 83, 122, 118)),
                                overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "del último mes",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.emoji_events_outlined,
                        size: 80,
                        color: Color.fromARGB(255, 87, 87, 87),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Posición",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color.fromARGB(255, 83, 122, 118)),
                ),
                Text(
                  "Puntos",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color.fromARGB(255, 83, 122, 118)),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              flex: 4,
              child: FamiliaSnapshots(
                idFamilia: 'ndvkGX5jcyzEkRC3QmoO',
                builder: (Familia familia) {
                  var position = 0;
                  final miembros = familia.miembros;
                  return ListaTareasSnapshots(
                    idFamilia: 'ndvkGX5jcyzEkRC3QmoO',
                    builder: (tareas) {
                      List<Rank> ranking = calculaRanking(tareas, miembros);
                      return ListView.builder(
                        itemCount: ranking.length,
                        itemBuilder: (context, index) {
                          final rank = ranking[index];
                          position = position + 1;
                          //index = index + 1;
                          return Column(
                            children: [
                              ListTile(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  tileColor: const Color.fromARGB(255, 182, 202, 200),
                                  leading: Text("$position"),
                                  title: Text(rank.nombre),
                                  trailing: Text(
                                    "${rank.puntos}",
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const SizedBox(height: 6)
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
