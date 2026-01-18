import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerViewModel extends ChangeNotifier {
  LatLng? _pickedLocation;
  String? _pickedAddress;
  bool _isLoading = true;
  bool _isGettingAddress = false;

  LatLng? get pickedLocation => _pickedLocation;
  String? get pickedAddress => _pickedAddress;
  bool get isLoading => _isLoading;
  bool get isGettingAddress => _isGettingAddress;

  bool get canConfirm => _pickedLocation != null && !_isGettingAddress;

  void updatePickedLocation(LatLng location) {
    _pickedLocation = location;
    notifyListeners();
  }

  Future<void> getCurrentLocation(
    Completer<GoogleMapController> controller,
  ) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _isLoading = false;
        notifyListeners();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    LatLng currentLatLng = LatLng(position.latitude, position.longitude);

    _pickedLocation = currentLatLng;
    _isLoading = false;
    notifyListeners();

    await getAddressFromLatLng(currentLatLng);
    await _moveCamera(controller, currentLatLng);
  }

  Future<void> _moveCamera(
    Completer<GoogleMapController> controller,
    LatLng target,
  ) async {
    final GoogleMapController mapController = await controller.future;
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: target, zoom: 16)),
    );
  }

  Future<void> getAddressFromLatLng(LatLng position) async {
    _isGettingAddress = true;
    notifyListeners();

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address =
            '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
        address = address
            .replaceAll(RegExp(r', ,'), ',')
            .replaceAll(RegExp(r'^, |,$'), '');

        _pickedAddress = address;
      }
    } catch (e) {
      debugPrint("Error getting address: $e");
    } finally {
      _isGettingAddress = false;
      notifyListeners();
    }
  }
}
