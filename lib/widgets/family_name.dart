import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FamilyName extends StatelessWidget {
  const FamilyName({super.key});

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    return StreamBuilder(
      stream: db.doc("/familias/ndvkGX5jcyzEkRC3QmoO").snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error.toString());
        }
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        final doc = snapshot.data!;
        return Text(
          doc['nombre'],
        );
      },
    );
  }
}
