import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:tasky_app/core/helpers/extentions.dart';
import 'package:tasky_app/core/helpers/vaildator.dart';
import 'package:tasky_app/core/routing/routes.dart';
import 'package:tasky_app/core/theming/styles.dart';
import 'package:tasky_app/core/widgets/custom_material_button.dart';
import 'package:tasky_app/core/widgets/custom_toast.dart';
import 'package:tasky_app/core/widgets/text_form_field_helper.dart';
import 'package:tasky_app/features/auth/data/models/login_args.dart';
import 'package:tasky_app/features/auth/presentation/managers/cubits/auth_cubit/auth_cubit.dart';
import 'package:tasky_app/features/auth/presentation/managers/cubits/auth_cubit/auth_states.dart';
import 'package:tasky_app/features/auth/presentation/widgets/sign_in_with_google_button.dart';
import '../../../../core/theming/colors_manager.dart';
import '../widgets/footer.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key, this.loginArgs});

  final LoginArgs? loginArgs;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _formKey = GlobalKey<FormState>();

  void _clearForm() {
    _emailController.clear();
    _passwordController.clear();
    _formKey = GlobalKey<FormState>();
    setState(() {});
  }

  void _navigateToHome(BuildContext context) =>
      mounted ? context.pushReplacementNamed(Routes.homeView) : null;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is SignInSuccess || state is GoogleSignInSuccess) {
          showCustomToast(
            context: context,
            message: 'Welcome!',
            contentType: ContentType.success,
          );
          _navigateToHome(context);
        } else if (state is SignInFailure) {
          showCustomToast(
            context: context,
            message: state.errorMessage,
            contentType: ContentType.failure,
          );
        } else if (state is GoogleSignInFailure) {
          showCustomToast(
            context: context,
            message: state.errorMessage,
            contentType: ContentType.failure,
          );
        } else if (state is ForgetPasswordSuccess) {
          showCustomToast(
            context: context,
            message: 'an email has been sent to your email address',
            contentType: ContentType.success,
          );
        } else if (state is ForgetPasswordFailure) {
          showCustomToast(
            context: context,
            message: state.errorMessage,
            contentType: ContentType.failure,
          );
        }
      },
      builder: (context, state) => ModalProgressHUD(
        inAsyncCall: state is ForgetPasswordLoading,
        progressIndicator: const CupertinoActivityIndicator(),
        opacity: 0.25,
        child: Scaffold(
          backgroundColor: ColorsManager.white,
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(90.h),
                        Text(
                          'Login',
                          style: TextStylesManager.font32color404147Bold,
                        ),
                        Gap(53.h),
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
                        Gap(26.h),
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
                          onValidate: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Password cannot be empty';
                            }
                            return null;
                          },
                          action: TextInputAction.done,
                        ),
                        Gap(6.h),
                        buildForgetPassword(context),
                        Gap(50.h),
                        CustomMaterialButton(
                          text: 'Login',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthCubit>().signInEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                            }
                          },
                          textStyle: TextStylesManager.font16WhiteBold,
                          maxWidth: true,
                          isLoading: state is SignInLoading,
                        ),
                        Gap(12.h),
                        ContinueWithGoogleButton(
                          on: () => context.read<AuthCubit>().googleSignIn(),
                          label: 'Login with google',
                          isLoading: state is GoogleSignInLoading,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Footer(
            onTap: () async {
              final result = await context.pushNamed(Routes.registerView);
              if (result != null && result is LoginArgs) {
                _emailController.text = result.email;
                _passwordController.text = result.password;
              } else {
                _clearForm();
              }
            },
            firstText: 'Don’t have an account? ',
            secondText: 'Register',
          ),
        ),
      ),
    );
  }

  Align buildForgetPassword(BuildContext context) => Align(
    alignment: Alignment.centerRight,
    child: GestureDetector(
      onTap: () {
        if (_emailController.text.isNotEmpty) {
          context.read<AuthCubit>().forgetPassword(_emailController.text);
        } else {
          showCustomToast(
            context: context,
            message: 'please enter your email',
            contentType: ContentType.failure,
          );
        }
      },
      child: Text(
        'Forget Password?',
        style: TextStylesManager.font12color744EE5Regular,
      ),
    ),
  );
}
