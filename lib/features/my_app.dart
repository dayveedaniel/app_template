import 'package:new_project_template/domain/services/analytics_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:new_project_template/assets/app_theme.dart';
import 'package:new_project_template/features/ui/common_widgets/app_wrapper.dart';
import 'package:new_project_template/features/ui/routing/app_router.dart';
import 'package:new_project_template/util/consts.dart';

class MyAppMobile extends StatelessWidget {
  MyAppMobile({super.key, required this.initialRoute});

  final String initialRoute;
  final GlobalKey<NavigatorState> _navigator = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: supportedLocales,
      fallbackLocale: supportedLocales.first,
      useOnlyLangCode: true,
      path: 'assets/lang',
      child: Builder(
        builder: (context) => MaterialApp(
          title: 'My app',
          debugShowCheckedModeBanner: false,
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          theme: appTheme(context),
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: AppAnalytics.analytics),
          ],
          onGenerateRoute: AppRouter.onGenerateRoute,
          initialRoute: initialRoute,
          navigatorKey: _navigator,
          builder: (context, child) => AppWrapper(
            navigator: _navigator,
            child: child!,
          ),
        ),
      ),
    );
  }
}
