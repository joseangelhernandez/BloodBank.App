
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../general/config/colors.dart';
import '../../../../general/utils/blank_space.dart';
import '../../../../general/utils/responsive.dart';
import '../../../../models/donor_model.dart';
import '../../../../providers/donor_provider.dart';
import '../../components/widgets/custom_appbar.dart';
import '../../components/widgets/custom_blood_group_box.dart';
import '../../components/widgets/custom_find_screen_item.dart';
import '../../components/widgets/custom_form_textfield.dart';
import '../../components/widgets/custom_red_btn.dart';
import '../../components/widgets/find_donor_date_picker.dart';


class DonorRegistrationForm extends StatefulWidget {
  static const pageRoute = "/donor-registration";

  const DonorRegistrationForm({super.key});

  @override
  State<DonorRegistrationForm> createState() => _DonorRegistrationFormState();
}

class _DonorRegistrationFormState extends State<DonorRegistrationForm> {
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _locationController = TextEditingController();

  String _bloodGroup = "A+"; // la caja empieza con A+ seleccionado
  DateTime? _lastDonationDate;

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.red, content: Text(message)),
    );
  }

  Future<void> _submit() async {
    final provider = context.read<DonorProvider>();
    if (provider.isLoading) return; // evita enviar dos veces

    if (_nameController.text.trim().isEmpty ||
        _contactController.text.trim().isEmpty ||
        _locationController.text.trim().isEmpty ||
        _lastDonationDate == null) {
      _showError("Please fill all required fields");
      return;
    }

    // La foto se queda sin seleccionar (no usamos image picker).
    final donor = DonorModel(
      name: _nameController.text.trim(),
      contactNumber: _contactController.text.trim(),
      bloodGroup: _bloodGroup,
      location: _locationController.text.trim(),
      lastDonationDate: _lastDonationDate!,
    );

    final ok = await provider.registerDonor(donor);
    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Donor successfully registered!")),
      );
      Navigator.pop(context);
    } else {
      _showError(provider.errorMessage ?? "Something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        actionTrue: true,
        titlee: "Donor Registration Form",
        
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomFormText(
                textt: "Select Donor picture",
                isRequired: true,
              ),
              verticalSpace(twentyPixelHeight(context)),
              
              Center(child: Image.asset("assets/icons/profile.png",width: twentyPixelWidth(context)*5,)),
              verticalSpace(twentyPixelHeight(context)*.5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/icons/camera_2.png",width: twentyPixelWidth(context)*1.5,),
                  horizontalSpace(twentyPixelWidth(context)),
                  Image.asset("assets/icons/gallary.png",width: twentyPixelWidth(context)*1.5,),
                ],
              ),
              verticalSpace(twentyPixelHeight(context)),
            const CustomFormText(textt: 'Name', isRequired: true),
            verticalSpace(twentyPixelHeight(context)*.5),
            CustomFormTextfield(hintTextt: "Jorge Perez",prefixFalse: false,controller: _nameController,),


            verticalSpace(twentyPixelHeight(context)),
            const CustomFormText(textt: 'Contact Number', isRequired: true),
            verticalSpace(twentyPixelHeight(context)*.5),
            CustomFormTextfield(hintTextt: "+18092249304",prefixFalse: false,controller: _contactController,),

            verticalSpace(twentyPixelHeight(context)),
            const CustomFormText(textt: "Blood Group", isRequired: true),
            verticalSpace(twentyPixelHeight(context)),
            
            Padding(
              padding:  EdgeInsets.only(
                left: twentyPixelWidth(context)*1.5,
                right: twentyPixelWidth(context)*1.5,
              ),
              child: CustomBloodGroupBox(
                onChanged: (group) => _bloodGroup = group,
              ),
            ),

            verticalSpace(twentyPixelHeight(context)),

        
            const CustomFormText(textt: "Location", isRequired: true),
            verticalSpace(twentyPixelHeight(context)*.5),
            CustomFormTextfield(hintTextt: "Santo Domingo, RD",prefixFalse: true,prefixxIcon:Icons.location_on,controller: _locationController),

            verticalSpace(twentyPixelHeight(context)),
            const CustomFormText(textt: "Last Date of Donation", isRequired: true),
            verticalSpace(twentyPixelHeight(context)*.5),
            FindDonorDatePicker(
              onChanged: (date) => _lastDonationDate = date,
            ),
            verticalSpace(twentyPixelHeight(context)*1.5),
            CustomRedBtn(
              textt: "Complete", 
              textColor: AppColor.whiteColor, 
              fillColor: AppColor.redColor,
              borderClr: Colors.transparent,
              onTap: _submit,
              ),

            
              
            ],
          ),
        ),
      ),
    );
  }
}

