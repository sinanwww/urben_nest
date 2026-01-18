import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:urben_nest/services/payment_service.dart';

class EventDetailViewModel extends ChangeNotifier {
  late PaymentService _paymentService;
  bool _isPaymentSuccessful = false;

  bool get isPaymentSuccessful => _isPaymentSuccessful;

  // For showing snackbars
  String? _successMessage;
  String? get successMessage => _successMessage;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _externalWalletName;
  String? get externalWalletName => _externalWalletName;

  EventDetailViewModel() {
    _paymentService = PaymentService(
      onSuccess: _handlePaymentSuccess,
      onFailure: _handlePaymentError,
      onExternalWallet: _handleExternalWallet,
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _isPaymentSuccessful = true;
    _successMessage = "Payment Successful: ${response.paymentId}";
    _errorMessage = null;
    _externalWalletName = null;
    notifyListeners();
    // Reset message immediately so it doesn't trigger again on rebuilds if we were using a listener
    // But better pattern is for the view to consume it. Here we just notify.
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _errorMessage = "Payment Failed: ${response.message}";
    _successMessage = null;
    _externalWalletName = null;
    notifyListeners();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _externalWalletName = response.walletName;
    _successMessage = null;
    _errorMessage = null;
    notifyListeners();
  }

  void initiatePayment({required double amount, required String title}) {
    _paymentService.openCheckout(
      amount: amount,
      name: "Urban Nest",
      description: "Payment for $title",
      contact: "7736622112",
      email: "sinanr475@gmail.com",
    );
  }

  void clearMessages() {
    _successMessage = null;
    _errorMessage = null;
    _externalWalletName = null;
    // We don't necessarily need to notifyListeners here depending on how we consume it,
    // but if we want to clear the state, we can.
  }

  @override
  void dispose() {
    _paymentService.dispose();
    super.dispose();
  }
}
