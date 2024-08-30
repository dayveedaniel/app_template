import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project_template/assets/app_colors.dart';
import 'package:new_project_template/assets/app_sizes.dart';
import 'package:new_project_template/assets/asset_paths.dart';
import 'package:new_project_template/assets/text_styles.dart';
import 'package:new_project_template/features/ui/common_widgets/custom_list_tile.dart';
import 'package:new_project_template/features/ui/common_widgets/custom_shimmer.dart';
import 'package:new_project_template/features/ui/common_widgets/having_troubles_widget.dart';
import 'package:new_project_template/features/ui/common_widgets/loading_indicator.dart';
import 'package:new_project_template/features/ui/pages/auth_pages/landing_page.dart';
import 'package:new_project_template/features/ui/pages/profile_page/cubit/profile_page_cubit.dart';
import 'package:new_project_template/features/ui/pages/profile_page/settings_page/settings_page.dart';
import 'package:new_project_template/util/alert_utils.dart';

import '../../common_widgets/custom_buttons/filled_custom_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfilePageCubit>();
    return RefreshIndicator.adaptive(
      onRefresh: () async => await cubit.getUserProfile(),
      displacement: 30,
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
              child: Column(
                children: [
                  BlocSelector<ProfilePageCubit, ProfilePageState, String?>(
                    selector: (state) => state.userProfile?.email,
                    builder: (context, email) {
                      return email == null
                          ? const Shimmer(height: Sizes.p24, width: Sizes.p150)
                          : Text(
                              email,
                              style: AppTextStyles.s18w500
                                  .apply(color: AppColors.white),
                            );
                    },
                  ),
                  gapH24,
                  ListTileWithIcon(
                    textKey: 'profile.manager',
                    iconAsset: '',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>  Container(),
                      ),
                    ),
                  ),
                  gapH8,
                  gapH8,
                    ListTileWithIcon(
                      textKey: 'profile.watchlist',
                      iconAsset: '',
                      onTap: (){},
                    ),
                  gapH24,
                  _LogoutButton(),
                  gapH8,
                  DeleteAccountButton(),
                  gapH16,
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'appVersion'.tr(args: ['1.0.0+3']),
                          style: AppTextStyles.s12w400
                              .apply(color: AppColors.white),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  spacer,
                  // ignore: prefer_const_constructors
                  HavingTroublesWidget(
                    textKey: 'profile.troubles',
                    preButtonTextKey: 'profile.contact_small',
                    hasSupport: true,
                  ),
                  gapH128,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfilePageCubit, ProfilePageState>(
      listener: (context, state) {
        if (true) {
          AlertUtils.showCustomDialog(
            context: context,
            isDismissible: true,
            useNativeDialog: true,
            titleKey: 'alert.error',
            bodyText: state.errorMessage,
            buttonTextKey: 'buttons.ok',
          );
          return;
        }
        Navigator.pushNamedAndRemoveUntil(
          context,
          LandingPage.routeName,
          (route) => false,
        );
      },
      builder: (context, state) {
        return ListTileWithIcon(
          textKey: 'profile.logout',
          iconAsset: '',
          textColor: AppColors.white,
          bgColor: AppColors.white,
          replaceArrowWidget: true ? const LoadingIndicator() : null,
          onTap: () async {
            AlertUtils.showBottomSheet(
              parentContext: context,
              //todo: maybe refactor for multiple usage
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'alert.confirm_'.tr(),
                    style: AppTextStyles.s18w600,
                  ),
                  gapH8,
                  Text(
                    'alert.logOutBody'.tr(),
                    style: AppTextStyles.s16w400
                        .apply(color: AppColors.white),
                  ),
                  gapH24,
                  FilledCustomButton(
                    textKey: 'profile.logout',
                    onPressed: () => context.read<ProfilePageCubit>().logOut(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
