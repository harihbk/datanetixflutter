import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:square_reader_sdk/models.dart';
import 'package:square_reader_sdk/reader_sdk.dart';

class SquareService {
  String? _authToken;
  DateTime? _authTokenExpireTime;

  bool _isReaderAuthorized = false;

  get isReaderAuthorized => _isReaderAuthorized;

  Future<void> getAuthorizationToken() async {
    // print('***** START GET AUTHORIZATION TOKEN');
    Map<String, String> _headers = {};
    Map<String, String> _body = {};
    try {
      _headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'Authorization':
            'Bearer EAAAEOHuxTzq9UdM8Nt3WDvrJH-N9zz-nz-MuoZDDBNF22GRAdF7kI9RXhD9H5Ag',
        'Square-Version': '2023-07-20',
      };
      _body = {
        'location_id': 'D3N6BSXKCGM3A',
      };

      final http.Response response = await http.post(
        Uri.parse('https://connect.squareup.com/mobile/authorization-code'),
        body: _body,
        headers: _headers,
      );

      final jsonData = jsonDecode(response.body);
      // log('***** GET AUTHORIZATION TOKEN JSONDATA: ${jsonData.toString()}');

      // print('***** GET AUTHORIZATION TOKEN STATUS CODE: ${response.statusCode}');
      // log('***** GET AUTHORIZATION TOKEN BODY: ${response.body}');
      // log('***** GET AUTHORIZATION TOKEN: ${jsonData['authorization_code']}');
      // log('***** GET AUTHORIZATION TOKEN EXPIRES IN: ${jsonData['expires_at']}');
      if (response.statusCode == 200) {
        _authToken = jsonData['authorization_code'] as String;
        _authTokenExpireTime = DateTime.parse(jsonData['expires_at'] as String);
        // print('***** GET AUTHORIZATION TOKEN : $_authToken');
        // print('***** GET AUTHORIZATION TOKEN EXPIRES TIME: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(_authTokenExpireTime!)}');
      } else {
        // print('***** GET AUTHORIZATION TOKEN NOT 200 BODY: ${jsonData.toString()}');
      }
    } catch (e) {
      // print('***** GET AUTHORIZATION TOKEN ERROR: ${e.toString()}');
    }
  }

  Future<void> confirmValidToken() async {
    if (_authToken == null) {
      await getAuthorizationToken();
    }
    final DateTime today = DateTime.now();
    final Duration difference = _authTokenExpireTime!.difference(today);
    // print('***** CONFIRM VALID TOKEN DIFFERENCE: ${difference.inMinutes}');
    if (difference.inMinutes < 2) {
      // print('***** CONFIRM VALID TOKEN SHOULD REFRESH');
      await getAuthorizationToken();
    }
  }

  Future<void> initializeReader() async {
    await confirmValidToken();
    // print('***** INITIALIZE READER');
    // try {
    //   await ReaderSdk.authorize(_authToken!);
    //   await ReaderSdk.startReaderSettings();
    //   _isReaderAuthorized = true;
    // } on ReaderSdkException catch (e) {
    //   switch (e.code) {
    //     case ErrorCode.authorizeErrorNoNetwork:
    //       log('***** READER AUTHORIZE ERROR NO NETWORK');
    //       break;
    //     case ErrorCode.usageError:
    //       log('***** READER AUTHORIZE ERROR: ${e.code}:${e.debugCode}:${e.debugMessage}');
    //       break;
    //     case ErrorCode.readerSettingsErrorSdkNotAuthorized:
    //       log('***** READER AUTHORIZE ERROR SDK NOT AUTHORIZED');
    //       break;
    //     default:
    //       log('***** READER AUTHORIZE ERROR: ${e.code}:${e.debugCode}:${e.debugMessage}');
    //   }
    // } catch (e) {
    //   log('***** READER AUTHORIZE ERROR: ${e.toString()}');
    // }
  }

  Future<Object> charge(
      {required int amount, required String transactionText}) async {
    return "123";
    // CheckoutParametersBuilder builder = CheckoutParametersBuilder();

    // builder.amountMoney = MoneyBuilder()
    //   ..amount = amount
    //   ..currencyCode = 'USD';
    // builder.skipReceipt = true;
    // builder.collectSignature = false;
    // builder.allowSplitTender = false;
    // builder.delayCapture = false;
    // builder.note = transactionText;

    // CheckoutParameters checkoutParameters = builder.build();

    // try {
    //   CheckoutResult checkoutResult = await ReaderSdk.startCheckout(checkoutParameters);
    //   Object result = {
    //     'transactionId': checkoutResult.transactionId,
    //     'transactionClientID': checkoutResult.transactionClientId,
    //     'transactionLocationID': checkoutResult.locationId,
    //     'createdAt': checkoutResult.createdAt,
    //     'tenderId': checkoutResult.tenders[0].tenderId,
    //     'totalMoney': {
    //       'amount': checkoutResult.totalMoney.amount,
    //       'currencyCode': checkoutResult.totalMoney.currencyCode,
    //     },
    //     'cardDetails': {
    //       'type': checkoutResult.tenders[0].cardDetails!.card.brand.toString(),
    //       'lastFourDigits': checkoutResult.tenders[0].cardDetails!.card.lastFourDigits,
    //     },
    //   };
    //   return result;
    // } on ReaderSdkException catch (e) {
    //   switch (e.code) {
    //     case ErrorCode.checkoutErrorCanceled:
    //       throw Exception('Checkout canceled');
    //     case ErrorCode.checkoutErrorSdkNotAuthorized:
    //       throw Exception('Reader SDK not authorized');
    //     default:
    //       throw Exception('${e.code}:${e.debugCode}:${e.debugMessage}');
    //   }

    // }
  }
}
