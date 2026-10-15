
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/auth_provider.dart';
import '../../../../providers/blood_request_provider.dart';
import '../../../../providers/donor_provider.dart';
import '../../../../providers/profile_provider.dart';
import '../../auth/login_screen.dart';

import '../../../../general/config/colors.dart';
import '../../../../general/utils/blank_space.dart';
import '../../../../general/utils/responsive.dart';
import '../../all_requests/screens/all_request_screen.dart';
import '../../donor_registration/screens/donor_registration_screen.dart';
import '../../find_donor/screens/find_donor_screen.dart';
import '../../profile/screens/profile_screen.dart';
import 'custom_drawer_item.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColor.redColor.withOpacity(.6),
      child: Padding(
        padding: EdgeInsets.only(
          left: twentyPixelWidth(context),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            verticalSpace(twentyPixelHeight(context) * 1),
            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: const Icon(Icons.close,color: AppColor.whiteColor,)),
            verticalSpace(twentyPixelHeight(context) * 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.whiteColor),
                    borderRadius: BorderRadius.circular(200),
                  ),
                  child: Center(
                    child: Image.asset("assets/images/profile.png"),
                  ),
                ),
                horizontalSpace(twentyPixelWidth(context) * 1),
                // Nombre del usuario logueado (del perfil cargado o, si aun no hay, del login).
                Consumer2<ProfileProvider, AuthProvider>(
                  builder: (context, profileProvider, authProvider, child) {
                    final user = profileProvider.profile ?? authProvider.currentUser;
                    return Text(
                      user?.name ?? "",
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: "Poppins"),
                    );
                  },
                )
              ],
            ),
            verticalSpace(twentyPixelHeight(context)*3),
            const CustomDrawerItem(
              onTapp:DonorRegistrationForm.pageRoute,
              suffixIcon: Icons.app_registration_outlined,
              textt: "Donor Registration",
            ),

            const CustomDrawerItem(
              onTapp:FindDonorScreen.pageRoute,
              suffixIcon: Icons.person_outline,
              textt: "Find Donors",
            ),

            const CustomDrawerItem(
              onTapp: AllRequestScreen.pageRoute,
              suffixIcon: Icons.bloodtype,
              textt: "Blood Requests",
            ),

            const CustomDrawerItem(
              onTapp: ProfileScreen.pageRoute,
              suffixIcon: Icons.person,
              textt: "Profile",
            ),

            TextButton(
              onPressed: () => _logout(context),
              child: CustomDrawerItem(
                onTapp:'',
                onTap: () => _logout(context),
                suffixIcon: Icons.logout,
                textt: "Logout"
              ),
            ),

            const Expanded(child: SizedBox()),
            Padding(
              padding:  EdgeInsets.only(
                left: twentyPixelWidth(context)*.5,
                right: twentyPixelWidth(context)*1.5
              ),
              child: const Divider(color: AppColor.whiteColor,),
            ),
            SizedBox(height: twentyPixelHeight(context)*.5,),
            const Center(
              child: Text("Version 1.0.0",style: TextStyle(
                color: Colors.white
              ),),
            ),
            SizedBox(height: twentyPixelHeight(context)*3,)
            
          ],
        ),
      ),
    );
  }

  // Cerramos sesion y vamos al login borrando todas las pantallas anteriores.
  Future<void> _logout(BuildContext context) async {
    final navigator = Navigator.of(context);
    // Limpiamos los datos del usuario anterior en los otros providers.
    context.read<ProfileProvider>().clear();
    context.read<BloodRequestProvider>().clear();
    context.read<DonorProvider>().clear();
    await context.read<AuthProvider>().logout();
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }
}
