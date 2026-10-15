
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../general/config/colors.dart';
import '../../../../general/utils/blank_space.dart';
import '../../../../general/utils/responsive.dart';
import '../../../../models/donor_model.dart';
import '../../../../providers/donor_provider.dart';
import '../../../../providers/profile_provider.dart';
import '../../components/widgets/custom_appbar.dart';
import '../../components/widgets/custom_blood_group_box.dart';
import '../../components/widgets/custom_find_screen_item.dart';
import '../../components/widgets/custom_form_textfield.dart';
import '../../components/widgets/custom_red_btn.dart';
import '../../components/widgets/find_donor_date_picker.dart';


// El donante es siempre el usuario autenticado:
// - si todavia no es donante, el formulario sale con los datos de su perfil y "Complete" lo registra;
// - si ya es donante, sale con sus datos de donante y "Update" los actualiza.
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

  // false mientras se cargan los datos: los selectores necesitan su valor inicial al crearse.
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    // Esperamos a que termine el primer build para poder usar los providers.
    Future.microtask(() => _loadData());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final donorProvider = context.read<DonorProvider>();
    final profileProvider = context.read<ProfileProvider>();

    // Las dos consultas al backend van en paralelo.
    await Future.wait([
      donorProvider.loadMyDonor(),
      if (profileProvider.profile == null) profileProvider.loadProfile(),
    ]);
    if (!mounted) return;

    final donor = donorProvider.myDonor;
    final profile = profileProvider.profile;
    if (donor != null) {
      // Ya es donante: mostramos lo que tiene guardado como donante.
      _nameController.text = donor.name;
      _contactController.text = donor.contactNumber;
      _locationController.text = donor.location;
      _bloodGroup = donor.bloodGroup;
      _lastDonationDate = donor.lastDonationDate;
    } else if (profile != null) {
      // Todavia no es donante: precargamos con su perfil.
      _nameController.text = profile.name;
      _contactController.text = profile.phone ?? "";
      _locationController.text = profile.location ?? "";
      _bloodGroup = profile.bloodGroup ?? _bloodGroup;
    }

    setState(() => _ready = true);

    final error = donorProvider.errorMessage ?? profileProvider.errorMessage;
    if (error != null) _showError(error);
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

    final wasRegistered = provider.isRegistered;
    final donor = DonorModel(
      name: _nameController.text.trim(),
      contactNumber: _contactController.text.trim(),
      bloodGroup: _bloodGroup,
      location: _locationController.text.trim(),
      // La foto se queda como estaba (no usamos image picker).
      photoUrl: provider.myDonor?.photoUrl,
      lastDonationDate: _lastDonationDate!,
    );

    final ok = await provider.saveDonor(donor);
    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(wasRegistered
              ? "Donor info successfully updated!"
              : "Donor successfully registered!"),
        ),
      );
      Navigator.pop(context);
    } else {
      _showError(provider.errorMessage ?? "Something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // El titulo cambia segun si el usuario ya es donante.
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Consumer<DonorProvider>(
          builder: (context, provider, child) => CustomAppBar(
            actionTrue: true,
            titlee: provider.isRegistered ? "Update Donor Info" : "Donor Registration Form",
          ),
        ),
      ),
      body: !_ready
          ? const Center(child: CircularProgressIndicator(color: AppColor.redColor))
          : _form(context),
    );
  }

  Widget _form(BuildContext context) {
    return SingleChildScrollView(
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
            CustomFormTextfield(
              hintTextt: "+18092249304",
              prefixFalse: false,
              controller: _contactController,
              keyboardType: TextInputType.phone,
            ),

            verticalSpace(twentyPixelHeight(context)),
            const CustomFormText(textt: "Blood Group", isRequired: true),
            verticalSpace(twentyPixelHeight(context)),

            Padding(
              padding:  EdgeInsets.only(
                left: twentyPixelWidth(context)*1.5,
                right: twentyPixelWidth(context)*1.5,
              ),
              child: CustomBloodGroupBox(
                initialValue: _bloodGroup,
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
              initialValue: _lastDonationDate,
              onChanged: (date) => _lastDonationDate = date,
            ),
            verticalSpace(twentyPixelHeight(context)*1.5),
            // El boton dice "Update" si ya es donante y "Complete" si se va a registrar.
            Consumer<DonorProvider>(
              builder: (context, provider, child) => CustomRedBtn(
                textt: provider.isLoading
                    ? "Saving..."
                    : provider.isRegistered ? "Update" : "Complete",
                textColor: AppColor.whiteColor,
                fillColor: AppColor.redColor,
                borderClr: Colors.transparent,
                onTap: _submit,
              ),
            ),
            ],
          ),
        ),
      );
  }
}
