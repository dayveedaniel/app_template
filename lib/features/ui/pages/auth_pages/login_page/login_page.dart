import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project_template/assets/app_colors.dart';
import 'package:new_project_template/assets/app_sizes.dart';
import 'package:new_project_template/assets/text_styles.dart';
import 'package:new_project_template/features/ui/common_widgets/app_bar.dart';
import 'package:new_project_template/features/ui/common_widgets/close_app_observer.dart';
import 'package:new_project_template/features/ui/common_widgets/custom_buttons/filled_custom_button.dart';
import 'package:new_project_template/features/ui/common_widgets/custom_text_field.dart';
import 'package:new_project_template/features/ui/common_widgets/having_troubles_widget.dart';
import 'package:new_project_template/features/ui/common_widgets/widget_wrapper_button.dart';
import 'package:new_project_template/features/ui/navbar/nav_bar.dart';
import 'package:new_project_template/features/ui/pages/auth_pages/create_account_page/create_account_page.dart';
import 'package:new_project_template/features/ui/pages/auth_pages/login_page/cubit/login_cubit.dart';
import 'package:new_project_template/features/ui/pages/auth_pages/verify_email_page/verify_email_page.dart';
import 'package:new_project_template/util/alert_utils.dart';

class LoginPage extends StatelessWidget {
  static const routeName = '/login';

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CloseAppObserver(
      child: Scaffold(
        appBar: CustomAppBar(
          label: 'landing.login'.tr(),
          implyLeading: false,
          hasBottomRadius: false,
        ),
        floatingActionButton: const _LoginButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: const CustomScrollView(
          physics: ClampingScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: _Body(),
            )
          ],
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final LoginCubit loginCubit = context.read();
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Column(
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  Text(
                    '${'createAccount.notRegistered'.tr()} ',
                    style: AppTextStyles.s18w500
                        .apply(color: AppColors.white),
                  ),
                  gapW4,
                  WidgetButton(
                    onPressed: () => Navigator.pushNamed(
                        context, CreateAccountPage.routeName),
                    child: Text(
                      'landing.create'.tr(),
                      style: AppTextStyles.s18w500
                          .copyWith(color: AppColors.white),
                    ),
                  ),
                ],
              ),
              gapH32,
              EmailField(
                onChanged: (val) {},
                initialValue: loginCubit.state.email,
              ),
              gapH32,
              const HavingTroublesWidget(textKey: 'login'),
              gapH12,
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                gapH32,
                Text.rich(
                  textAlign: TextAlign.center,
                  style: AppTextStyles.s12w500.copyWith(
                    color: AppColors.white,
                    height: 2,
                    //heightDelta:
                  ),
                  TextSpan(
                    text: 'login.continue'.tr(),
                    children: [
                      _clickableText(
                        context: context,
                        urlLink: '',
                        textKey: 'createAccount.terms',
                      ),
                      TextSpan(text: 'createAccount.and'.tr()),
                      _clickableText(
                        context: context,
                        urlLink: 'privacyPolicyLink',
                        textKey: 'createAccount.policy',
                      ),
                      TextSpan(text: 'createAccount.agree_tos'.tr()),
                      _clickableText(
                        context: context,
                        urlLink: '',
                        textKey: 'createAccount.tos',
                      ),
                      TextSpan(text: 'createAccount.and'.tr()),
                      _clickableText(
                        context: context,
                        urlLink: '',
                        textKey: 'createAccount.policy',
                      ),
                      TextSpan(text: 'createAccount.ofAbeta'.tr()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

WidgetSpan _clickableText({
  required BuildContext context,
  required urlLink,
  required String textKey,
}) =>
    WidgetSpan(
      alignment: PlaceholderAlignment.baseline,
      baseline: TextBaseline.alphabetic,
      child: WidgetButton(
        onPressed: () {},
        child: Text(
          textKey.tr(),
          style: AppTextStyles.s12w500,
        ),
      ),
    );

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (true) {
          AlertUtils.showCustomDialog(
            context: context,
            isDismissible: true,
            titleKey: 'alert.error',
            bodyText: state.userNotFound
                ? 'login.userNotFound'.tr()
                : state.errorMessage,
            buttonTextKey: 'buttons.cancel',
            secondButtonTextKey:
                state.userNotFound ? 'login.createAccount' : null,
            onSecondButtonPressed: () {
              Navigator.pushReplacementNamed(
                context,
                CreateAccountPage.routeName,
                arguments: state.email,
              );
            },
          );
        } else {
          state.routeToVerifyMail
              ? Navigator.pushNamed(
                  context,
                  VerifyEmailPage.routeName,
                  arguments: state.email,
                )
              : Navigator.pushNamedAndRemoveUntil(
                  context,
                  NavBar.routeName,
                  (route) => false,
                );
        }
      },
      builder: (context, state) {
        return Material(
          color: AppColors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.p16,
              vertical: Sizes.p8,
            ),
            child: FilledCustomButton(
              isActive: state.isEmailValid,
              onPressed: context.read<LoginCubit>().loginWithEmail,
              textKey: 'landing.login',
            ),
          ),
        );
      },
    );
  }
}
