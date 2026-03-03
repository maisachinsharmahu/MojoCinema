// import 'dart:convert';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:mojocinema/Pages/Home/dlt/animatedcard.dart';
// import 'package:mojocinema/Pages/Home/Widgets/cardwidget.dart';
// import 'package:mojocinema/api/apiurls.dart';
// import 'package:mojocinema/helpers/color.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   List<Map<String, dynamic>> trendinglist = [];
//   late PageController _pageController;

//   @override
//   void initState() {
//     super.initState();
//     _pageController =
//         PageController(initialPage: 0, keepPage: false, viewportFraction: 0.7);
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//   }

//   Future<void> trendinglisthome() async {
//     // print(trendinglist);
//     var trendingweekresponse = await http.get(Uri.parse(trendingweekurl));
//     if (trendingweekresponse.statusCode == 200) {
//       var tempdata = jsonDecode(trendingweekresponse.body);
//       var trendingweekjson = tempdata["results"];

//       for (int i = 0; i < trendingweekjson.length; i++) {
//         trendinglist.add({
//           'id': trendingweekjson[i]["id"],
//           'backdrop_path': trendingweekjson[i]["backdrop_path"],
//           'poster_path': trendingweekjson[i]["poster_path"],
//           'name': trendingweekjson[i]["original_name"],
//           'vote_average': trendingweekjson[i]["vote_average"],
//           'media_type': trendingweekjson[i]["media_type"],
//           'index': i,
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: myColors.primaryColor,
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//               centerTitle: true,
//               pinned: true,
//               expandedHeight: Screensize.screenHeight(context) * 0.4,
//               flexibleSpace: FlexibleSpaceBar(
//                 collapseMode: CollapseMode.parallax,
//                 background: FutureBuilder(
//                     future: trendinglisthome(),
//                     builder: (context, snapshot) {
//                       // print(snapshot.connectionState);
//                       if (snapshot.connectionState == ConnectionState.done) {
//                         // print("HI");
//                         return CarouselSlider(
//                           options: CarouselOptions(
//                             // viewportFraction: 1,
//                             autoPlay: true,
//                             autoPlayInterval: Duration(seconds: 2),
//                             height: Screensize.screenHeight(context),
//                           ),
//                           items: trendinglist.map((i) {
//                             // print(
//                             //     "https://image.tmdb.org/t/p/w500/${i['poster_image']}");
//                             // return Builder(
//                             //   builder: (BuildContext context) {
//                             // return GestureDetector(
//                             //   onTap: () {},
//                             //   child: Container(
//                             //     width: Screensize.screenWidth(context),
//                             //     child: CachedNetworkImage(
//                             //         fit: BoxFit.fill,
//                             //         imageUrl:
//                             //             "https://image.tmdb.org/t/p/w500/${i['poster_path']}"),
//                             //   ),
//                             // );
//                             return Container(
//                               child: PageView.builder(
//                                 controller: PageController(
//                                   initialPage: 0,
//                                   viewportFraction:
//                                       0.7, // Same as your main controller
//                                 ),
//                                 itemBuilder: (context, index) {
//                                   return AnimatedMovieCardWidget(
//                                       index: index,
//                                       pageController: _pageController,
//                                       movieId: i['id'],
//                                       posterPath:
//                                           "https://image.tmdb.org/t/p/w500/${i['poster_path']}");
//                                 },
//                               ),
//                             );
//                             //   },
//                             // );
//                           }).toList(),
//                         );
//                       } else {
//                         return Center(
//                           child: CircularProgressIndicator(
//                             color: Colors.amber,
//                           ),
//                         );
//                       }
//                     }),
//               ),
//               backgroundColor: myColors.primaryColor,
//               title: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Trending 🔥",
//                     style: TextStyle(
//                       // fontSize: 20,
//                       color: Colors.white.withOpacity(0.8),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 15,
//                   ),
//                 ],
//               ))
//         ],
//       ),
//     );
//   }
// }


// // import 'dart:convert';

