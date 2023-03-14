import 'package:flutter/material.dart';
import 'package:notebook/providers/lenden_provider.dart';
import 'package:notebook/view/home.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> LendenProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notebook',
      theme: ThemeData(primarySwatch: Colors.blue, brightness: Brightness.dark),
      home: const Home(),
    );
  }
}
