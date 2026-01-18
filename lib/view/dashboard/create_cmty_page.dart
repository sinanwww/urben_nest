// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:urben_nest/utls/validators.dart';
// import 'package:urben_nest/utls/images.dart';
// import 'package:urben_nest/utls/widgets/attach_button.dart';
import 'package:urben_nest/utls/widgets/costom_appbar.dart';
import 'package:urben_nest/utls/widgets/input_field.dart';
import 'package:urben_nest/utls/widgets/primery_button.dart';
import 'package:urben_nest/view/dashboard/location_picker_page.dart';
import 'package:urben_nest/view_model/community_view_model.dart';
import 'package:urben_nest/view_model/create_community_view_model.dart';

class CreateCmtyPage extends StatefulWidget {
  const CreateCmtyPage({super.key});

  @override
  State<CreateCmtyPage> createState() => _CreateCmtyPageState();
}

class _CreateCmtyPageState extends State<CreateCmtyPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _propertyTypeController = TextEditingController();
  // XFile? _communityImage;
  // PlatformFile? _documentProof;

  // final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _propertyTypeController.dispose();
    super.dispose();
  }

  // Future<void> _pickCommunityImage() async {
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     setState(() {
  //       _communityImage = image;
  //     });
  //   }
  // }

  // Future<void> _pickDocument() async {
  //   try {
  //     FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
  //     );

  //     if (result != null) {
  //       setState(() {
  //         _documentProof = result.files.first;
  //       });
  //     }
  //   } catch (e) {
  //     debugPrint("Error picking document: $e");
  //     if (mounted) {
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(SnackBar(content: Text('Error picking file: $e')));
  //     }
  //   }
  // }

  Future<void> _pickLocation() async {
    final viewModel = Provider.of<CreateCommunityViewModel>(
      context,
      listen: false,
    );
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LocationPickerPage()),
    );

    if (result != null && result is Map<String, dynamic>) {
      viewModel.setLocation(result);
      _locationController.text = result['address'] ?? 'Location Selected';
    }
  }

  Future<void> _submitRequest(
    CommunityViewModel communityViewModel,
    CreateCommunityViewModel locationViewModel,
  ) async {
    if (_formKey.currentState!.validate()) {
      // if (_communityImage == null) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Please add a community image')),
      //   );
      //   return;
      // }
      // if (_documentProof == null) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Please upload document proof')),
      //   );
      //   return;
      // }
      if (locationViewModel.selectedLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a location')),
        );
        return;
      }

      final success = await communityViewModel.createCommunityRequest(
        communityName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        location: locationViewModel.selectedLocation!,
        propertyType: _propertyTypeController.text.trim(),
        // communityImage: _communityImage!,
        // documentProof: _documentProof!,
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Request submitted successfully to Super Admin!'),
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                communityViewModel.errorMessage ?? 'Submission failed',
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateCommunityViewModel(),
      child: Consumer2<CreateCommunityViewModel, CommunityViewModel>(
        builder: (context, locationViewModel, communityViewModel, child) {
          return Scaffold(
            appBar: CustomAppbar(title: "Create Community"),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          InputField(
                            labelText: "Community Name",
                            controller: _nameController,
                            validator: Validators.validateCommunityName,
                          ),
                          InputField(
                            labelText: "Phone",
                            controller: _phoneController,
                            validator: Validators.validatePhone,
                          ),

                          // Location Field with Picker
                          GestureDetector(
                            onTap: _pickLocation,
                            child: AbsorbPointer(
                              child: InputField(
                                labelText: "Location",
                                controller: _locationController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select location';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),

                          InputField(
                            labelText: "Flat/Villa",
                            controller: _propertyTypeController,
                            validator: (value) => Validators.validateRequired(
                              value,
                              'Property type',
                            ),
                          ),

                          const SizedBox(height: 20),

                          const SizedBox(height: 20),

                          // Community Image Picker
                          // _communityImage != null
                          //     ? Padding(
                          //         padding: const EdgeInsets.only(top: 20),
                          //         child: GestureDetector(
                          //           onTap: _pickCommunityImage,
                          //           child: Container(
                          //             height: 150,
                          //             width: double.infinity,
                          //             decoration: BoxDecoration(
                          //               borderRadius: BorderRadius.circular(8),
                          //               border: Border.all(color: Colors.grey),
                          //               image: DecorationImage(
                          //                 image: kIsWeb
                          //                     ? NetworkImage(
                          //                         _communityImage!.path,
                          //                       )
                          //                     : FileImage(
                          //                             File(
                          //                               _communityImage!.path,
                          //                             ),
                          //                           )
                          //                           as ImageProvider,
                          //                 fit: BoxFit.cover,
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       )
                          //     : AttachButton(
                          //         imagePath: Images.addImageIcon,
                          //         label: "Add Community Image",
                          //         onTap: _pickCommunityImage,
                          //       ),
                          const SizedBox(height: 10),

                          // Document Proof Picker
                          // _documentProof != null
                          //     ? Padding(
                          //         padding: const EdgeInsets.only(top: 20),
                          //         child: GestureDetector(
                          //           onTap: _pickDocument,
                          //           child: Container(
                          //             height: 150,
                          //             width: double.infinity,
                          //             decoration: BoxDecoration(
                          //               borderRadius: BorderRadius.circular(8),
                          //               border: Border.all(color: Colors.grey),
                          //               image:
                          //                   ['jpg', 'jpeg', 'png'].contains(
                          //                     _documentProof!.extension
                          //                         ?.toLowerCase(),
                          //                   )
                          //                   ? DecorationImage(
                          //                       image: kIsWeb
                          //                           ? NetworkImage(
                          //                               _documentProof!.path ??
                          //                                   '',
                          //                             )
                          //                           : FileImage(
                          //                                   File(
                          //                                     _documentProof!
                          //                                         .path!,
                          //                                   ),
                          //                                 )
                          //                                 as ImageProvider,
                          //                       fit: BoxFit.cover,
                          //                     )
                          //                   : null,
                          //             ),
                          //             child:
                          //                 ['jpg', 'jpeg', 'png'].contains(
                          //                   _documentProof!.extension
                          //                       ?.toLowerCase(),
                          //                 )
                          //                 ? null
                          //                 : Column(
                          //                     mainAxisAlignment:
                          //                         MainAxisAlignment.center,
                          //                     children: [
                          //                       const Icon(
                          //                         Icons.description,
                          //                         size: 50,
                          //                         color: Colors.blue,
                          //                       ),
                          //                       const SizedBox(height: 10),
                          //                       Padding(
                          //                         padding:
                          //                             const EdgeInsets.symmetric(
                          //                               horizontal: 8.0,
                          //                             ),
                          //                         child: Text(
                          //                           _documentProof!.name,
                          //                           style: const TextStyle(
                          //                             fontSize: 14,
                          //                             color: Colors.black87,
                          //                             fontWeight:
                          //                                 FontWeight.w500,
                          //                           ),
                          //                           textAlign: TextAlign.center,
                          //                           overflow:
                          //                               TextOverflow.ellipsis,
                          //                         ),
                          //                       ),
                          //                     ],
                          //                   ),
                          //           ),
                          //         ),
                          //       )
                          //     : AttachButton(
                          //         imagePath: Images.uploadIcon,
                          //         label: "Upload documents proof (PDF/Image)",
                          //         onTap: _pickDocument,
                          //       ),
                          const SizedBox(height: 50),

                          PrimeryButton(
                            onPressed: communityViewModel.isLoading
                                ? null
                                : () => _submitRequest(
                                    communityViewModel,
                                    locationViewModel,
                                  ),
                            text: communityViewModel.isLoading
                                ? "Submitting..."
                                : "Create Community",
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ),
                if (communityViewModel.isLoading)
                  Container(
                    color: Colors.black54,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
