import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:img_api/img_api.dart';
import 'package:imgs_repository/imgs_repository.dart';

import 'app/app.dart';
import 'app/app_bloc_observer.dart';

void bootstrap({required ImgApi imgApi}) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  final imgsRepository = ImgsRepository(imgApi: imgApi);

  runZonedGuarded(
        () async {
      await BlocOverrides.runZoned(
            () async => runApp(
          App(imgsRepository: imgsRepository),
        ),
        blocObserver: AppBlocObserver(),
      );
    },
        (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}