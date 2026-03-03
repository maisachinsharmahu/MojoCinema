// import 'package:flutter/material.dart';

// class CarouselOptionsz {
//   final double height;
//   final double viewportFraction;
//   final bool autoPlay;
//   final Duration autoPlayInterval;
//   final Duration autoPlayAnimationDuration;
//   final bool enableInfiniteScroll;
//   final bool pauseAutoPlayInFiniteScroll;
//   final bool pauseAutoPlayOnTouch;
//   final Function(int, CarouselPageChangedReason) onPageChanged;

//   CarouselOptionsz({
//     this.height = 200.0,
//     this.viewportFraction = 1.0,
//     this.autoPlay = false,
//     this.autoPlayInterval = const Duration(seconds: 3),
//     this.autoPlayAnimationDuration = const Duration(milliseconds: 800),
//     this.enableInfiniteScroll = true,
//     this.pauseAutoPlayInFiniteScroll = false,
//     this.pauseAutoPlayOnTouch = true,
//     required this.onPageChanged,
//   });
// }

// enum CarouselPageChangedReason { timed, manual }

// class CarouselSliderz extends StatefulWidget {
//   final List<Widget> items;
//   final CarouselOptionsz options;
//   final bool disableGesture;

//   CarouselSliderz({
//     required this.items,
//     required this.options,
//     this.disableGesture = false,
//     Key? key,
//   }) : super(key: key);

//   @override
//   _CarouselSliderzState createState() => _CarouselSliderzState();
// }

// class _CarouselSliderzState extends State<CarouselSliderz> {
//   late PageController _pageController;
//   late int _currentPage;
//   late bool _isAutoPlayActive;

//   @override
//   void initState() {
//     super.initState();
//     _currentPage = 0;
//     _isAutoPlayActive = widget.options.autoPlay;
//     _pageController = PageController(
//       initialPage: _currentPage,
//     );

//     if (_isAutoPlayActive) {
//       _startAutoPlay();
//     }
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   void _startAutoPlay() {
//     if (_isAutoPlayActive) {
//       Future.delayed(widget.options.autoPlayInterval, () {
//         if (_pageController.hasClients) {
//           _nextPage();
//         }
//       });
//     }
//   }

//   void _nextPage() {
//     if (_pageController.hasClients) {
//       _pageController.nextPage(
//         duration: widget.options.autoPlayAnimationDuration,
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   void _prevPage() {
//     if (_pageController.hasClients) {
//       _pageController.previousPage(
//         duration: widget.options.autoPlayAnimationDuration,
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: widget.options.height,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           PageView.builder(
//             controller: _pageController,
//             itemCount: widget.options.enableInfiniteScroll
//                 ? null
//                 : widget.items.length,
//             itemBuilder: (context, index) {
//               final realIndex = index % widget.items.length;
//               return widget.items[realIndex];
//             },
//             onPageChanged: (index) {
//               setState(() {
//                 _currentPage = index;
//               });
//               widget.options.onPageChanged(index, CarouselPageChangedReason.manual);
//             },
//           ),
//           if (!widget.disableGesture)
//             Positioned(
//               left: 20,
//               child: IconButton(
//                 icon: Icon(Icons.arrow_back),
//                 onPressed: _prevPage,
//               ),
//             ),
//           if (!widget.disableGesture)
//             Positioned(
//               right: 20,
//               child: IconButton(
//                 icon: Icon(Icons.arrow_forward),
//                 onPressed: _nextPage,
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
