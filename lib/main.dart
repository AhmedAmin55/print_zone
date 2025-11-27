import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:print_zone/features/home/presintation/screens/home_screen.dart';

import 'features/home/cubit/drop_files_cubit/drop_files_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Print Zone',
      home: BlocProvider(
        create: (context) => DropFilesCubit(),
        child: HomeScreen(),
      ),
    );
  }
}
