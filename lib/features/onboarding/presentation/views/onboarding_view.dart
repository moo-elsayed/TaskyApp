import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:tasky_app/core/widgets/custom_material_button.dart';
import '../../../../core/theming/styles.dart';
import '../../data/models/slider_model.dart';
import '../widgets/onboarding_indicator.dart';
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
      backgroundColor: Colors.white,
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
            OnboardingIndicator(
              slidesLength: slides.length,
              currentIndex: currentIndex,
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
          text: currentIndex < 2 ? 'Next' : 'Get Started',
          onPressed: () {
            if (currentIndex < 2) {
              pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
        ),
      ),
    );
  }
}
