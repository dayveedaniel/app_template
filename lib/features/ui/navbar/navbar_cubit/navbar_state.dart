part of 'navbar_cubit.dart';

@immutable
class NavbarState {
  final String? errorMessage;

  const NavbarState({this.errorMessage});

  NavbarState copyWith({String? errorMessage}) => NavbarState(
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
