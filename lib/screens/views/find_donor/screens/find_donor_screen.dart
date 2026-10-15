
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../general/config/colors.dart';
import '../../../../general/utils/blank_space.dart';
import '../../../../general/utils/responsive.dart';
import '../../../../models/blood_request_model.dart';
import '../../../../providers/blood_request_provider.dart';
import '../../../../providers/profile_provider.dart';
import '../../components/widgets/custom_appbar.dart';
import '../../components/widgets/custom_blood_group_box.dart';
import '../../components/widgets/custom_find_screen_item.dart';
import '../../components/widgets/custom_form_textfield.dart';
import '../../components/widgets/custom_gender_box.dart';
import '../../components/widgets/custom_red_btn.dart';
import '../../components/widgets/find_donor_date_picker.dart';


class FindDonorScreen extends StatefulWidget {
  static const pageRoute = '/find-donor';

  const FindDonorScreen({super.key});

  @override
  State<FindDonorScreen> createState() => _FindDonorScreenState();
}

class _FindDonorScreenState extends State<FindDonorScreen> {
  // Un controller por cada campo de texto del formulario.
  final _bagsController = TextEditingController();
  final _contactController = TextEditingController();
  final _emergencyController = TextEditingController();
  final _patientNameController = TextEditingController();
  final _causeController = TextEditingController();
  final _locationController = TextEditingController();
  final _othersController = TextEditingController();

  // Valores iniciales iguales a lo que las cajas muestran seleccionado.
  String _bloodGroup = "A+";
  String _gender = "Male";
  DateTime? _neededBefore;

  @override
  void initState() {
    super.initState();
    // Prellenamos con la ubicacion del perfil; el usuario la puede cambiar.
    _locationController.text = context.read<ProfileProvider>().profile?.location ?? "";
  }

