import 'package:firebase_analytics/firebase_analytics.dart';

class AppAnalytics {
  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  static void setUserId(String? id) => analytics.setUserId(id: id);

  static void logSearchCompany({
    required final String company,
    required final String fullName,
    required final int companyId,
    required final int companyRank,
    required final int mainRatio,
  }) =>
      ///Maybe get text in text field and pass in search term on click asset tile
  analytics.logSearch(
    searchTerm: company,
    parameters: {
      'ticker': company,
      'fullName': fullName,
      'id': companyId,
      'rank': companyRank,
      'ratio': mainRatio,
    },
  );

  ///maybe log order_by filter separately
  static void logExplorePeers(Map<String, dynamic> filters) =>
      analytics.logEvent(
        name: 'explore_peers',
        parameters: filters.cast(),
      );

  //know what order users prefer
  static void logChangeAssetPage({
    required String page,
    required int index,
  }) =>
      analytics.logEvent(
        name: 'change_asset_page',
        parameters: {'page': page, 'index': index},
      );

  static void logPurchase({
    required final String? currency,
    required final String? transactionId,
    required final double? price,
  }) =>
      analytics.logPurchase(
        currency: currency,
        value: price,
        transactionId: transactionId,
      );

  static void logRestorePurchase({
    required final String? currency,
    required final String? transactionId,
    required final double? price,
  }) =>
      analytics.logEvent(
        name: 'restore_purchase',
        parameters: {
          'currency': currency,
          'value': price,
          'transactionId': transactionId,
        }.cast(),
      );

  static void logSelectSubscription({
    required final String currency,
    required final double price,
  }) =>
      analytics.logViewItem(currency: currency, value: price);

  static void logSignUp(String signUpMethod) =>
      analytics.logSignUp(signUpMethod: signUpMethod);

  static void logLogin(String loginMethod) =>
      analytics.logLogin(loginMethod: loginMethod);
}