import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:img_api/img_api.dart';
import 'package:imgs_repository/imgs_repository.dart';
import 'package:tag_api/tag_api.dart';
import 'package:tags_repository/tags_repository.dart';

import 'app/app.dart';
import 'app/app_bloc_observer.dart';

void bootstrap({required ImgApi imgApi,required TagApi tagApi}) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  final imgsRepository = ImgsRepository(imgApi: imgApi);
  final tagsRepository =TagsRepository(tagApi: tagApi);

  runZonedGuarded(
        () async {
      await BlocOverrides.runZoned(
            () async => runApp(
          App(imgsRepository: imgsRepository,tagsRepository:tagsRepository),
        ),
        blocObserver: AppBlocObserver(),
      );
    },
        (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}