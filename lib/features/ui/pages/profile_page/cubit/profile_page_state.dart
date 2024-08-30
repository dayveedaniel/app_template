part of 'profile_page_cubit.dart';

@immutable
class ProfilePageState {
  final UserModel? userProfile;
  final String? errorMessage;

  const ProfilePageState({
    this.userProfile,
    this.errorMessage,
  });

  ProfilePageState copyWith({
    UserModel? userProfile,
    String? errorMessage,
  }) =>
      ProfilePageState(
        userProfile: userProfile ?? this.userProfile,
        errorMessage: errorMessage ?? this.errorMessage,
      );

}
