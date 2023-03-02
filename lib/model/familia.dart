import 'package:cloud_firestore/cloud_firestore.dart';

class Miembro {
  String uid;
  String nombre;
  bool admin;

  Miembro.fromFirestore(Map<String, dynamic> map)
      : uid = map['uid'],
        nombre = map['nombre'],
        admin = map['admin'];
}

class Familia {
  String id;
  String nombre;
  List<Miembro> miembros;

  Familia.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        nombre = doc['nombre'],
        miembros = doc['miembros']
            .map((map) => Miembro.fromFirestore(map))
            .toList()
            .cast<Miembro>();
}

Stream<Familia> dbGetFamilia(String idFamilia) async* {
  final db = FirebaseFirestore.instance;
  final stream = db.doc("/familias/$idFamilia").snapshots();
  await for (final docSnap in stream) {
    yield Familia.fromFirestore(docSnap);
  }
}
