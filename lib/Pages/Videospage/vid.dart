import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:mojocinema/api/apikey.dart';

class VideoPage extends StatefulWidget {
  final int movieId;
  final String backdropPath;
  final String mediaType;
  const VideoPage({
    super.key,
    required this.movieId,
    required this.backdropPath,
    this.mediaType = 'movie',
  });

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  List<Map<String, dynamic>> movieTrailerList = [];
  YoutubePlayerController? _controller;
  bool isLoading = true;
  String? currentVideoKey;

  Future<void> fetchMovieTrailers() async {
    try {
      var url =
          "https://api.themoviedb.org/3/${widget.mediaType}/${widget.movieId}/videos?api_key=$apikey";

      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var tempdata = jsonDecode(response.body);
        var resultdata = tempdata["results"];
        movieTrailerList.clear();
        for (var trailer in resultdata) {
          if (trailer["site"] == "YouTube") {
            movieTrailerList.add({
              'name': trailer["name"],
              'key': trailer["key"],
              'type': trailer["type"],
            });
          }
        }

        if (movieTrailerList.isNotEmpty) {
          currentVideoKey = movieTrailerList[0]['key'];
          _initializeController(currentVideoKey!);
        }
      }
    } catch (e) {
      debugPrint("Error fetching trailers: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _initializeController(String videoId) {
    if (_controller != null) {
      _controller!.dispose();
    }
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
  }

  void _changeVideo(String videoKey) {
    if (currentVideoKey == videoKey) return;
    setState(() {
      currentVideoKey = videoKey;
    });
    _controller?.load(videoKey);
  }

  @override
  void initState() {
    super.initState();
    fetchMovieTrailers();
  }

  @override
  void deactivate() {
    _controller?.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller ?? YoutubePlayerController(initialVideoId: ''),
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        onReady: () {
          debugPrint('Player is ready.');
        },
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Trailers & Extras",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Apercu',
              ),
            ),
          ),
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.red))
              : movieTrailerList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 200.h,
                            width: 300.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              image: DecorationImage(
                                image: NetworkImage(
                                    "https://image.tmdb.org/t/p/w500/${widget.backdropPath}"),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.6),
                                    BlendMode.darken),
                              ),
                            ),
                            child: const Icon(Icons.videocam_off_rounded,
                                color: Colors.white24, size: 60),
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            "No Trailers Available",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Apercu',
                            ),
                          ),
                          SizedBox(height: 8.h),
                          const Text(
                            "We couldn't find any trailers locally.",
                            style: TextStyle(color: Colors.white54),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        player,
                        Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.all(16.w),
                            itemCount: movieTrailerList.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 12.h),
                            itemBuilder: (context, index) {
                              var trailer = movieTrailerList[index];
                              bool isSelected =
                                  currentVideoKey == trailer['key'];
                              return GestureDetector(
                                onTap: () => _changeVideo(trailer['key']),
                                child: Container(
                                  padding: EdgeInsets.all(12.w),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.red.withOpacity(0.1)
                                        : Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.red
                                          : Colors.white10,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            child: Image.network(
                                              "https://img.youtube.com/vi/${trailer['key']}/0.jpg",
                                              width: 120.w,
                                              height: 70.h,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          if (!isSelected)
                                            const Icon(
                                                Icons.play_circle_outline,
                                                color: Colors.white,
                                                size: 30),
                                          if (isSelected)
                                            const Icon(
                                                Icons.pause_circle_outline,
                                                color: Colors.red,
                                                size: 30),
                                        ],
                                      ),
                                      SizedBox(width: 16.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              trailer['name'],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.sp,
                                                fontWeight: isSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              trailer['type'],
                                              style: TextStyle(
                                                color: Colors.white54,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
        );
      },
    );
  }
}
