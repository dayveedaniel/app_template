import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project_template/assets/app_colors.dart';
import 'package:new_project_template/assets/app_sizes.dart';
import 'package:new_project_template/assets/text_styles.dart';
import 'package:new_project_template/features/ui/common_widgets/app_bar.dart';
import 'package:new_project_template/features/ui/common_widgets/close_app_observer.dart';
import 'package:new_project_template/features/ui/common_widgets/custom_buttons/filled_custom_button.dart';
import 'package:new_project_template/features/ui/common_widgets/custom_check_box.dart';
import 'package:new_project_template/features/ui/common_widgets/custom_text_field.dart';
import 'package:new_project_template/features/ui/common_widgets/having_troubles_widget.dart';
import 'package:new_project_template/features/ui/common_widgets/widget_wrapper_button.dart';
import 'package:new_project_template/features/ui/navbar/nav_bar.dart';
import 'package:new_project_template/features/ui/pages/auth_pages/login_page/login_page.dart';
import 'package:new_project_template/features/ui/pages/auth_pages/verify_email_page/verify_email_page.dart';
import 'package:new_project_template/util/alert_utils.dart';

import 'cubit/create_account_cubit.dart';

class CreateAccountPage extends StatelessWidget {
  static const routeName = '/createAccount';

  const CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CloseAppObserver(
      child: Scaffold(
        floatingActionButton: const _CreateAccountButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: CustomAppBar(
          label: 'landing.create'.tr(),
          implyLeading: false,
          hasBottomRadius: false,
        ),
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
    final CreateAccountCubit cubit = context.read();
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${'createAccount.already'.tr()} ',
                    style: AppTextStyles.s18w500.apply(
                      color: AppColors.white,
                    ),
                  ),
                  WidgetButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, LoginPage.routeName),
                    child: Text(
                      'landing.login'.tr(),
                      style: AppTextStyles.s18w500.apply(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
              gapH32,
              EmailField(
                onChanged: cubit.setEmail,
                initialValue: cubit.state.email,
              ),
              gapH16,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocSelector<CreateAccountCubit, CreateAccountState, bool>(
                    selector: (state) => state.acceptedTerms,
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.only(top: Sizes.p4),
                        child: CustomCheckBox(
                          value: state,
                          onChanged: cubit.toggleTerms,
                        ),
                      );
                    },
                  ),
                  gapW12,
                  const Expanded(child: _TermsAndConditions()),
                ],
              ),
              // gapH32,
              // BlocSelector<CreateAccountCubit, CreateAccountState, bool>(
              //   selector: (state) => state.acceptedTerms,
              //   builder: (context, state) {
              //     return InActiveWidget(
              //       isActive: state,
              //       child: GoogleAppleAuthWidget(
              //         onGoogleButtonPressed: cubit.createUserWithGoogle,
              //         onAppleButtonPressed: cubit.createUserWithApple,
              //       ),
              //     );
              //   },
              // ),
              gapH40,
              const HavingTroublesWidget(textKey: 'createAccount'),
              gapH12,
            ],
          ),
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}

class _CreateAccountButton extends StatelessWidget {
  const _CreateAccountButton();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateAccountCubit, CreateAccountState>(
      listener: (context, state) {
        if (state is CreateAccountError) {
          AlertUtils.showCustomDialog(
            context: context,
            isDismissible: true,
            titleKey: state.routeToLogin ? null : 'alert.error',
            bodyText: state.routeToLogin
                ? 'createAccount.userExists'.tr()
                : state.errorMessage,
            buttonTextKey:
                state.routeToLogin ? 'createAccount.login' : 'buttons.ok',
            onButtonPressed: state.routeToLogin
                ? () {
                    Navigator.pushReplacementNamed(
                      context,
                      LoginPage.routeName,
                      arguments: state.email,
                    );
                  }
                : null,
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
      listenWhen: (previous, current) =>
          current is CreateAccountSuccess || current is CreateAccountError,
      builder: (context, state) {
        return Material(
          color: AppColors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.p16,
              vertical: Sizes.p8,
            ),
            child: FilledCustomButton(
              isActive: state is CreateAccountFormState && state.canSubmitForm,
              isLoading: state is CreateAccountLoading,
              onPressed: context.read<CreateAccountCubit>().createUserWithEmail,
              textKey: 'landing.create',
            ),
          ),
        );
      },
    );
  }
}

class _TermsAndConditions extends StatelessWidget {
  const _TermsAndConditions();

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'createAccount.agree'.tr(),
        children: [
          _clickableText(
            context: context,
            urlLink: 'termsOfService',
            textKey: 'createAccount.terms',
          ),
          TextSpan(text: 'createAccount.and'.tr()),
          _clickableText(
            context: context,
            urlLink: 'privacyPolicyLink',
            textKey: 'createAccount.policy',
          ),
          TextSpan(text: 'createAccount.i_agree_tos'.tr()),
          _clickableText(
            context: context,
            urlLink: 'abetaTermsOfService',
            textKey: 'createAccount.tos',
          ),
          TextSpan(text: 'createAccount.and'.tr()),
          _clickableText(
            context: context,
            urlLink: 'abetaPrivacyPolicyLink',
            textKey: 'createAccount.policy',
          ),
          TextSpan(text: 'createAccount.ofAbeta'.tr()),
        ],
      ),
      style: AppTextStyles.s16w500.apply(color: AppColors.white),
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
        alignment: Alignment.bottomCenter,
        onPressed: () {},
        child: Text(
          textKey.tr(),
          style: AppTextStyles.s16w500,
        ),
      ),
    );
