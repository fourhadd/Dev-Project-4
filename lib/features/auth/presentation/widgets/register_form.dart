import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../cubit/register_cubit.dart';
import '../../cubit/register_state.dart';
import 'register_submit_button.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<RegisterCubit>().submit(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listenWhen: (previous, current) => current is RegisterFailure || current is RegisterSuccess,
      listener: (context, state) {
        if (state is RegisterFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          ));
        } else if (state is RegisterSuccess) {
          context.go('/home');
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
                controller: _nameController,
                label: 'Full name',
                prefixIcon: Icons.person_outline_rounded,
                validator: Validators.name),
            SizedBox(height: 16.h),
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
                icon: Icon(_obscure ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                    color: AppColors.onDarkMuted, size: 20.sp),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              controller: _confirmController,
              label: 'Confirm password',
              obscureText: _obscure,
              prefixIcon: Icons.lock_reset_rounded,
              validator: (v) => Validators.confirmPassword(v, _passwordController.text),
            ),
            SizedBox(height: 26.h),
            RegisterSubmitButton(onPressed: () => _submit(context)),
            SizedBox(height: 14.h),
            TextButton(
              onPressed: () => context.go('/login'),
              child: Text.rich(
                TextSpan(
                  text: 'Already have an account? ',
                  style: TextStyle(fontSize: 13.sp, color: AppColors.onDarkMuted),
                  children: [
                    TextSpan(
                      text: 'Log in',
                      style: TextStyle(fontSize: 13.sp, color: AppColors.accent, fontWeight: FontWeight.w700),
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
