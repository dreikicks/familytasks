import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_tasks/model/familia.dart';
import 'package:family_tasks/widgets/familia_snapshots.dart';
import 'package:flutter/material.dart';

class AnadirTask extends StatelessWidget {
  const AnadirTask({super.key});

  @override
  Widget build(BuildContext context) {
    final contUsers = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nueva Tarea"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: AddTaskForm(contUsers: contUsers),
        ),
      ),
    );
  }
}

class AddTaskForm extends StatefulWidget {
  final int contUsers;
  const AddTaskForm({super.key, required this.contUsers});

  @override
  State<AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerComment = TextEditingController();
  DateTime now = DateTime.now();
  DateTime? date;
  List<bool> listaToca = [];
  List<bool> listaHecho = [];
  List<Widget> users = [];
  var numUsers = 0;

  @override
  void dispose() {
    controllerName.dispose();
    controllerComment.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      for (var i = 0; i < widget.contUsers; i++) {
        listaToca.add(false);
        listaHecho.add(false);
      }
    });
    //users = [];
    date = DateTime(now.year, now.month, now.day);
  }

  void addTask([String? text]) {
    final db = FirebaseFirestore.instance;
    const path = "/familias/ndvkGX5jcyzEkRC3QmoO/tareas";
    if (controllerName.text.trim().isNotEmpty) {
      db.collection(path).add({
        'nombre': controllerName.text,
        'fecha': Timestamp.now(),
        'deadline': date,
        'hecho': listaHecho,
        'toca': listaToca,
        'comentarios': controllerComment.text,
      });
      controllerName.clear();
      controllerComment.clear();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool dateVisible = false;

    if (date != null) {
      dateVisible = true;
    } else {
      dateVisible = false;
    }
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Nombre de la tarea: ",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 83, 122, 118)),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 209, 227, 225)),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Nombre',
              ),
              controller: controllerName,
              textInputAction: TextInputAction.send,
            ),
          ),
        ),
        const SizedBox(height: 35),
        const Text(
          "Deadline:",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 83, 122, 118)),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 40,
          width: 80,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 165, 196, 193),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6))),
            onPressed: () async {
              DateTime? newDate = await showDatePicker(
                context: context,
                initialDate: date!,
                firstDate: DateTime(now.year),
                lastDate: DateTime(now.year + 10),
              );
              if (newDate == null) return;

              setState(() {
                date = newDate;
              });
            },
            child: const Icon(Icons.calendar_month, color: Colors.black),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          dateVisible
              ? 'Fecha seleccionada: ${date!.day}/${date!.month}/${date!.year}'
              : "",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 35),
        const Text(
          "Asignar personas:",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 83, 122, 118)),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 209, 227, 225),
              borderRadius: BorderRadius.circular(10)),
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: FamiliaSnapshots(
              idFamilia: "ndvkGX5jcyzEkRC3QmoO",
              builder: (Familia familia) {
                //final miembros = familia.miembros;
                return ListView.builder(
                  scrollDirection: Axis.horizontal, 
                  itemCount: familia.miembros.length,
                  itemBuilder: (BuildContext context, int index) {  
                    //final miembro = miembros[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            listaToca[index] = !listaToca[index];
                          });
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              color: listaToca[index]
                                ? const Color.fromARGB(255, 83, 122, 118)
                                : const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(8)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Text(familia.miembros[index].nombre,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: listaToca[index]
                                        ? Colors.white
                                        : Colors.black
                                    )
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 35),
        const Text(
          "Comentarios:",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 83, 122, 118)),
        ),
        const SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 209, 227, 225)),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Comentarios',
              ),
              controller: controllerComment,
              textInputAction: TextInputAction.send,
            ),
          ),
        ),
        const SizedBox(height: 60),
        Row(
          children: [
            Expanded(child: Container(height: 20)),
            GestureDetector(
                onTap: () {
                  addTask();
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 83, 122, 118),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Text(
                    "Añadir",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 17),
                  ),
                )),
          ],
        ),
      ],
    );
  }
}

class TitleBox extends StatefulWidget {
  const TitleBox({
    Key? key,
  }) : super(key: key);

  @override
  State<TitleBox> createState() => _TitleBoxState();
}

class _TitleBoxState extends State<TitleBox> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void saveTitle([String? text]) {
    final db = FirebaseFirestore.instance;
    const path = "/Tasks";
    if (controller.text.trim().isNotEmpty) {
      db.collection(path).add({
        'text': controller.text,
        'date': Timestamp.now(),
      });
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          textInputAction: TextInputAction.send,
          onSubmitted: saveTitle,
        ),
        IconButton(
          icon: const Icon(Icons.mail),
          onPressed: saveTitle,
        ),
      ],
    );
  }
}
