part of 'connection_cubit.dart';

@immutable
abstract class UserConnectionState {}

class ConnectionInitial extends UserConnectionState {}

class TokenExpiredError extends UserConnectionState {}

class InternetConnectionState extends UserConnectionState {
  final bool hasConnection;

  InternetConnectionState(this.hasConnection);
}

class ConnectionSuccess extends UserConnectionState {}
