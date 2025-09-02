class SliderModel {
  final String image;
  final String title;
  final String description;

  SliderModel({
    required this.image,
    required this.title,
    required this.description,
  });

  static final List<SliderModel> slides = [
    SliderModel(
      image: 'assets/images/onboarding-image1.png',
      title: 'Manage your tasks',
      description:
          'You can easily manage all of your daily tasks in DoMe for free',
    ),
    SliderModel(
      image: 'assets/images/onboarding-image2.png',
      title: 'Create daily routine',
      description:
          'In Tasky  you can create your personalized routine to stay productive',
    ),
    SliderModel(
      image: 'assets/images/onboarding-image3.png',
      title: 'Organize your tasks',
      description:
          'You can organize your daily tasks by adding your tasks into separate categories',
    ),
  ];
}
