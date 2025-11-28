import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:print_zone/features/home/presintation/screens/home_screen.dart';

import 'features/home/cubit/drop_files_cubit_duplex/drop_files_duplex_cubit.dart';
import 'features/home/cubit/drop_files_cubit_four_front_back/drop_files_four_front_back_cubit.dart';
import 'features/home/cubit/drop_files_cubit_one_side/drop_files_cubit_one_side.dart';
import 'features/home/cubit/drop_files_cubit_two_front_back/drop_files_two_front_back_cubit.dart';

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
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => DropFilesCubitOneSide()),
          BlocProvider(create: (context) => DropFilesCubitDuplex()),
          BlocProvider(create: (context) => DropFilesCubitTwoFront()),
          BlocProvider(create: (context) => DropFilesCubitFourFront()),
        ],
        child: HomeScreen(),
      ),
    );
  }
}
