import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:new_project_template/assets/app_colors.dart';
import 'package:new_project_template/assets/app_sizes.dart';
import 'package:new_project_template/assets/asset_paths.dart';
import 'package:new_project_template/features/ui/common_widgets/close_app_observer.dart';
import 'package:new_project_template/features/ui/pages/profile_page/cubit/profile_page_cubit.dart';
import 'package:new_project_template/features/ui/pages/profile_page/profile_page.dart';

const List<String> _navBarIcons = [
  'IconAssetsPaths.a',
  'IconAssetsPaths.b',
  'IconAssetsPaths.c',
];

const List<String> _navBarInactiveIcons = [
  'IconAssetsPaths.a',
  'IconAssetsPaths.b',
  'IconAssetsPaths.c',
];

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  static const routeName = 'navbar';

  @override
  State<NavBar> createState() => NavBarState();
}

class NavBarState extends State<NavBar> with SingleTickerProviderStateMixin {
  late final TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(
      length: _navBarIcons.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _NavBarBody(controller);
}

class _NavBarBody extends StatelessWidget {
  const _NavBarBody(this.controller);

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return CloseAppObserver(
      child: BlocListener<ProfilePageCubit, ProfilePageState>(
        listener: (context, state) async {},
        child: Scaffold(
          extendBody: true,
          bottomNavigationBar: _BottomNavBar(controller),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller,
            children: const [
              ProfilePage(),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatefulWidget {
  const _BottomNavBar(this.controller);

  final TabController controller;

  @override
  State<_BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<_BottomNavBar> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.black))),
      child: Padding(
        padding: const EdgeInsets.only(bottom: Sizes.p10),
        child: TabBar(
          controller: widget.controller,
          tabs: List.generate(
            _navBarIcons.length,
            (index) => GestureDetector(
              onTap: () {},
              child: Tab(
                text: 'tabs.$index'.tr(),
                iconMargin: const EdgeInsets.only(bottom: Sizes.p4),
                icon: SvgPicture.asset(
                  widget.controller.index == index
                      ? _navBarIcons[index]
                      : _navBarInactiveIcons[index],
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
