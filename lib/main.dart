import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/movie_viewmodel.dart';
import 'views/movie_list_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => MovieViewModel()..initializeApp(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stage OTT',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const MovieListScreen(),
    );
  }
}
