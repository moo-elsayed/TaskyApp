import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky_app/core/helpers/shared_preferences_manager.dart';
import 'package:tasky_app/core/theming/colors_manager.dart';
import 'package:tasky_app/features/auth/presentation/views/login_view.dart';
import 'package:tasky_app/features/home/presentation/views/home_view.dart';
import 'package:tasky_app/features/onboarding/presentation/views/onboarding_view.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen> {
  @override
  void initState() {
    super.initState();
    navigate();
  }

  void navigate() async {
    bool firstTime = await getFirstTime();
    Future.delayed(const Duration(seconds: 1, milliseconds: 400), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => _getView(firstTime),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  Future<bool> getFirstTime() async =>
      await SharedPreferencesManager.getFirstTime();

  Widget _getView(bool firstTime) {
    if (firstTime) {
      return const OnboardingView();
    }
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      return const HomeView();
    } else {
      return const LoginView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.color5F33E1,
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInLeft(
              duration: const Duration(milliseconds: 500),
              child: Image.asset(
                'assets/images/task-logo.png',
                width: 98.w,
                height: 50.h,
              ),
            ),
            BounceInDown(
              delay: const Duration(milliseconds: 500),
              child: Image.asset('assets/images/y-logo.png', width: 24.w),
            ),
          ],
        ),
      ),
    );
  }
}
