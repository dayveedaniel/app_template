import 'package:new_project_template/di/injector.dart';
import 'package:new_project_template/domain/services/user_auth_service.dart';
import 'package:new_project_template/features/ui/navbar/nav_bar.dart';
import 'package:new_project_template/features/ui/pages/auth_pages/landing_page.dart';
import 'package:new_project_template/util/bloc_observer.dart';
import 'package:new_project_template/util/log_service.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import 'features/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    //options: DefaultFirebaseOptions.currentPlatform,
  );
  injectDependencies(env: Environment.dev);
  initErrorHandler();
  await EasyLocalization.ensureInitialized();
  Bloc.observer = AppBlocObserver();

  final noAccessToken = await getIt.get<AuthService>().noAccessToken;
  String initialRoute =
  noAccessToken ? LandingPage.routeName : NavBar.routeName;
  //todo: add splash screen or not
  runApp(MyAppMobile(initialRoute: initialRoute));
}