// // import 'package:cached_network_image/cached_network_image.dart';
// // import 'package:carousel_slider/carousel_slider.dart';
// // import 'package:mojocinema/Pages/Home/animatedcard.dart';
// // import 'package:mojocinema/Pages/Home/cardwidget.dart';
// // import 'package:mojocinema/api/apiurls.dart';
// // import 'package:mojocinema/helpers/color.dart';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;

// // class HomePage extends StatefulWidget {
// //   const HomePage({super.key});

// //   @override
// //   State<HomePage> createState() => _HomePageState();
// // }

// // class _HomePageState extends State<HomePage> {
// //   List<Map<String, dynamic>> trendinglist = [];
// //   late PageController _pageController;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _pageController =
// //         PageController(initialPage: 0, keepPage: false, viewportFraction: 0.7);
// //   }

// //   @override
// //   void dispose() {
// //     _pageController.dispose();
// //   }

// //   Future<void> trendinglisthome() async {
// //     // print(trendinglist);
// //     var trendingweekresponse = await http.get(Uri.parse(trendingweekurl));
// //     if (trendingweekresponse.statusCode == 200) {
// //       var tempdata = jsonDecode(trendingweekresponse.body);
// //       var trendingweekjson = tempdata["results"];

// //       for (int i = 0; i < trendingweekjson.length; i++) {
// //         trendinglist.add({
// //           'id': trendingweekjson[i]["id"],
// //           'backdrop_path': trendingweekjson[i]["backdrop_path"],
// //           'poster_path': trendingweekjson[i]["poster_path"],
// //           'name': trendingweekjson[i]["original_name"],
// //           'vote_average': trendingweekjson[i]["vote_average"],
// //           'media_type': trendingweekjson[i]["media_type"],
// //           'index': i,
// //         });
// //       }
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: myColors.primaryColor,
// //       body: CustomScrollView(
// //         slivers: [
// //           SliverAppBar(
// //               centerTitle: true,
// //               pinned: true,
// //               expandedHeight: Screensize.screenHeight(context) * 0.4,
// //               flexibleSpace: FlexibleSpaceBar(
// //                 collapseMode: CollapseMode.parallax,
// //                 background: FutureBuilder(
// //                     future: trendinglisthome(),
// //                     builder: (context, snapshot) {
// //                       // print(snapshot.connectionState);
// //                       if (snapshot.connectionState == ConnectionState.done) {
// //                         // print("HI");
// //                         return CarouselSlider(
// //                           options: CarouselOptions(
// //                             // viewportFraction: 1,
// //                             autoPlay: true,
// //                             autoPlayInterval: Duration(seconds: 2),
// //                             height: Screensize.screenHeight(context),
// //                           ),
// //                           items: trendinglist.map((i) {
// //                             return Container(
// //                               child: PageView.builder(
// //                                 controller: _pageController,
// //                                 itemCount: trendinglist.length,
// //                                 pageSnapping: true,
// //                                 onPageChanged: (int newIndex) {
// //                                   print("Page changed to: $newIndex");
// //                                 },
// //                                 itemBuilder: (context, index) {
// //                                   return MovieCardWidget(
// //                                     movieId: i['id'],
// //                                     posterPath:
// //                                         "https://image.tmdb.org/t/p/w500/${i['poster_path']}",
// //                                   );
// //                                 },
// //                               ),
// //                             );

// //                             //   },
// //                             // );
// //                           }).toList(),
// //                         );
// //                       } else {
// //                         return Center(
// //                           child: CircularProgressIndicator(
// //                             color: Colors.amber,
// //                           ),
// //                         );
// //                       }
// //                     }),
// //               ),
// //               backgroundColor: myColors.primaryColor,
// //               title: Row(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   Text(
// //                     "Trending 🔥",
// //                     style: TextStyle(
// //                       // fontSize: 20,
// //                       color: Colors.white.withOpacity(0.8),
// //                     ),
// //                   ),
// //                   SizedBox(
// //                     width: 15,
// //                   ),
// //                 ],
// //               ))
// //         ],
// //       ),
// //     );
// //   }
// // }
