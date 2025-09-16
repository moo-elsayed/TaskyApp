import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tasky_app/core/helpers/extentions.dart';
import 'package:tasky_app/core/routing/routes.dart';
import 'package:tasky_app/core/utils/functions.dart';
import 'package:tasky_app/core/widgets/confirmation_dialog.dart';
import 'package:tasky_app/features/home/presentation/managers/cubits/logout_cubit/logout_cubit.dart';
import 'package:tasky_app/features/home/presentation/managers/cubits/logout_cubit/logout_states.dart';
import '../../../../core/theming/styles.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogoutCubit(),
      child: Builder(
        builder: (builderContext) => BlocListener<LogoutCubit, LogoutStates>(
          listener: (context, state) {
            if (state is LogoutSuccess) {
              context.pushNamedAndRemoveUntil(
                Routes.loginView,
                predicate: (_) => false,
              );
            } else if (state is LogoutFailure) {
              showErrorDialog(context: context, errorMessage: 'Logout failed');
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/logo-image.png',
                width: 78.w,
                height: 28.h,
              ),
              GestureDetector(
                onTap: () => _showConfirmationDialog(builderContext),
                child: Row(
                  spacing: 10.w,
                  children: [
                    SvgPicture.asset('assets/icons/logout-icon.svg'),
                    Text(
                      'Log out',
                      style: TextStylesManager.font16colorFF4949Regular,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (_) => ConfirmationDialog(
        delete: false,
        fullText: 'Are you sure you want to log out?',
        onTap: () {
          context.read<LogoutCubit>().logout();
        },
        textOkButton: 'Logout',
      ),
    );
  }
}
