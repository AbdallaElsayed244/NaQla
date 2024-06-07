import 'package:Naqla/stripe_payment/components/stripe_keys.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

abstract class PaymentManager {
  static Future<void> makePayment(int amount, String currency) async {
    try {
      String clientSecret =
          await _getClientSecret((amount * 100).toString(), currency);
      await _initializePaymentSheet(clientSecret);
      await Stripe.instance.presentPaymentSheet();
    } catch (error) {
      print('Error in makePayment: $error');
      throw Exception('Payment failed: $error');
    }
  }

  static Future<void> _initializePaymentSheet(String clientSecret) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'basel',
        ),
      );
    } catch (error) {
      print('Error in _initializePaymentSheet: $error');
      throw Exception('Failed to initialize payment sheet: $error');
    }
  }

  static Future<String> _getClientSecret(String amount, String currency) async {
    try {
      Dio dio = Dio();
      var response = await dio.post(
        'https://api.stripe.com/v1/payment_intents',
        options: Options(headers: {
          'Authorization': 'Bearer ${ApiKeys.secretkey}',
          'Content-Type': 'application/x-www-form-urlencoded',
        }),
        data: {
          'amount': amount,
          'currency': currency,
        },
      );
      return response.data['client_secret'];
    } catch (error) {
      if (error is DioException && error.response != null) {
        print(
            'Dio error: ${error.response?.statusCode} ${error.response?.data}');
        throw Exception('Failed to get client secret: ${error.response?.data}');
      } else {
        print('Error in _getClientSecret: $error');
        throw Exception('Failed to get client secret: $error');
      }
      
    }
  }
}
