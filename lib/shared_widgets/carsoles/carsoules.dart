import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ReusableCarousel extends StatefulWidget {
  final List<String> imgList;

  const ReusableCarousel({required this.imgList});

  @override
  _ReusableCarouselState createState() => _ReusableCarouselState();
}

class _ReusableCarouselState extends State<ReusableCarousel> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 30.h,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 2),
            enlargeCenterPage: true,
            aspectRatio: 2.0,
            onPageChanged: (index, reason) {
              setState(() {
                activeIndex = index;
              });
            },
          ),
          items: widget.imgList
              .map((item) => Container(
                    child: Center(
                        child: Image.asset(
                      item,
                      fit: BoxFit.cover,
                      width: 90.w,
                    )),
                  ))
              .toList(),
        ),
        AnimatedSmoothIndicator(
          activeIndex: activeIndex,
          count: widget.imgList.length,
          effect: ExpandingDotsEffect(
            dotHeight: 1.0.h,
            dotWidth: 1.0.h,
            activeDotColor: Colors.black,
            dotColor: Colors.grey,
          ),
        ),
      ],
    );
  }
}
