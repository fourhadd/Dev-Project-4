// features/auth/presentation/widgets/login_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';
import 'login_submit_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<LoginCubit>().submit(
        email: _emailController.text, password: _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (previous, current) =>
          current is LoginFailure || current is LoginSuccess,
      listener: (context, state) {
        if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r)),
          ));
        } else if (state is LoginSuccess) {
          context.go('/home');
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
                controller: _emailController,
                label: 'Email',
                prefixIcon: Icons.alternate_email_rounded,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email),
            SizedBox(height: 16.h),
            CustomTextField(
              controller: _passwordController,
              label: 'Password',
              obscureText: _obscure,
              prefixIcon: Icons.lock_outline_rounded,
              validator: Validators.password,
              suffixIcon: IconButton(
                icon: Icon(
                    _obscure
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    color: AppColors.onDarkMuted,
                    size: 20.sp),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            SizedBox(height: 26.h),
            LoginSubmitButton(onPressed: () => _submit(context)),
            SizedBox(height: 14.h),
            TextButton(
              onPressed: () => context.go('/register'),
              child: Text.rich(
                TextSpan(
                  text: "Don't have an account? ",
                  style:
                      TextStyle(fontSize: 13.sp, color: AppColors.onDarkMuted),
                  children: [
                    TextSpan(
                      text: 'Register',
                      style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.accent,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
