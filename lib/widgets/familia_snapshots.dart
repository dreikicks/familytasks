import 'package:family_tasks/model/familia.dart';
import 'package:flutter/material.dart';

class FamiliaSnapshots extends StatelessWidget {
  final String idFamilia;
  final Widget Function(Familia) builder;
  const FamiliaSnapshots({
    super.key,
    required this.idFamilia,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: dbGetFamilia(idFamilia),
      builder: (BuildContext context, AsyncSnapshot<Familia> snapshot) {
        if (snapshot.hasError) {
          return ErrorWidget(snapshot.error.toString());
        }
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        final familia = snapshot.data!;
        // final miembros = familia.miembros;
        return builder(familia);
      },
    );
  }
}