// features/auth/presentation/widgets/login_submit_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/main_button.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';

class LoginSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  const LoginSubmitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          current is LoginLoading || current is LoginInitial || current is LoginFailure,
      builder: (context, state) {
        return MainButton(
          label: 'Log in',
          icon: Icons.login_rounded,
          isLoading: state is LoginLoading,
          onPressed: onPressed,
        );
      },
    );
  }
}
