// import 'package:mojocinema/Pages/Home/Widgets/cardwidget.dart';
// import 'package:mojocinema/helpers/color.dart';
// import 'package:flutter/material.dart';

// class AnimatedMovieCardWidget extends StatelessWidget {
//   final int index;
//   final int movieId;
//   final String posterPath;
//   final PageController pageController;

//   const AnimatedMovieCardWidget(
//       {super.key,
//       required this.index,
//       required this.movieId,
//       required this.posterPath,
//       required this.pageController});

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: pageController,
//       builder: (context, child) {
//         double value = 1; // Default value

//         if (pageController.position.haveDimensions) {
//           double? currentPage = pageController.page; // Get current page
//           value = (currentPage ?? index.toDouble()) -
//               index; // Handle null with fallback

//           return Align(
//             alignment: Alignment.topCenter,
//             child: Container(
//               height: Curves.easeIn.transform(value) *
//                   Screensize.screenHeight(context) *
//                   0.35,
//               width: 230,
//               child: child,
//             ),
//           );
//         } else {
//           return Align(
//             alignment: Alignment.topCenter,
//             child: Container(
//               height:
//                   Curves.easeIn.transform(index == 0 ? value : value * 0.5) *
//                       Screensize.screenHeight(context) *
//                       0.35,
//               width: 230,
//               child: child,
//             ),
//           );
//         }
//       },
//       child: MovieCardWidget(
//         movieId: movieId,
//         posterPath: posterPath,
//       ),
//     );
//   }
// }
