import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'package:new_project_template/domain/services/user_auth_service.dart';


part 'navbar_state.dart';

@injectable
class NavbarCubit extends Cubit<NavbarState> {
  NavbarCubit(
    this._authService,
  ) : super(const NavbarState());

  final AuthService _authService;

}