  @override
  void dispose() {
    _bagsController.dispose();
    _contactController.dispose();
    _emergencyController.dispose();
    _patientNameController.dispose();
    _causeController.dispose();
    _locationController.dispose();
    _othersController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.red, content: Text(message)),
    );
  }

  Future<void> _submit() async {
    final provider = context.read<BloodRequestProvider>();
    if (provider.isLoading) return; // evita enviar dos veces

    final bags = int.tryParse(_bagsController.text.trim());
    if (bags == null ||
        _contactController.text.trim().isEmpty ||
        _emergencyController.text.trim().isEmpty ||
        _patientNameController.text.trim().isEmpty ||
        _causeController.text.trim().isEmpty ||
        _locationController.text.trim().isEmpty ||
        _neededBefore == null) {
      _showError("Please fill all required fields");
      return;
    }

    final others = _othersController.text.trim();

    final request = BloodRequestModel(
      patientName: _patientNameController.text.trim(),
      bloodGroup: _bloodGroup,
      bags: bags,
      contactNumber: _contactController.text.trim(),
      emergencyContact: _emergencyController.text.trim(),
      cause: _causeController.text.trim(),
      gender: _gender,
      location: _locationController.text.trim(),
      neededBefore: _neededBefore!,
      notes: others.isEmpty ? null : others,
    );

    final ok = await provider.createRequest(request);
    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Request successfully created!")),
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
        titlee: "Request for Blood Donor",
        actionTrue: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: twentyPixelWidth(context),
            right: twentyPixelWidth(context),
            bottom: twentyPixelHeight(context),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpace(twentyPixelHeight(context)),
              Center(
                child: Text(
                  "Patient Details",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColor.blackColor,
                      fontFamily: "Poppins"),
                  textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
                ),
              ),
              verticalSpace(twentyPixelHeight(context)),
              const CustomFormText(
                textt: "Choose Blood Group",
                isRequired: true,
              ),
              verticalSpace(twentyPixelHeight(context) * .5),
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
              const CustomFormText(
                textt: "Number of Bags",
                isRequired: true,
              ),
              verticalSpace(twentyPixelHeight(context) * .5),
              Row(
                children: [
                  Expanded(
                      child: CustomFormTextfield(
                    hintTextt: "3",
                    prefixFalse: false,
                    controller: _bagsController,
                  )),
                  horizontalSpace(twentyPixelWidth(context) * .5),
                  const Text(
                    "Bags",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Poppins",
                      color: AppColor.blackColor,
                    ),
                  )
                ],
              ),
              verticalSpace(twentyPixelHeight(context)),
              const CustomFormText(
                textt: "Contact Number",
                isRequired: true,
              ),
              verticalSpace(twentyPixelHeight(context) * .5),
              CustomFormTextfield(
                  hintTextt: "+880188888888", prefixxIcon: Icons.call,
                  controller: _contactController),

              //Emergency Contact
              verticalSpace(twentyPixelHeight(context)),
              const CustomFormText(
                textt: "Emergency Contact",
                isRequired: true,
              ),
              verticalSpace(twentyPixelHeight(context) * .5),
              CustomFormTextfield(
                hintTextt: "+88019999999",
                prefixFalse: true,
                prefixxIcon: Icons.call,
                controller: _emergencyController,
              ),

              //Patient Nabe
              verticalSpace(twentyPixelHeight(context)),
              const CustomFormText(
                textt: "Patient Name",
                isRequired: true,
              ),
              verticalSpace(twentyPixelHeight(context) * .5),
              CustomFormTextfield(
                  hintTextt: "Jorge Perez",
                  prefixFalse: true,
                  prefixxIcon: Icons.person,
                  controller: _patientNameController),

              //Case
              verticalSpace(twentyPixelHeight(context)),
              const CustomFormText(
                textt: "Case",
                isRequired: true,
              ),
              verticalSpace(twentyPixelHeight(context) * .5),
              CustomFormTextfield(
                  hintTextt: "Cancer Patient",
                  prefixFalse: false,
                  prefixxIcon: Icons.person,
                  controller: _causeController),

              //Location
              verticalSpace(twentyPixelHeight(context)),
              const CustomFormText(
                textt: "Location",
                isRequired: true,
              ),
              verticalSpace(twentyPixelHeight(context) * .5),
              CustomFormTextfield(
                  hintTextt: "Santo Domingo",
                  prefixxIcon: Icons.location_on,
                  controller: _locationController),

              //Gender
              verticalSpace(twentyPixelHeight(context)),
              const CustomFormText(
                textt: "Gender",
                isRequired: false,
              ),
              verticalSpace(twentyPixelHeight(context) * 1.5),

              Padding(
                padding:  EdgeInsets.only(
                  left: twentyPixelWidth(context)*3,
                  right: twentyPixelWidth(context)*3,
                ),
                child: CustomGenderBox(
                  // La caja da "male"/"female"; el backend espera "Male"/"Female".
                  onChanged: (gender) =>
                      _gender = gender == "male" ? "Male" : "Female",
                ),
              ),

              verticalSpace(twentyPixelHeight(context) * 1.5),
              const CustomFormText(
                  textt: "Blood Need Before", isRequired: true),
              verticalSpace(twentyPixelHeight(context) * .5),

              FindDonorDatePicker(
                onChanged: (date) => _neededBefore = date,
              ),
              


              verticalSpace(twentyPixelHeight(context)),
              const CustomFormText(
                textt: "Others",
                isRequired: false,
              ),
              verticalSpace(twentyPixelHeight(context) * .5),
              CustomFormTextfield(
                  hintTextt: "Others",
                  prefixFalse: true,
                  prefixxIcon: Icons.person,
                  controller: _othersController),
              verticalSpace(twentyPixelHeight(context) * 2),
              CustomRedBtn(
                textt: "Find Donors",
                textColor: AppColor.whiteColor,
                fillColor: AppColor.redColor,
                borderClr: Colors.transparent,
                onTap: _submit,
              )
            ],
          ),
        ),
      ),
    );
  }
}
