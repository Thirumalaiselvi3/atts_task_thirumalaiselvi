import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'color.dart';

class CarouselSliderWidget extends StatefulWidget {
  final List<String> imageUrls;
  final Color backgroundColor; // Background color for transparent images

  const CarouselSliderWidget({
    super.key,
    required this.imageUrls,
    this.backgroundColor = Colors.white, // Default background color
  });

  @override
  _CarouselSliderWidgetState createState() => _CarouselSliderWidgetState();
}

class _CarouselSliderWidgetState extends State<CarouselSliderWidget> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Full-Width Image Carousel
        CarouselSlider.builder(
          itemCount: widget.imageUrls.length,
          options: CarouselOptions(
            height: 220,
            autoPlay: true,
            autoPlayCurve: Curves.easeInOut,
            enlargeCenterPage: false, // Disable center zoom effect
            viewportFraction: 1, // Full width
            onPageChanged: (index, reason) {
              setState(() {
                activeIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            return buildImage(widget.imageUrls[index]);
          },
        ),

        // Dot Indicator
        const SizedBox(height: 12),
        buildIndicator(),
      ],
    );
  }

  // Image with Background Color
  Widget buildImage(String imagePath) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [appButton1Color, appButton2Color], // Replace with your desired colors
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        // color: widget.backgroundColor, // Background color for transparent images
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20), // Rounded corners
        child: Image.asset(
          imagePath,
          fit: BoxFit.fill, // Ensure transparency is respected
          width: double.infinity,
        ),
      ),
    );
  }

  // Dot Indicator
  Widget buildIndicator() {
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: widget.imageUrls.length,
      effect: const ExpandingDotsEffect(
        activeDotColor: appButton2Color,
        dotHeight: 8,
        dotWidth: 8,
      ),
    );
  }
}
