import 'package:app/core/injection/injection.dart';
import 'package:flutter/material.dart';
import 'package:app/features/auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

void main() async{
  await init();// inyecto las dependencias
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
      providers: [BlocProvider(create: (_)=>GetIt.instance.get<AuthBloc>())],
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Hello World!'),
          ),
        ),
      ),
    );
  }
}
