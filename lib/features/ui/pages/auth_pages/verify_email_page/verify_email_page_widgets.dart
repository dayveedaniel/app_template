part of 'package:new_project_template/features/ui/pages/auth_pages/verify_email_page/verify_email_page.dart';

class _SendCodeButton extends StatelessWidget {
  const _SendCodeButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerifyEmailPageCubit, VerifyEmailPageState>(
      builder: (context, state) {
        return FilledCustomButton(
          onPressed: () {
            context.read<VerifyEmailPageCubit>().resendMail();
          },
          isActive: state.canSendNewCode,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'verifyEmail.sendCode'.tr(),
                style: AppTextStyles.s18w400.copyWith(
                  color: AppColors.white,
                ),
              ),
              if (!state.canSendNewCode)
                BlocSelector<VerifyEmailPageCubit, VerifyEmailPageState,
                    String>(
                  selector: (state) => state.newCodeTime,
                  builder: (context, state) {
                    return Text(
                      state,
                      style:
                          AppTextStyles.s18w400.apply(color: AppColors.white),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
