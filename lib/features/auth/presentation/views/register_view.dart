import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tasky_app/core/helpers/extentions.dart';
import 'package:tasky_app/core/helpers/vaildator.dart';
import 'package:tasky_app/core/theming/styles.dart';
import 'package:tasky_app/core/utils/functions.dart';
import 'package:tasky_app/core/widgets/custom_material_button.dart';
import 'package:tasky_app/core/widgets/custom_toast.dart';
import 'package:tasky_app/core/widgets/text_form_field_helper.dart';
import 'package:tasky_app/features/auth/data/models/login_args.dart';
import 'package:tasky_app/features/auth/presentation/managers/cubits/auth_cubit/auth_cubit.dart';
import 'package:tasky_app/features/auth/presentation/managers/cubits/auth_cubit/auth_states.dart';
import '../../../../core/widgets/awesome_dialog.dart';
import '../widgets/footer.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _LoginViewState();
}

class _LoginViewState extends State<RegisterView> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: BlocConsumer<AuthCubit, AuthStates>(
              listener: (context, state) {
                if (state is SignUpSuccess) {
                  showAwesomeDialog(
                    context: context,
                    title: 'Email verification',
                    description: 'please verify your email',
                    dialogType: DialogType.info,
                    btnOkOnPress: () {
                      context.pop(
                        LoginArgs(
                          email: _emailController.text,
                          password: _passwordController.text,
                        ),
                      );
                    },
                  );
                  showCustomToast(
                    context: context,
                    message: 'Email created',
                    contentType: ContentType.success,
                  );
                } else if (state is SignUpFailure) {
                  showErrorDialog(
                    context: context,
                    errorMessage: state.errorMessage,
                  );
                }
              },
              builder: (context, state) => SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(90.h),
                      Text(
                        'Register',
                        style: TextStylesManager.font32color404147Bold,
                      ),
                      Gap(23.h),
                      Text(
                        'Username',
                        style: TextStylesManager.font16color404147Regular,
                      ),
                      Gap(5.h),
                      TextFormFieldHelper(
                        controller: _usernameController,
                        borderRadius: BorderRadius.all(Radius.circular(10.r)),
                        hint: 'enter username...',
                        keyboardType: TextInputType.name,
                        onValidate: Validator.validateName,
                        action: TextInputAction.next,
                      ),
                      Gap(12.h),
                      Text(
                        'Email',
                        style: TextStylesManager.font16color404147Regular,
                      ),
                      Gap(5.h),
                      TextFormFieldHelper(
                        controller: _emailController,
                        borderRadius: BorderRadius.all(Radius.circular(10.r)),
                        hint: 'enter email...',
                        keyboardType: TextInputType.emailAddress,
                        onValidate: Validator.validateEmail,
                        action: TextInputAction.next,
                      ),
                      Gap(12.h),
                      Text(
                        'Password',
                        style: TextStylesManager.font16color404147Regular,
                      ),
                      Gap(5.h),
                      TextFormFieldHelper(
                        controller: _passwordController,
                        borderRadius: BorderRadius.all(Radius.circular(10.r)),
                        hint: 'Password...',
                        isPassword: true,
                        keyboardType: TextInputType.visiblePassword,
                        onValidate: Validator.validatePassword,
                        action: TextInputAction.next,
                      ),
                      Gap(12.h),
                      Text(
                        'Confirm Password',
                        style: TextStylesManager.font16color404147Regular,
                      ),
                      Gap(5.h),
                      TextFormFieldHelper(
                        controller: _confirmPasswordController,
                        borderRadius: BorderRadius.all(Radius.circular(10.r)),
                        hint: 'Password...',
                        isPassword: true,
                        keyboardType: TextInputType.visiblePassword,
                        onValidate: (value) =>
                            Validator.validateConfirmPassword(
                              value,
                              _passwordController.text,
                            ),
                        action: TextInputAction.done,
                      ),
                      Gap(71.h),
                      CustomMaterialButton(
                        text: 'Register',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().signUpEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text,
                              username: _usernameController.text,
                            );
                          }
                        },
                        isLoading: state is SignUpLoading,
                        textStyle: TextStylesManager.font16WhiteBold,
                        maxWidth: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Footer(
        onTap: () => context.pop(),
        firstText: 'Already have an account? ',
        secondText: 'Login',
      ),
    );
  }
}
