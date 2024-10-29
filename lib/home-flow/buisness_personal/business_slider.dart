import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:mihu/auth_workflow/controllers/login_controller.dart';
import 'package:mihu/constrants/colors/colors.dart';
import 'package:mihu/constrants/download_helper.dart';
import 'package:mihu/home-flow/editprofile/edit_post/edit_post_screen.dart';
import 'package:mihu/home-flow/home/controller/home_slider_controller.dart';
import 'package:mihu/network/models/frame_model.dart';
import 'package:mihu/home-flow/home/controller/mediaitem.dart';
import 'package:mihu/home-flow/home/controller/slidercontroller.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BusinessCombinedCarouselWidget extends StatefulWidget {
  final bool showEditButttom;
  final post;

  const BusinessCombinedCarouselWidget(
      {super.key, required this.showEditButttom, required this.post});

  @override
  _BusinessCombinedCarouselWidgetState createState() =>
      _BusinessCombinedCarouselWidgetState();
}

class _BusinessCombinedCarouselWidgetState
    extends State<BusinessCombinedCarouselWidget> {
  int _current = 0;
  final sliderController = Get.put(SliderController());
  final loginController = Get.put(LoginController());
  double division = 3;
  final homeController = Get.put(HomeSliderController());

  @override
  Widget build(BuildContext context) {
    division = MediaQuery.of(context).devicePixelRatio + 1;

    print("------");
    print(widget.post.itemUrl);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0), // Circular border
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Card(
          // margin: EdgeInsets.all(10),
          elevation: 0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.02,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      Container(
                        // color: Colors.orange,
                        child: Stack(
                          children: [
                            Container(
                              height: 310,
                              // color: Colors.pink,
                              child:homeController.totalBusiness == 0
                                  ? Center(child: Text("No business available"))
                                  : PageView(
                                scrollDirection: Axis.horizontal,
                                onPageChanged: (value) {

                                    _current = value;

                                },
                                children: List.generate(
                                  sliderController.frames.length,
                                  (index) {
                                    List<Layers> layers =
                                        sliderController.frames[index].layers ??
                                            [];
                                    List<Layers> home = layers
                                        .where(
                                          (element) =>
                                              element.x! <= 0 &&
                                              element.y! <= 0,
                                        )
                                        .toList();

                                    return Center(
                                      child: Container(
                                        height: (home.isEmpty
                                                ? 1200
                                                : home.first.height!
                                                    .toDouble()) /
                                            division,
                                        width: (home.isEmpty
                                                ? 1200
                                                : home.first.width!
                                                    .toDouble()) /
                                            division,
                                        child: Stack(
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: widget.post.itemUrl,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                            ),

                                            ...DownloadHelper.getFrameLayers(
                                                division, layers,isBusiness: true),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            // Container(
                            //   margin: EdgeInsets.only(left: 10, top: 10),
                            //   padding: EdgeInsets.all(8.0),
                            //   decoration: BoxDecoration(
                            //     color: Colors.black.withOpacity(0.2),
                            //     borderRadius: BorderRadius.circular(8),
                            //
                            //   ),
                            //   child: Row(
                            //     mainAxisSize: MainAxisSize.min,
                            //     children: [
                            //       Flexible(
                            //         child: Text(
                            //           "${loginController.storage.read('name')}",
                            //           style: TextStyle(
                            //               fontSize: 16.0, color: Colors.white),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // )
                          ],
                        ),
                      ),
                      // SizedBox(height: 0.2.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                            (sliderController.frames.length), (index) {
                          return Container(
                            width: 8,
                            height: 8,
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _current == index
                                  ? Color.fromRGBO(0, 0, 0, 0.9)
                                  : Color.fromRGBO(0, 0, 0, 0.4),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.09,

                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.5.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 24.w,
                            child: CarouselButton(
                              text: "Share",
                              color: Color(0xFF25D366),
                              onPressed: () async {
                                List<Layers> layers = sliderController.frames[_current].layers ?? [];
                                DownloadHelper.shareImage(layers, widget.post['item_url'],isBusiness: true);
                              },
                              icon: Image.asset(
                                'assets/icons/whatsapptwo.png',
                                width: 4.w,
                                height: 3.h,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 28.w,


                            child: CarouselButton(
                              text: "Download  ",

                              color: Color(0xFF1D4687),

                              onPressed: () async {
                                List<Layers> layers = sliderController.frames[_current].layers ?? [];
                                // Implement download logic here
                              },
                              icon: Image.asset(
                                'assets/icons/downloadicon.png',
                                width: 4.w,
                                height: 3.h,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 25.w,

                            child: widget.showEditButttom
                                ? CarouselButton(
                              text: "Edit",
                              color: primarybuttonColor,
                              onPressed: () {
                                Get.to(() => EditprofilePost(
                                  post: widget.post,type:1,
                                  layers:    [],
                                ));                              },
                              icon: Image.asset(
                                'assets/icons/editicon.png',
                                width: 3.w,
                                height: 3.h,
                              ),
                            )
                                : Container(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> _shareMedia() async {
  //   try {
  //     final boundary = _globalKeys[_current].currentContext!.findRenderObject() as RenderRepaintBoundary?;
  //     if (boundary != null) {
  //       final image = await boundary.toImage(pixelRatio: 2.0);
  //       final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //       final pngBytes = byteData!.buffer.asUint8List();
  //
  //       var tempDir = await getTemporaryDirectory();
  //       String savePath = '${tempDir.path}/shared_image.png';
  //       File file = File(savePath);
  //       await file.writeAsBytes(pngBytes);
  //
  //       await Share.shareXFiles([XFile(savePath)], text: 'Check out this image!');
  //     }
  //   } catch (e) {
  //     log('Error sharing image: $e');
  //   }
  // }

  Future<void> _downloadMedia() async {
    final int mediaIndex = _current ~/
        5; // Divide by 5 because each media item corresponds to 5 frames
    // final mediaItem = filteredMediaItems[mediaIndex];
    // if (mediaItem.isImage) {
    //   await _downloadImage(mediaIndex);
    // } else {
    //   await _downloadVideo(mediaItem);
    // }
  }

  // Future<void> _downloadVideo(MediaItem mediaItem) async {
  //   try {
  //     String videoUrl = mediaItem.path; // URL or file path of the video
  //
  //     var tempDir = await getTemporaryDirectory();
  //     String savePath = '${tempDir.path}/downloaded_video.mp4';
  //     await Dio().download(videoUrl, savePath);
  //
  //     final result = await ImageGallerySaver.saveFile(savePath);
  //
  //     if (result != null && result['isSuccess']) {
  //       log('Video saved to gallery successfully.');
  //     } else {
  //       log('Failed to save video to gallery.');
  //     }
  //   } catch (e) {
  //     log('Error downloading video: $e');
  //   }
  // }

  Future<void> _shareMedia() async {
    final int mediaIndex = _current ~/ 5;
    // final mediaItem = filteredMediaItems[mediaIndex];
    // if (mediaItem.isImage) {
    //   await _shareImage(mediaIndex);
    // } else {
    //   await _shareVideo(mediaItem);
    // }
  }

  Future<void> _shareVideo(MediaItem mediaItem) async {
    try {
      String videoUrl = mediaItem.path; // URL or file path of the video

      // await Share.shareXFiles([XFile(videoUrl)], text: 'Check out this video!');
    } catch (e) {
      log('Error sharing video: $e');
    }
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;

  const VideoPlayerWidget({super.key, required this.videoPath});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Container(
            child: Center(child: CircularProgressIndicator()),
          );
  }
}

class CarouselButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;
  final Widget icon;

  const CarouselButton({
    Key? key,
    required this.text,
    required this.color,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.w),
      ),
      icon: icon,
      label: Text(
        text,
        style: TextStyle(fontSize: 10.sp, color: Colors.white),
      ),
      onPressed: onPressed,
    );
  }
}
