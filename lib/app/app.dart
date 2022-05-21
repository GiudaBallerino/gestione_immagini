import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imgs_repository/imgs_repository.dart';
import 'package:tags_repository/tags_repository.dart';

import '../home/view/home_page.dart';


class App extends StatelessWidget {
  const App({Key? key,required this.imgsRepository,required this.tagsRepository}) : super(key: key);

  final ImgsRepository imgsRepository;
  final TagsRepository tagsRepository;

  @override
  Widget build(BuildContext context) {

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ImgsRepository>(create: (context) => imgsRepository),
        RepositoryProvider<TagsRepository>(create: (context) => tagsRepository),
      ],
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
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}