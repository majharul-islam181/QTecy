import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:qtechy/feature/auth/presentation/cubit/login_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _imageLoaded = true;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final loginCubit = context.read<LoginCubit>();
    final token = await loginCubit.storageService.getToken();

    if (!mounted) return;

    if (token != null) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageLoaded
                ? Image.asset(
                    'assets/icons/dev-icon.png',
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      if (kDebugMode) {
                        print(" ERROR: Unable to load dev-icon.png");
                      }
                      setState(() {
                        _imageLoaded = false;
                      });
                      return const Icon(Icons.error,
                          size: 50, color: Colors.red);
                    },
                  )
                : const Text("Image not found",
                    style: TextStyle(color: Colors.red, fontSize: 16)),
            const SizedBox(height: 20),
            Text(
              "title".tr(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
