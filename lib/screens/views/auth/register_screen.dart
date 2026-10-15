
import 'package:flutter/material.dart';
import 'package:blood_bank/constants/validators.dart';
import 'package:provider/provider.dart';
import 'package:blood_bank/providers/auth_provider.dart';

import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const pageRoute = "/register-screen";
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  //crear una variable para mostrar un spinning
  bool _isLoading = false;

  //metodo para registrar al usuario
  Future<void> _register() async{
    //1.-validar el formulario
    if(_formKey.currentState!.validate()){
      setState(() {
        _isLoading = true; //para poder mostrar el spinning
      });

      //2.-Ejecutar el registro
      final auth = context.read<AuthProvider>();
      final ok = await auth.register(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text.trim()
      );
      final response = ok ? "Success" : auth.errorMessage ?? "Something went wrong";

      //3.-Vamos a asegurarnos de que si el usuario cierra
      //la pantalla, la aplicacion no de error
      if(!mounted) return;

      setState(() {
        _isLoading = false; //detengo el spinning
      });

      //4.-Manejar la respuesta
      if(response == "Success"){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Account successfully created!")),
        );

        //navegamos al login (reemplazamos para no volver al registro con "atras")
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));

      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text(response)),
        );
      }

    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Create Your Account!',
                        style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD32F2F), // Rojo vibrante/médico
                          letterSpacing: 1.0,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        controller: _nameController,
                        validator: nameValidator.call,
                        decoration: InputDecoration(
                            labelText: "Enter your name",
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                )
                            )
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _emailController,
                        validator: emailvalidator.call,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: "Enter your email",
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                )
                            )
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        validator: passwordValidator.call,
                        obscureText: _showPassword,
                        decoration: InputDecoration(
                          labelText: "Enter your password",
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: TextButton(
                              onPressed: (){
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                              child: Icon(_showPassword
                                  ? Icons.remove_red_eye
                                  : Icons.visibility_off)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                              )
                          ),

                        ),
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: _confirmPasswordController,
                        // Ademas de las reglas normales, debe ser igual a la primera contrasena.
                        validator: (value) => confirmPasswordValidator(value, _passwordController.text),
                        obscureText: _showConfirmPassword,
                        decoration: InputDecoration(
                          labelText: "Confirm your password",
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: TextButton(
                              onPressed: (){
                                setState(() {
                                  _showConfirmPassword = !_showConfirmPassword;
                                });
                              },
                              child: Icon(_showConfirmPassword
                                  ? Icons.remove_red_eye
                                  : Icons.visibility_off)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                              )
                          ),

                        ),
                      ),

                      SizedBox(height: 50,),
                      ElevatedButton(
                        onPressed: (){
                          //llamar al metodo que ejecute el registro
                          _register();
                        },
                        child: _isLoading
                            ? CircularProgressIndicator()
                            : Text("REGISTER", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),),
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromHeight(60),
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            )
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text("OR"),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already Have An Account?"),
                          SizedBox(width: 10,),
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                            },
                            child: Text("Login Here", style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(context).primaryColor,
                            ),),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
      ),
    );
  }
}