import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_tasks/model/familia.dart';

class Tarea {
  String id;
  String nombre;
  String? comentarios;
  DateTime deadline;
  DateTime fecha;
  List<bool> hecho;
  List<bool> toca;

  Tarea.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        nombre = doc['nombre'],
        comentarios = doc.data()!['comentarios'],
        deadline = (doc['deadline'] as Timestamp).toDate(),
        fecha = (doc['fecha'] as Timestamp).toDate(),
        hecho = doc['hecho'].cast<bool>(),
        toca = doc['toca'].cast<bool>();
}

class HechoFamiliar {
  String nombre;
  bool hecho;
  HechoFamiliar(this.nombre, this.hecho);
}

List<HechoFamiliar> quienLeToca(List<Miembro> miembros, Tarea tarea) {
  List<HechoFamiliar> listaMiembrosTarea = [];
  for (int i = 0; i < miembros.length; i++) {
    if (tarea.toca[i]) {
      listaMiembrosTarea.add(HechoFamiliar(miembros[i].nombre, tarea.hecho[i]));
    }
  }
  return listaMiembrosTarea;
}

Stream<List<Tarea>> dbGetTareasFamilia(String idFamilia) async* {
  final db = FirebaseFirestore.instance;
  final stream = db.collection("/familias/$idFamilia/tareas").snapshots();
  await for (final querySnap in stream) {
    List<Tarea> tareas = [];
    for (final doc in querySnap.docs) {
      tareas.add(Tarea.fromFirestore(doc));
    }
    yield tareas;
  }
}

class Rank {
  String nombre;
  int puntos;
  Rank(this.nombre, this.puntos);
}

List<Rank> calculaRanking(List<Tarea> tareas, List<Miembro> miembros) {
  List<Rank> ranking = [];
  for (int i = 0; i < miembros.length; i++) {
    int puntos = 0;
    final now = DateTime.now();
    var date = DateTime(now.year, now.month, 0);
    for (final tarea in tareas) {
      if (tarea.hecho[i] && tarea.deadline.compareTo(date) > 0) puntos++;
    }
    ranking.add(Rank(miembros[i].nombre, puntos));
  }
  ranking.sort((a, b) => b.puntos - a.puntos);
  return ranking;
}
// && tarea.deadline.compareTo(date) < 0