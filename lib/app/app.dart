import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imgs_repository/imgs_repository.dart';

import '../home/view/home_page.dart';


class App extends StatelessWidget {
  const App({Key? key,required this.imgsRepository}) : super(key: key);

  final ImgsRepository imgsRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: imgsRepository,
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //theme: , //todo default theme
      //darkTheme: , //todo dark theme
      home: const HomePage(),
    );
  }
}