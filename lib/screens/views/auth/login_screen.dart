import 'package:flutter/material.dart';
import 'package:blood_bank/constants/validators.dart';
import 'package:blood_bank/screens/views/auth/forgot_password_screen.dart';
import 'package:blood_bank/screens/views/auth/register_screen.dart';
import 'package:blood_bank/screens/views/components/widgets/main_button.dart';
import 'package:blood_bank/screens/views/home/screens/home_screen.dart';

import 'package:provider/provider.dart';
import 'package:blood_bank/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  static const pageRoute = "/login-screen";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _showPassword = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    // 1. Quitar el foco del teclado globalmente
    FocusManager.instance.primaryFocus?.unfocus();

    // 2. Dar tiempo a que la animación de ocultar el teclado finalice
    await Future.delayed(const Duration(milliseconds: 100));

    if (!mounted) return;

    // 3. Validar formulario
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // 4. Intentar autenticación
      final auth = context.read<AuthProvider>();
      final ok = await auth.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      final response = ok ? "Success" : auth.errorMessage ?? "Something went wrong";

      if (!mounted) return;

      // 5. Si fue exitoso, navegamos a HomeScreen y limpiamos el stack para que "atrás" no vuelva al login.
      // Si ocurre un error, mostramos el mensaje y quitamos el indicador de carga.
      if (response == "Success") {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      } else {
        setState(() => _isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(response),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome Back!",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: emailvalidator.call,
                    decoration: InputDecoration(
                      labelText: "Enter your Email",
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _showPassword,
                    validator: passwordValidator.call,
                    decoration: InputDecoration(
                      labelText: "Enter your Password",
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility_off
                              : Icons.remove_red_eye,
                        ),
                        onPressed: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Forgot Your Password?",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  MainButton(
                    label: "LOGIN",
                    action: _login,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 10),
                  const Text("OR"),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't Have an Account?"),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Register Here",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                            fontSize: 18,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}