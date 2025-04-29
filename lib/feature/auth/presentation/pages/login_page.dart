import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text("login".tr())),
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text("login_sc!".tr())));
            context.go('/home');
          } else if (state is LoginError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: "email".tr())),
              TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: "password".tr()),
                  obscureText: true),
              const SizedBox(height: 20),
              BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state is LoginLoading
                        ? null
                        : () {
                            context.read<LoginCubit>().loginUser(
                                emailController.text, passwordController.text);
                          },
                    child: state is LoginLoading
                        ? const CircularProgressIndicator()
                        : const Text("Login"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
