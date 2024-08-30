import 'package:dropdown_button2/dropdown_button2.dart'
    show DropdownButton2State;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project_template/assets/app_colors.dart';
import 'package:new_project_template/assets/app_sizes.dart';
import 'package:new_project_template/assets/asset_paths.dart';
import 'package:new_project_template/assets/text_styles.dart';
import 'package:new_project_template/di/injector.dart';
import 'package:new_project_template/features/ui/common_widgets/app_bar.dart';
import 'package:new_project_template/features/ui/common_widgets/custom_buttons/filled_custom_button.dart';
import 'package:new_project_template/features/ui/common_widgets/custom_check_box.dart';
import 'package:new_project_template/features/ui/common_widgets/custom_dropdown.dart';
import 'package:new_project_template/features/ui/common_widgets/custom_list_tile.dart';
import 'package:new_project_template/features/ui/pages/auth_pages/landing_page.dart';
import 'package:new_project_template/features/ui/pages/profile_page/cubit/profile_page_cubit.dart';
import 'package:new_project_template/util/alert_utils.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final _languageKey = GlobalKey<DropdownButton2State<Locale>>();
  final _botLanguageKey = GlobalKey<DropdownButton2State>();
  final _botVoiceKey = GlobalKey<DropdownButton2State>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<ProfilePageCubit>(),
      child: Scaffold(
        appBar: CustomAppBar(
          label: 'profile.settings'.tr(),
          labelStyle: AppTextStyles.s20w600,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
          child: Column(
            children: [
              ListTileWithIcon(
                textKey: 'settings.lang',
                iconAsset: '',
                replaceArrowWidget:
                    _LanguageDropdown(languageKey: _languageKey),
                onTap: () => _languageKey.currentState?.callTap(),
              ),
              const ListTileWithIcon(
                textKey: 'settings.fontSize',
                iconAsset: '',
                replaceArrowWidget: SizedBox.shrink(),
                onTap: null,
              ),
              ListTileWithIcon(
                textKey: 'settings.botLang',
                iconAsset: '',
                replaceArrowWidget: CustomDropDown<String>(
                  dropdownKey: _botLanguageKey,
                  value: context.locale.languageCode,
                  height: Sizes.p18,
                  customButtonTextKey: 'locale.en',
                  style: AppTextStyles.s14w500,
                  bgColor: AppColors.white,
                  borderColor: AppColors.white,
                  onChanged: null,
                  //(value) async {},
                  items: context.supportedLocales
                      .map((lang) => CustomDropDownItem<String>(
                            value: lang.languageCode,
                            textColor: AppColors.black,
                            text: 'locale.${lang.languageCode}'.tr(),
                          ))
                      .toList(),
                ),
                onTap: null,
              ),
              ListTileWithIcon(
                textKey: 'settings.botVoice',
                iconAsset: '',
                replaceArrowWidget: CustomDropDown<int>(
                  value: 0,
                  dropdownKey: _botVoiceKey,
                  height: Sizes.p18,
                  bgColor: AppColors.white,
                  style: AppTextStyles.s14w500,
                  borderColor: AppColors.white,
                  customButtonTextKey: 'settings.voice'.tr(args: ['1']),
                  onChanged: null,
                  items: [0, 1, 2]
                      .map((val) => CustomDropDownItem<int>(
                            value: val,
                            textColor: AppColors.white,
                            text: 'settings.voice'.tr(args: [' ${val + 1}']),
                          ))
                      .toList(),
                ),
                onTap: null,
              ),
              gapH40,
              const DeleteAccountButton(),
              spacer,
              FilledCustomButton(
                onPressed: () => Navigator.pop(
                  context,
                  _languageKey.currentState?.widget.value,
                ),
                textKey: 'buttons.save',
              ),
              gapH48,
            ],
          ),
        ),
      ),
    );
  }
}

class DeleteAccountButton extends StatelessWidget {
  const DeleteAccountButton({super.key});

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
        bool canDelete = false;
        return ListTileWithIcon(
          textKey: 'personal.deleteAccount',
          iconAsset: '',
          textColor: AppColors.white,
          bgColor: AppColors.white,
          onTap: () async => AlertUtils.showBottomSheet(
            parentContext: context,
            child: StatefulBuilder(
              builder: (context, setState) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'alert.confirm_'.tr(),
                    style: AppTextStyles.s18w600,
                  ),
                  gapH8,
                  Text(
                    'personal.deleteInfo'.tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.s16w400
                        .apply(color: AppColors.white),
                  ),
                  gapH24,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomCheckBox(
                        value: canDelete,
                        onChanged: () {
                          setState(() => canDelete = !canDelete);
                        },
                      ),
                      gapW8,
                      Expanded(
                        child: Text(
                          'personal.checkText'.tr(),
                          style: AppTextStyles.s16w500,
                        ),
                      )
                    ],
                  ),
                  gapH24,
                  FilledCustomButton(
                    textKey: 'personal.deleteAccount',
                    isActive: canDelete,
                    onPressed: () =>
                        context.read<ProfilePageCubit>().deleteAccount(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LanguageDropdown extends StatefulWidget {
  const _LanguageDropdown({
    required GlobalKey<DropdownButton2State> languageKey,
  }) : _languageKey = languageKey;

  final GlobalKey<DropdownButton2State> _languageKey;

  @override
  State<_LanguageDropdown> createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<_LanguageDropdown> {
  late Locale currentLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentLocale = context.locale;
  }

  @override
  Widget build(BuildContext context) {
    return CustomDropDown<Locale>(
      dropdownWidth: Sizes.p200,
      dropdownKey: widget._languageKey,
      value: currentLocale,
      height: Sizes.p18,
      bgColor: AppColors.white,
      borderColor: AppColors.white,
      style: AppTextStyles.s14w500,
      customButtonTextKey: 'locale.${currentLocale.languageCode}',
      onChanged: (value) async {
        if (value != null) {
          setState(() {
            currentLocale = value;
          });
        }
      },
      items: context.supportedLocales
          .map((lang) => CustomDropDownItem<Locale>(
                value: lang,
                textColor: AppColors.white,
                text: 'locale.${lang.languageCode}'.tr(),
              ))
          .toList(),
    );
  }
}
