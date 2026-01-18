import 'package:flutter/material.dart';

class AddEventViewModel extends ChangeNotifier {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isPaid = false;
  String _paymentType = 'fixed';

  DateTime? get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;
  bool get isPaid => _isPaid;
  String get paymentType => _paymentType;

  void setSelectedDate(DateTime? date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setSelectedTime(TimeOfDay? time) {
    _selectedTime = time;
    notifyListeners();
  }

  void setIsPaid(bool value) {
    _isPaid = value;
    notifyListeners();
  }

  void setPaymentType(String type) {
    _paymentType = type;
    notifyListeners();
  }

  void reset() {
    _selectedDate = null;
    _selectedTime = null;
    _isPaid = false;
    _paymentType = 'fixed';
    notifyListeners();
  }
}
