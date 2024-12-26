import 'package:flutter/material.dart';
import 'package:pcs_14/components/my_button.dart';
import 'package:pcs_14/components/my_text_field.dart';
import 'package:pcs_14/services/auth_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign in user
  void signIn() async {
    // get the auth service
    final authService =  Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailandPassword(
        emailController.text, 
        passwordController.text,
      );
    } catch (e) {
      // Check if the widget is still mounted before accessing context
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF67BEEA),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // logo
                Icon(
                  Icons.message, 
                  size: 100,
                  color: Colors.grey[800],
                ),

                const SizedBox(height: 50),
            
                // welcome back message
                const Text(
                  "С возвращением, мы скучали!",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),
            
                // email textfield
                MyTextField(
                  controller: emailController, 
                  hintText: 'Почта', 
                  obscureText: false,
                ),

                const SizedBox(height: 10),
            
                // password textfield
                MyTextField(
                  controller: passwordController, 
                  hintText: 'Пароль', 
                  obscureText: true,
                ),

                const SizedBox(height: 25),
            
                // sign in button
                MyButton(onTap: signIn, text: "Войти"),

                const SizedBox(height: 50),
            
                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Впервые здесь?'),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Зарегистрироваться',
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
