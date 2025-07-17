import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_client/core/constants/api_constants.dart';
import 'package:http/http.dart' as http;

import 'package:dartz/dartz.dart';
import 'package:food_client/core/failure/failure.dart';

abstract interface class PaymentRemoteRepository {
  Future<Either<AppFailure, Map<String, dynamic>>> createPaymentIntent(
    int amount,
  );
  Future<Either<AppFailure, void>> initPaymentSheet(String clientSecret);
  Future<Either<AppFailure, void>> presentPaymentSheet();
}

class PaymentRemoteRepositoryImpl implements PaymentRemoteRepository {
  final http.Client httpClient;
  const PaymentRemoteRepositoryImpl(this.httpClient);

  @override
  Future<Either<AppFailure, Map<String, dynamic>>> createPaymentIntent(
    int amount,
  ) async {
    try {
      final url = Uri.parse(ApiConstants.paymentIntentUrl);

      // Convert amount to cents for USD
      final int amountInCents = amount * 100;

      final body = {'amount': amountInCents.toString(), 'currency': 'INR'};

      final secretKey = dotenv.env['STRIPE_SECRET_KEY'];

      // print('secretKey: $secretKey');

      final response = await httpClient.post(
        url,
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        debugPrint('Created payment intent: ${json['client_secret']}');
        return right(json);
      } else {
        debugPrint(
          'Failed to create payment intent: ${response.statusCode} ${response.body}',
        );
        return left(AppFailure('Failed to create payment intent'));
      }
    } catch (e) {
      debugPrint('Exception: ${e.toString()}');
      return left(AppFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, void>> initPaymentSheet(String clientSecret) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'Quick Foodie',
          paymentIntentClientSecret: clientSecret,
          googlePay: PaymentSheetGooglePay(
            merchantCountryCode: 'US',
            testEnv: true,
          ),
          style: ThemeMode.light,
        ),
      );

      return right(null);
    } catch (e) {
      debugPrint('Exception 1: ${e.toString()}');
      return left(AppFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, void>> presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();

      return right(null);
    } on StripeException catch (e) {
      String errorMssg = '';
      switch (e.error.code) {
        case FailureCode.Canceled:
          errorMssg = 'Payment Cancelled!!!';
          break;
        case FailureCode.Failed:
          errorMssg = 'Payment Failed!!!';
          break;
        case FailureCode.Timeout:
          errorMssg = 'Payment Timeout!!!';
          break;
        case FailureCode.Unknown:
          errorMssg = 'Payment Unknown!!!';
          break;
      }
      return left(AppFailure(errorMssg));
    } catch (e) {
      debugPrint('Exception 2: ${e.toString()}');
      return left(AppFailure(e.toString()));
    }
  }
}
