import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'general/config/colors.dart';
import 'general/config/config.dart';
import 'providers/auth_provider.dart';
import 'providers/blood_request_provider.dart';
import 'providers/donor_provider.dart';
import 'providers/profile_provider.dart';
import 'screens/views/all_request_details/screens/request_details_screen.dart';
import 'screens/views/all_requests/screens/all_request_screen.dart';
import 'screens/views/auth/forgot_password_screen.dart';
import 'screens/views/auth/login_screen.dart';
import 'screens/views/auth/register_screen.dart';
import 'screens/views/donor_registration/screens/donor_registration_screen.dart';
import 'screens/views/find_donor/screens/find_donor_screen.dart';
import 'screens/views/home/screens/home_screen.dart';
import 'screens/views/onboarding/onboarding_screen.dart';
import 'screens/views/onboarding/splash_screen.dart';
import 'screens/views/profile/screens/profile_screen.dart';
import 'services/api_client.dart';

// Llave para poder navegar desde fuera de una pantalla (ej. cuando el token vence).
final navigatorKey = GlobalKey<NavigatorState>();

// acepta el certificado autofirmado del backend .NET (dotnet dev-certs).
// Nunca se activa en release, porque ahi si hay que validar el certificado.
class _DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => host == '10.0.2.2' || host == 'localhost';
  }
}

void main() {
  if (kDebugMode) HttpOverrides.global = _DevHttpOverrides();

  // Si el backend responde 401 (el token de Firebase vencio, dura 1 hora),
  // mandamos al usuario al login y borramos las pantallas anteriores
  ApiClient.onUnauthorized = () {
    navigatorKey.currentState
        ?.pushNamedAndRemoveUntil(LoginScreen.pageRoute, (route) => false);
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Registramos los 4 providers para que todas las pantallas los usen.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BloodRequestProvider()),
        ChangeNotifierProvider(create: (_) => DonorProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: AppConfig.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Poppins',
          primaryColor: AppColor.redColor,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColor.redColor),
        ),
        home: const SplashScreen(),
        routes: {
          SplashScreen.pageRoute: (context) => const SplashScreen(),
          OnboardingScreen.pageRoute: (context) => OnboardingScreen(),
          LoginScreen.pageRoute: (context) => const LoginScreen(),
          RegisterScreen.pageRoute: (context) => const RegisterScreen(),
          ForgotPasswordScreen.pageRoute: (context) =>
              const ForgotPasswordScreen(),
          HomeScreen.pageRoute: (context) => const HomeScreen(),
          ProfileScreen.pageRoute: (context) => const ProfileScreen(),
          AllRequestScreen.pageRoute: (context) => const AllRequestScreen(),
          RequestDetailsScreen.pageRoute: (context) =>
              const RequestDetailsScreen(),
          DonorRegistrationForm.pageRoute: (context) =>
              const DonorRegistrationForm(),
          FindDonorScreen.pageRoute: (context) => const FindDonorScreen(),
        },
      ),
    );
  }
}
