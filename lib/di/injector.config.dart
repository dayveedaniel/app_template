// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../data/remote/http/api_provider.dart' as _i780;
import '../data/remote/http/core/http_client.dart' as _i586;
import '../data/remote/http/core/i_http_client.dart' as _i64;
import '../data/remote/web_socket/web_socket_client.dart' as _i970;
import '../domain/repositories/user_repository.dart' as _i544;
import '../domain/services/user_auth_service.dart' as _i393;
import '../domain/services/web_socket_service.dart' as _i880;
import '../features/ui/common_blocs/connection_cubit/connection_cubit.dart'
    as _i43;
import '../features/ui/navbar/navbar_cubit/navbar_cubit.dart' as _i665;
import '../features/ui/pages/auth_pages/create_account_page/cubit/create_account_cubit.dart'
    as _i377;
import '../features/ui/pages/auth_pages/login_page/cubit/login_cubit.dart'
    as _i468;
import '../features/ui/pages/auth_pages/verify_email_page/cubit/verify_email_page_cubit.dart'
    as _i720;
import '../features/ui/pages/profile_page/cubit/profile_page_cubit.dart'
    as _i57;
import '../util/log_service.dart' as _i85;

const String _dev = 'dev';
const String _test = 'test';
const String _prod = 'prod';

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i970.WebSocketClient>(() => _i970.WebSocketClient());
    gh.singleton<_i780.ApiProvider>(() => _i780.ApiProvider());
    gh.singleton<_i544.UserRepository>(() => _i544.UserRepository());
    gh.factory<_i64.BaseHttpClient>(
      () => _i586.MHttpClient(),
      registerFor: {_dev},
    );
    gh.factory<_i43.ConnectionCubit>(
        () => _i43.ConnectionCubit(gh<_i780.ApiProvider>()));
    gh.factory<_i85.LogService>(
      () => _i85.LogServiceDev(),
      registerFor: {
        _dev,
        _test,
      },
    );
    gh.singleton<_i393.AuthService>(() => _i393.AuthService(
          gh<_i780.ApiProvider>(),
          gh<_i544.UserRepository>(),
        ));
    gh.factory<_i85.LogService>(
      () => _i85.LogServiceProd(),
      registerFor: {_prod},
    );
    gh.factoryParam<_i468.LoginCubit, String?, dynamic>((
      initialEmail,
      _,
    ) =>
        _i468.LoginCubit(
          gh<_i393.AuthService>(),
          initialEmail,
        ));
    gh.factoryParam<_i377.CreateAccountCubit, String?, dynamic>((
      initialEmail,
      _,
    ) =>
        _i377.CreateAccountCubit(
          gh<_i393.AuthService>(),
          initialEmail,
        ));
    gh.factory<_i880.WebSocketService>(
        () => _i880.WebSocketService(gh<_i970.WebSocketClient>()));
    gh.factoryParam<_i720.VerifyEmailPageCubit, String, dynamic>((
      email,
      _,
    ) =>
        _i720.VerifyEmailPageCubit(
          gh<_i393.AuthService>(),
          email,
        ));
    gh.factory<_i665.NavbarCubit>(
        () => _i665.NavbarCubit(gh<_i393.AuthService>()));
    gh.factory<_i57.ProfilePageCubit>(
        () => _i57.ProfilePageCubit(gh<_i393.AuthService>()));
    return this;
  }
}
