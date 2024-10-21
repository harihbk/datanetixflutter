import 'package:loading_indicator/loading_indicator.dart';

class Settings {
  // prevent instantiating the class by making the constructor private
  Settings._();

  static const String appVersion = '2.0.12(16)';
  static const String apiVersion = '1';

// https://sapphireapi.datanetiix.com

  static const String subDomain =
      'sapphireapi.datanetiix.com'; // 'office' or 'sapphireapiv2.dev' or 'sapphireapi.stg2'
  // static const String domain = '$subDomain.zabecki.com';
  static const String domain = '$subDomain';

  static const String instanceUrl = 'https://$domain';
  static const String apiQueryPath = '/api/v$apiVersion';
  static const String apiPath = '$instanceUrl$apiQueryPath';

  static const String authUrl = '$apiPath/auth/login';
  static const String userUrl = '$apiPath/user';
  static const String organizationUrl = '$apiPath/organization';
  static const String transactionUrl = '$apiPath/transaction';
  static const String peopleUrl = '$apiPath/people';

  static const Indicator spinnerType = Indicator.ballRotateChase;

  static const double headerHeight = 108.0;
}
