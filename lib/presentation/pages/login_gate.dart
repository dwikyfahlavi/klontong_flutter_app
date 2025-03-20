import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong_flutter_app/core/utils/route_constants.dart';
import 'package:klontong_flutter_app/logic/auth/auth_cubit.dart';
import 'package:klontong_flutter_app/logic/auth/auth_state.dart';
import 'package:klontong_flutter_app/presentation/widgets/custom_button.dart';
import 'package:klontong_flutter_app/presentation/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Login"),
      //   centerTitle: true,
      //   backgroundColor: Colors.teal,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/logo.jpeg',
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 30),
            CustomTextField(
              hintText: 'Email',
              controller: _emailController,
              icon: Icons.email,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hintText: 'Password',
              controller: _passwordController,
              icon: Icons.lock,
              obscureText: true,
            ),
            const SizedBox(height: 30),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is Authenticated) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RouteConstants.productList,
                    (route) => false, // This removes all previous routes
                  );
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                } else if (state is Unauthenticated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Login failed")),
                  );
                } else if (state is AuthLogout) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Logout Success")),
                  );
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const CircularProgressIndicator();
                }
                return SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Login',
                    onPressed: () {
                      context.read<AuthCubit>().login(
                            _emailController.text,
                            _passwordController.text,
                          );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RouteConstants.register);
                  },
                  child: const Text(
                    "Register",
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
