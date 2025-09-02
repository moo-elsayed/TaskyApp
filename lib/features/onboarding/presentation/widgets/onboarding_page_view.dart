import 'package:flutter/material.dart';
import '../../data/models/slider_model.dart';

class OnboardingPageView extends StatefulWidget {
  const OnboardingPageView({
    super.key,
    required this.onPageChanged,
    required this.slides,
    required this.pageController,
  });

  final Function(int index) onPageChanged;
  final List<SliderModel> slides;
  final PageController pageController;

  @override
  State<OnboardingPageView> createState() => _OnboardingPageViewState();
}

class _OnboardingPageViewState extends State<OnboardingPageView> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView.builder(
        controller: widget.pageController,
        scrollDirection: Axis.horizontal,
        onPageChanged: (value) {
          currentIndex = value;
          widget.onPageChanged(currentIndex);
        },
        itemCount: widget.slides.length,
        itemBuilder: (context, index) =>
            Image.asset(widget.slides[index].image),
      ),
    );
  }
}
