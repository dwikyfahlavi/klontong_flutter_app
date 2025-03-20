import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong_flutter_app/core/utils/route_constants.dart';
import 'package:klontong_flutter_app/logic/auth/auth_cubit.dart';
import 'package:klontong_flutter_app/logic/auth/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Setup animation
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 20).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
      if (state is Authenticated) {
        // Navigate to the authenticated screen
        Future.microtask(() => Navigator.pushNamedAndRemoveUntil(
              context,
              RouteConstants.productList,
              (route) => false, // This removes all previous routes
            ));
      } else if (state is Unauthenticated) {
        // Navigate to the login screen
        Future.microtask(() => Navigator.pushNamedAndRemoveUntil(
              context,
              RouteConstants.login,
              (route) => false, // This removes all previous routes
            ));
      }
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Container(
                    margin: EdgeInsets.only(bottom: _animation.value),
                    child: Image.asset('assets/images/logo.jpeg', width: 120),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text(
                "Loading...",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      );
    });
  }
}
