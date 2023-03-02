import 'package:family_tasks/firebase_options.dart';
import 'package:family_tasks/screens/anadir_task.dart';
import 'package:family_tasks/screens/calendar_screen.dart';
import 'package:family_tasks/screens/detalles_task.dart';
import 'package:family_tasks/screens/family_screen.dart';
import 'package:family_tasks/screens/home_screen.dart';
import 'package:family_tasks/widgets/auth_usuarios.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const AuthGate(
      app: MyApp(),
    ),
  );
}

//final String familyId = "ndvkGX5jcyzEkRC3QmoO";
Map<int, Color> color = {
  50: const Color.fromARGB(255, 83, 122, 118),
  100: const Color.fromARGB(255, 83, 122, 118),
  200: const Color.fromARGB(255, 83, 122, 118),
  300: const Color.fromARGB(255, 83, 122, 118),
  400: const Color.fromARGB(255, 83, 122, 118),
  500: const Color.fromARGB(255, 83, 122, 118),
  600: const Color.fromARGB(255, 83, 122, 118),
  700: const Color.fromARGB(255, 83, 122, 118),
  800: const Color.fromARGB(255, 83, 122, 118),
  900: const Color.fromARGB(255, 83, 122, 118),
};

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: MaterialColor(0xffB6CAC8, color)),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/AnadirTasks': (_) => const AnadirTask(),
        '/DetallesTasks': (_) => const DetallesTask(),
        '/CalendarScreen': (_) => const CalendarScreen(),
        '/FamilyScreen': (_) => const FamilyScreen(),
      },
    );
  }
}
