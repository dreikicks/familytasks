import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetallesTask extends StatelessWidget {
  const DetallesTask({super.key});

  @override
  Widget build(BuildContext context) {
    final taskId = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: TituloTarea(taskId: taskId),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: DetallesDeTareas(taskId: taskId),
        ),
      ),
    );
  }
}

class TituloTarea extends StatelessWidget {
  final String taskId;
  const TituloTarea({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    return StreamBuilder(
      stream: db.doc("/familias/ndvkGX5jcyzEkRC3QmoO/tareas/$taskId").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error.toString());
        }
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        final doc = snapshot.data!;
        return Column(
          children: [
            Text(
              doc['nombre'],
            ),
          ],
        );
      },
    );
  }
}

class DetallesDeTareas extends StatelessWidget {
  final String taskId;

  const DetallesDeTareas({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    return StreamBuilder(
      stream: db.doc("/familias/ndvkGX5jcyzEkRC3QmoO/tareas/$taskId").snapshots(),
      builder: (
        BuildContext context,
        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
      ) {
        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error.toString());
        }
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        final doc = snapshot.data!;
        // DateTime date = doc['deadline'];
        Timestamp t = doc['deadline'];
        DateTime date = t.toDate();
        //List<Widget> users = [];
        List<dynamic> listaToca = doc['toca'];
        List<dynamic> listaHecho = doc['hecho'];
        return Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(listaToca.toString()),
            Text(
              doc['nombre'],
              style:
                  const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Color.fromARGB(255, 83, 122, 118)),
            ),
            const SizedBox(height: 5),
            Text("Para el día: ${date.day}/${date.month}/${date.year}"),
            const SizedBox(
              height: 35,
            ),
            const Text(
              "Comentarios",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color.fromARGB(255, 83, 122, 118)),
            ),

            Container(
              height: 200,
              width: 500,
              decoration:
                  BoxDecoration(color: const Color.fromARGB(255, 209, 227, 225), borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      doc['comentarios'] ?? "",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            const Text(
              "Personas asignadas:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color.fromARGB(255, 83, 122, 118)),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 165, 196, 193), borderRadius: BorderRadius.circular(10)),
              height: 120,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: StreamBuilder(
                  stream: db.doc("/familias/ndvkGX5jcyzEkRC3QmoO").snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                    if (snapshot.hasError) {
                      return ErrorWidget(snapshot.error.toString());
                    }
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    final doc = snapshot.data!;

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: doc['miembros'].length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    doc['miembros'][index]['nombre'],
                                    style: TextStyle(fontWeight: listaToca[index] ? FontWeight.w800 : FontWeight.w100),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  if (listaToca[index]) ...{
                                    listaHecho[index]
                                        ? const Icon(Icons.check_box_outlined, color: Color.fromARGB(255, 83, 122, 118))
                                        : const Icon(Icons.check_box_outline_blank,
                                            color: Color.fromARGB(255, 83, 122, 118)),
                                  }
                                ],
                              )),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
