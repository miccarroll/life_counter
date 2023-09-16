import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/Dashboard.dart';
import 'blocs/counter_bloc.dart';
import 'blocs/menus_bloc.dart';

//asdasdasdasndkasd

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CounterBloc()..add(LoadCounter())),
        BlocProvider(create: (context) => MenusBloc()..add(LoadMenus())),
      ],
      child: const MaterialApp(
        title: 'Life Counter',
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: Dashboard(),
      ),
    );
  }
}
