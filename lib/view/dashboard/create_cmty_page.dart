import 'package:flutter/material.dart';
import 'package:urben_nest/utls/images.dart';
import 'package:urben_nest/utls/widgets/attach_button.dart';
import 'package:urben_nest/utls/widgets/costom_appbar.dart';
import 'package:urben_nest/utls/widgets/input_field.dart';
import 'package:urben_nest/utls/widgets/primery_button.dart';

class CreateCmtyPage extends StatelessWidget {
  const CreateCmtyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Create Community"),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: Column(
            children: [
              InputField(labelText: "Community Name"),
              InputField(labelText: "phone"),
              InputField(labelText: "location"),
              InputField(labelText: "flat/villa"),

              AttachButton(
                imagePath: Images.addImageIcon,
                label: "Add Community Image",
                onTap: () {},
              ),
              AttachButton(
                imagePath: Images.uploadIcon,
                label: "Upload documents proof",
                onTap: () {},
              ),

              SizedBox(height: 50),
              PrimeryButton(onPressed: () {}, text: "Create Community"),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
