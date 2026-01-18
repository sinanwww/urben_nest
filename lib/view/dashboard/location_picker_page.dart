import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:urben_nest/utls/app_theme.dart';
import 'package:urben_nest/utls/widgets/primery_button.dart';
import 'package:urben_nest/view_model/location_picker_view_model.dart';

class LocationPickerPage extends StatelessWidget {
  const LocationPickerPage({super.key});

  static const CameraPosition _kDefaultPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    final Completer<GoogleMapController> controller =
        Completer<GoogleMapController>();

    return ChangeNotifierProvider(
      create: (context) {
        final viewModel = LocationPickerViewModel();
        viewModel.getCurrentLocation(controller);
        return viewModel;
      },
      child: Consumer<LocationPickerViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kDefaultPosition,
                  onMapCreated: (GoogleMapController mapController) {
                    controller.complete(mapController);
                  },
                  onCameraMove: (CameraPosition position) {
                    viewModel.updatePickedLocation(position.target);
                  },
                  onCameraIdle: () {
                    if (viewModel.pickedLocation != null) {
                      viewModel.getAddressFromLatLng(viewModel.pickedLocation!);
                    }
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                ),
                // Center Marker
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Icon(
                      Icons.location_on,
                      color: AppTheme.primary,
                      size: 50,
                    ),
                  ),
                ),
                // Back Button
                Positioned(
                  top: 50,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
                // Bottom Address Card
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Selected Location",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (viewModel.isGettingAddress)
                          const LinearProgressIndicator(minHeight: 2)
                        else
                          Text(
                            viewModel.pickedAddress ??
                                "Move map to select location",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        const SizedBox(height: 20),
                        PrimeryButton(
                          onPressed: viewModel.canConfirm
                              ? () {
                                  Navigator.of(context).pop({
                                    'latitude':
                                        viewModel.pickedLocation!.latitude,
                                    'longitude':
                                        viewModel.pickedLocation!.longitude,
                                    'address': viewModel.pickedAddress,
                                  });
                                }
                              : null,
                          text: "Confirm Location",
                        ),
                      ],
                    ),
                  ),
                ),
                // Loading Overlay
                if (viewModel.isLoading)
                  Container(
                    color: Colors.black54,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 180.0),
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () => viewModel.getCurrentLocation(controller),
                child: const Icon(Icons.my_location, color: Colors.black),
              ),
            ),
          );
        },
      ),
    );
  }
}
