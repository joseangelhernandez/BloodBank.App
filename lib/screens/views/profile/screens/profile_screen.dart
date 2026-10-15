import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../general/config/colors.dart';
import '../../../../general/utils/blank_space.dart';
import '../../../../general/utils/responsive.dart';
import '../../../../models/user_model.dart';
import '../../../../providers/profile_provider.dart';
import '../../all_request_details/widgets/request_details_item.dart';
import '../../components/widgets/custom_appbar.dart';
import '../../components/widgets/custom_blood_group_box.dart';
import '../../components/widgets/custom_form_textfield.dart';
import '../../components/widgets/custom_gender_box.dart';
import '../../components/widgets/custom_red_btn.dart';

class ProfileScreen extends StatefulWidget {
  static const pageRoute = "/profile";

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // false = solo lectura; true = campos habilitados para editar.
  bool _isEditing = false;

  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _gender; // "male" o "female" (como lo devuelve CustomGenderBox)
  String? _bloodGroup;

  @override
  void initState() {
    super.initState();
    // Esperamos a que termine el primer build para poder usar el provider.
    Future.microtask(() => _loadProfile());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final provider = context.read<ProfileProvider>();
    await provider.loadProfile();

    if (!mounted) return;
    if (provider.errorMessage != null) {
      _showMessage(provider.errorMessage!, Colors.red);
    }
  }

  void _startEditing(UserModel profile) {
    _nameController.text = profile.name;
    _locationController.text = profile.location ?? "";
    _phoneController.text = profile.phone ?? "";
    _gender = profile.gender?.toLowerCase() ?? "male";
    _bloodGroup = profile.bloodGroup ?? "A+";
    setState(() => _isEditing = true);
  }

  Future<void> _save(UserModel profile) async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showMessage("Name is required", Colors.red);
      return;
    }

    final provider = context.read<ProfileProvider>();
    final ok = await provider.updateProfile(
      name: name,
      location: _emptyToNull(_locationController.text),
      phone: _emptyToNull(_phoneController.text),
      gender: _gender == null
          ? null
          : _gender![0].toUpperCase() + _gender!.substring(1),
      bloodGroup: _bloodGroup,
      photoUrl: profile.photoUrl,
    );

    if (!mounted) return;
    if (ok) {
      setState(() => _isEditing = false);
      _showMessage("Profile updated", Colors.green);
    } else {
      _showMessage(provider.errorMessage ?? "Something went wrong", Colors.red);
    }
  }

  String? _emptyToNull(String text) => text.trim().isEmpty ? null : text.trim();

  void _showMessage(String text, Color color) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(backgroundColor: color, content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        titlee: "Profile",
        actionTrue: true,
        profileFalse: true,
      ),
      // El AppBar no depende del perfil; solo el cuerpo se reconstruye.
      body: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          final profile = provider.profile;
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: twentyPixelWidth(context),
              vertical: twentyPixelHeight(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  // Con scroll porque en modo edicion los campos no caben en pantallas pequenas.
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: twentyPixelWidth(context) * 6.5,
                                height: twentyPixelWidth(context) * 6.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(200),
                                  border: Border.all(
                                    color: AppColor.redColor,
                                    width: 1,
                                  ),
                                ),
                              ),
                              Container(
                                width: twentyPixelWidth(context) * 6,
                                height: twentyPixelWidth(context) * 6,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(200),
                                ),
                                child: Image.asset("assets/images/profile.png"),
                              ),
                            ],
                          ),
                        ),
                        verticalSpace(twentyPixelHeight(context) * 2),
                        if (_isEditing)
                          ..._editFields(context)
                        else
                          ..._readOnlyFields(profile),
                      ],
                    ),
                  ),
                ),
                verticalSpace(twentyPixelHeight(context) * .5),
                ..._buttons(context, profile, provider.isSaving),
                verticalSpace(twentyPixelHeight(context) * .5),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _readOnlyFields(UserModel? profile) {
    // Si un dato no existe mostramos "-".
    return [
      RequestDetailsItem(titlee: "Name", textt: profile?.name ?? "-"),
      RequestDetailsItem(titlee: "Location", textt: profile?.location ?? "-"),
      RequestDetailsItem(titlee: "Gender", textt: profile?.gender ?? "-"),
      RequestDetailsItem(
        titlee: "Blood Group",
        textt: profile?.bloodGroup ?? "-",
      ),
      RequestDetailsItem(titlee: "Mobile Number", textt: profile?.phone ?? "-"),
    ];
  }

  List<Widget> _editFields(BuildContext context) {
    final gap = verticalSpace(twentyPixelHeight(context) * .75);
    return [
      CustomAuthText(textt: "Name"),
      CustomFormTextfield(
        hintTextt: "Name",
        prefixxIcon: Icons.person,
        controller: _nameController,
      ),
      gap,
      const _FieldLabel("Location"),
      CustomFormTextfield(
        hintTextt: "Location",
        prefixxIcon: Icons.location_on,
        controller: _locationController,
      ),
      gap,
      const _FieldLabel("Mobile Number"),
      CustomFormTextfield(
        hintTextt: "Mobile Number",
        prefixxIcon: Icons.phone,
        controller: _phoneController,
        keyboardType: TextInputType.phone,
      ),
      gap,
      const _FieldLabel("Gender"),
      CustomGenderBox(
        initialValue: _gender,
        onChanged: (value) => _gender = value,
      ),
      gap,
      const _FieldLabel("Blood Group"),
      CustomBloodGroupBox(
        initialValue: _bloodGroup,
        onChanged: (value) => _bloodGroup = value,
      ),
    ];
  }

  List<Widget> _buttons(
    BuildContext context,
    UserModel? profile,
    bool isSaving,
  ) {
    if (!_isEditing) {
      return [
        CustomRedBtn(
          textt: "Edit Profile",
          textColor: Colors.white,
          fillColor: AppColor.redColor,
          borderClr: Colors.transparent,
          // Sin perfil cargado no hay nada que editar.
          onTap: profile == null ? null : () => _startEditing(profile),
        ),
      ];
    }
    return [
      CustomRedBtn(
        textt: isSaving ? "Saving..." : "Save",
        textColor: Colors.white,
        fillColor: AppColor.redColor,
        borderClr: Colors.transparent,
        onTap: isSaving ? null : () => _save(profile!),
      ),
      verticalSpace(twentyPixelHeight(context) * .5),
      CustomRedBtn(
        textt: "Cancel",
        textColor: AppColor.redColor,
        fillColor: Colors.white,
        // Al cancelar se descartan los cambios: los campos se vuelven a llenar al editar.
        onTap: isSaving ? null : () => setState(() => _isEditing = false),
      ),
    ];
  }
}

// Titulo gris pequeno encima de cada campo (mismo estilo que RequestDetailsItem).
class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: twentyPixelHeight(context) * .25),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF7A7A7A),
          fontSize: 14,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w300,
        ),
        textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),
      ),
    );
  }
}
