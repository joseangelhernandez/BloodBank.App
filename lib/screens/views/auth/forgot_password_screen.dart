import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blood_bank/constants/validators.dart';
import 'package:blood_bank/screens/views/components/widgets/main_button.dart';
import 'package:provider/provider.dart';
import 'package:blood_bank/providers/auth_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const pageRoute = "/forgot-password-screen";
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async{
    if(_formKey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });

      try{
        final auth = context.read<AuthProvider>();
        final ok = await auth.forgotPassword(emailController.text.trim());
        if (!ok) throw auth.errorMessage ?? "Something went wrong";

        if(!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Link sent! Check your email"),
          backgroundColor: Colors.green,
        ),
          );
        Navigator.pop(context);

      }catch(error){
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString(),
        ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        );
      } finally{
        if(mounted){
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text('Forgot Password', style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                ),
                ),
                SizedBox(height: 60,),
                Text("Please enter your email address. You will receive a link to reset your password",
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  validator: emailvalidator.call,
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                    suffix: InkWell(
                      onTap: () {
                        setState(() {
                          //limpiar el controlador
                          emailController.clear();
                        });
                      },
                      child: Icon(CupertinoIcons.multiply),
                    )
                  ),
                ),
                SizedBox(height: 30,),
                MainButton(
                    label: "SEND",
                    action: () {
                      // El backend le pide a Firebase que envie el correo con el link de reset.
                      _handleResetPassword();
                    },
                    isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
