import 'package:food_client/core/constants/image_constants.dart';

class OnBoardingContent {
  OnBoardingContent({
    required this.title,
    required this.description,
    required this.image,
  });

  final String title;
  final String description;
  final String image;
}

List<OnBoardingContent> contents = [
  OnBoardingContent(
    title: 'Select from Our\n     Best Menu',
    description: 'Pick your food from our menu\n        More than 35 times ',
    image: ImageConstants.screen1,
  ),
  OnBoardingContent(
    title: 'Easy and Online Payment',
    description:
        'You can pay cash on delivery and\n       Card payment is available',
    image: ImageConstants.screen2,
  ),
  OnBoardingContent(
    title: 'Quick Delivery at your Doorstep',
    description: 'Deliver your food at your\n       Doorstep',
    image: ImageConstants.screen3,
  ),
];
