import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/main_button.dart';
import '../../cubit/register_cubit.dart';
import '../../cubit/register_state.dart';

class RegisterSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  const RegisterSubmitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (previous, current) =>
          current is RegisterLoading || current is RegisterInitial || current is RegisterFailure,
      builder: (context, state) {
        return MainButton(
          label: 'Register',
          icon: Icons.arrow_forward_rounded,
          isLoading: state is RegisterLoading,
          onPressed: onPressed,
        );
      },
    );
  }
}
