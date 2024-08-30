import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project_template/di/injector.dart';
import 'package:new_project_template/features/ui/navbar/nav_bar.dart';
import 'package:new_project_template/features/ui/navbar/navbar_cubit/navbar_cubit.dart';
import 'package:new_project_template/features/ui/pages/auth_pages/create_account_page/create_account_page.dart';
import 'package:new_project_template/features/ui/pages/auth_pages/create_account_page/cubit/create_account_cubit.dart';
import 'package:new_project_template/features/ui/pages/auth_pages/landing_page.dart';
import 'package:new_project_template/features/ui/pages/auth_pages/login_page/cubit/login_cubit.dart';
import 'package:new_project_template/features/ui/pages/auth_pages/login_page/login_page.dart';
import 'package:new_project_template/features/ui/pages/auth_pages/verify_email_page/cubit/verify_email_page_cubit.dart';
import 'package:new_project_template/features/ui/pages/auth_pages/verify_email_page/verify_email_page.dart';
import 'package:new_project_template/features/ui/pages/profile_page/cubit/profile_page_cubit.dart';

class AppRouter {
  AppRouter._();

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case NavBar.routeName:
        return MaterialPageRoute(
          builder: (context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => getIt.get<NavbarCubit>(),
                ),
                BlocProvider(
                  create: (context) => getIt.get<ProfilePageCubit>(),
                  lazy: false,
                ),
              ],
              child: const NavBar(),
            );
          },
          settings: settings,
        );

      case LandingPage.routeName:
        return _NewRoute(const LandingPage(), settings: settings);

      case CreateAccountPage.routeName:
        return _NewRouteWithBloc<CreateAccountCubit>(
          const CreateAccountPage(),
          param1: settings.arguments,
          settings: settings,
        );

      case LoginPage.routeName:
        return _NewRouteWithBloc<LoginCubit>(
          const LoginPage(),
          param1: settings.arguments,
          settings: settings,
        );



      case VerifyEmailPage.routeName:
        return _NewRouteWithBloc<VerifyEmailPageCubit>(
          const VerifyEmailPage(),
          settings: settings,
          param1: settings.arguments,
        );

      default:
        return _NewRoute(
          const Material(
            child: Center(
              child: Text("Invalid Route"),
            ),
          ),
        );
    }
  }
}

class _NewRoute extends MaterialPageRoute {
  final Widget child;

  _NewRoute(this.child, {super.settings}) : super(builder: (context) => child);
}

class _NewRouteWithBloc<T extends BlocBase> extends MaterialPageRoute {
  _NewRouteWithBloc(
    this.child, {
    this.lazy,
    super.settings,
    dynamic param1,
    dynamic param2,
  }) : super(
          builder: (context) => BlocProvider(
            create: (context) => getIt.get<T>(
              param1: param1,
              param2: param2,
            ),
            lazy: lazy ?? true,
            child: child,
          ),
        );

  final Widget child;
  final bool? lazy;
}
