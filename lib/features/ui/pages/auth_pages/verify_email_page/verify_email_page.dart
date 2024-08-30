import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_project_template/assets/app_colors.dart';
import 'package:new_project_template/assets/app_sizes.dart';
import 'package:new_project_template/assets/text_styles.dart';
import 'package:new_project_template/features/ui/common_widgets/custom_buttons/filled_custom_button.dart';
import 'package:new_project_template/features/ui/common_widgets/widget_wrapper_button.dart';
import 'package:new_project_template/features/ui/navbar/nav_bar.dart';
import 'package:new_project_template/features/ui/pages/auth_pages/verify_email_page/cubit/verify_email_page_cubit.dart';

part 'package:new_project_template/features/ui/pages/auth_pages/verify_email_page/verify_email_page_widgets.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({super.key});

  static const routeName = '/verifyEmailPage';

  @override
  Widget build(BuildContext context) {
    final email = context.read<VerifyEmailPageCubit>().email;
    return Scaffold(
      body: BlocListener<VerifyEmailPageCubit, VerifyEmailPageState>(
        listener: (context, state) {
          if (state.isLinkInMailClicked) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              NavBar.routeName,
              (route) => false,
            );
          }
        },
        listenWhen: (previous, current) =>
            current.isLinkInMailClicked && !previous.isLinkInMailClicked,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 9,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.p32,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(Sizes.p16),
                  ),
                ),
                child: Column(
                  children: [
                    spacer,
                    SvgPicture.asset(''),
                    gapH16,
                    Text(
                      'verifyEmail.sent'.tr(
                        args: ['${email[0]}*****@${email.split('@').last}'],
                      ),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.s22w600,
                    ),
                    gapH16,
                    Text(
                      'verifyEmail.confirmLink'.tr(),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.s16w400
                          .apply(color: AppColors.white),
                    ),
                    gapH8,
                    Text(
                      'verifyEmail.checkSpam'.tr(),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.s14w400
                          .apply(color: AppColors.white),
                    ),
                    spacer,
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Builder(
                      builder: (context) {
                        final showButton = context.select(
                            (VerifyEmailPageCubit cubit) =>
                                cubit.state.showNoEmailButton);
                        return showButton
                            ? WidgetButton(
                                onPressed: () {},
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Sizes.p32,
                                  vertical: Sizes.p4,
                                ),
                                child: Text(
                                  'verifyEmail.noEmail'.tr(),
                                  style: AppTextStyles.s16w500
                                      .apply(color: AppColors.white),
                                ),
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                    gapH16,
                    const _SendCodeButton(),
                    gapH32
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
