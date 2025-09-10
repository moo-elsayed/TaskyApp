import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tasky_app/core/helpers/extentions.dart';
import 'package:tasky_app/core/routing/routes.dart';
import 'package:tasky_app/core/widgets/custom_material_button.dart';
import '../../../../core/helpers/shared_preferences_manager.dart';
import '../../../../core/theming/colors_manager.dart';
import '../../../../core/theming/styles.dart';
import '../../data/models/slider_model.dart';
import '../widgets/onboarding_page_view.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  int currentIndex = 0;
  late final PageController pageController;
  final List<SliderModel> slides = SliderModel.slides;
  late final length = slides.length;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Gap(50.h),
            OnboardingPageView(
              pageController: pageController,
              slides: slides,
              onPageChanged: (index) {
                currentIndex = index;
                setState(() {});
              },
            ),
            SmoothPageIndicator(
              controller: pageController,
              count: length,
              axisDirection: Axis.horizontal,
              effect: SwapEffect(
                spacing: 8.w,
                radius: 4.r,
                dotWidth: 26.w,
                dotHeight: 4.h,
                paintStyle: PaintingStyle.fill,
                dotColor: ColorsManager.colorAFAFAF,
                activeDotColor: ColorsManager.color744EE5,
              ),
            ),
            Gap(50.h),
            Text(
              slides[currentIndex].title,
              textAlign: TextAlign.center,
              style: TextStylesManager.font32color404147Bold,
            ),
            Gap(42.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 38.w),
              child: Text(
                slides[currentIndex].description,
                textAlign: TextAlign.center,
                style: TextStylesManager.font16color817D8DRegular,
              ),
            ),
            Gap(217.h),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(right: 8.w, bottom: 32.h),
        child: CustomMaterialButton(
          text: currentIndex < length - 1 ? 'Next' : 'Get Started',
          onPressed: () {
            if (currentIndex < length - 1) {
              pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            } else {
              context.pushReplacementNamed(Routes.loginView);
              SharedPreferencesManager.setFirstTime(false);
            }
          },
        ),
      ),
    );
  }
}
