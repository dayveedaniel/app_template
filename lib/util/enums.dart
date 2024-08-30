// ignore_for_file: constant_identifier_names

enum FontFamily { Urbanist, AzeretMono }

enum HttpErrorCodes {
  RefreshTokenExpired(415),
  AccessTokenExpired(401),
  NotAllowedInTariff(600),
  UserNotFound(411),
  NoRecordsFound(430),
  AlreadyExists(417);

  final int errorCode;

  const HttpErrorCodes(this.errorCode);
}