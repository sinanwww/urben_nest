import 'package:flutter/material.dart';

class CreateCommunityViewModel extends ChangeNotifier {
  Map<String, dynamic>? _selectedLocation;

  Map<String, dynamic>? get selectedLocation => _selectedLocation;

  void setLocation(Map<String, dynamic> location) {
    _selectedLocation = location;
    notifyListeners();
  }

  void clearLocation() {
    _selectedLocation = null;
    notifyListeners();
  }
}
