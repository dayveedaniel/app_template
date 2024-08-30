import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_project_template/assets/app_sizes.dart';
import 'package:new_project_template/assets/text_styles.dart';

import 'app_colors.dart';

final _textInputBorderRadius = BorderRadius.circular(Sizes.p12);

ThemeData appTheme(BuildContext context) => ThemeData(
      fontFamily: fontFamily,
      //primaryColor: AppColors.blue,
      useMaterial3: true,
      iconTheme: const IconThemeData(color: AppColors.black),
      //scaffoldBackgroundColor: AppColors.secondary7,
      cupertinoOverrideTheme: const CupertinoThemeData(
       // primaryColor: AppColors.blue,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(
            fontFamily: fontFamily,
          ),
        ),
      ),
      primaryTextTheme: Theme.of(context).textTheme.apply(
            bodyColor: AppColors.black,
            displayColor: AppColors.black,
            fontFamily: fontFamily,
          ),
      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: AppColors.black,
            displayColor: AppColors.black,
            fontFamily: fontFamily,
          ),
     // dividerTheme: const DividerThemeData(color: AppColors.secondary6),
      radioTheme: const RadioThemeData(
         // fillColor: WidgetStatePropertyAll(AppColors.blue),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
      textSelectionTheme: const TextSelectionThemeData(
       // cursorColor: AppColors.blue,
      // selectionHandleColor: AppColors.blue,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        showDragHandle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.p16),
          //side: const BorderSide(color: AppColors.secondary5),
        ),
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        //modalBarrierColor: AppColors.secondary6.withOpacity(0.8),
        //dragHandleColor: AppColors.secondary4,
        dragHandleSize: const Size(Sizes.p80, Sizes.p6),
      ),
      tabBarTheme: const TabBarTheme(
        dividerColor: AppColors.transparent,
        labelStyle: AppTextStyles.s11w600,
        unselectedLabelStyle: AppTextStyles.s11w500,
        overlayColor: WidgetStatePropertyAll(AppColors.transparent),
        //unselectedLabelColor: AppColors.secondary2,
        //labelColor: AppColors.blue,
        labelPadding: EdgeInsets.zero,
        indicatorColor: AppColors.transparent,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        titleTextStyle: AppTextStyles.s22w600.apply(color: AppColors.black),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Sizes.p16,
          vertical: Sizes.p12,
        ),
        //errorStyle: AppTextStyles.s14w400.copyWith(color: AppColors.red_2),
        disabledBorder: OutlineInputBorder(
          //borderSide: const BorderSide(color: AppColors.secondary5),
          borderRadius: _textInputBorderRadius,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: _textInputBorderRadius,
          //borderSide: const BorderSide(color: AppColors.secondary5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: _textInputBorderRadius,
          //borderSide: const BorderSide(color: AppColors.blue),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: _textInputBorderRadius,
          //borderSide: const BorderSide(color: AppColors.red_2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          //borderSide: const BorderSide(color: AppColors.red_2),
          borderRadius: _textInputBorderRadius,
        ),
        //labelStyle: AppTextStyles.s16w400.copyWith(color: AppColors.secondary2),
        //floatingLabelStyle:
          //  AppTextStyles.s12w400.copyWith(color: AppColors.secondary2),
        // hintStyle: AppTextStyles.s16w400.copyWith(color: AppColors.secondary2),
        //  contentPadding: const EdgeInsets.only(bottom: Sizes.p12),
      ),
    );
