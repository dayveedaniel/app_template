import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project_template/di/injector.dart';
import 'package:new_project_template/features/ui/common_blocs/connection_cubit/connection_cubit.dart';
import 'package:new_project_template/features/ui/pages/auth_pages/login_page/login_page.dart';
import 'package:new_project_template/util/alert_utils.dart';
import 'package:easy_localization/easy_localization.dart'
    show StringTranslateExtension;
import 'package:upgrader/upgrader.dart';

/// App wrapper contains logics and blocs needed in the entire app

class AppWrapper extends StatelessWidget {
  const AppWrapper({
    super.key,
    required this.child,
    required this.navigator,
  });

  final Widget child;
  final GlobalKey<NavigatorState> navigator;

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      dialogStyle: UpgraderOS().isIOS
          ? UpgradeDialogStyle.cupertino
          : UpgradeDialogStyle.material,
      child: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => getIt.get<ConnectionCubit>()),
          ],
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: BlocListener<ConnectionCubit, UserConnectionState>(
              listener: (context, state) {
                if (state is TokenExpiredError) {
                  navigator.currentState?.pushNamedAndRemoveUntil(
                    LoginPage.routeName,
                    (route) => false,
                  );
                  AlertUtils.showCustomDialog(
                    context: navigator.currentContext ?? context,
                    isDismissible: true,
                    bodyText: 'alert.expiredToken'.tr(),
                    buttonTextKey: 'buttons.ok',
                  );
                }
                if (state is InternetConnectionState) {
                  state.hasConnection
                      ? ScaffoldMessenger.of(context).hideCurrentSnackBar()
                      : ScaffoldMessenger.of(context).showSnackBar(
                          AlertUtils.snackBar(
                              messageKey: 'alert.noConnection'.tr(),
                              isError: true,
                              showLoading: true,
                              duration: const Duration(days: 3)),
                        );
                }
              },
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
