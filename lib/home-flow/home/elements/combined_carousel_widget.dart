import 'dart:developer';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mihu/constrants/colors/colors.dart';
import 'package:mihu/constrants/download_helper.dart';
import 'package:mihu/home-flow/editprofile/edit_post/edit_post_screen.dart';
import 'package:mihu/home-flow/home/controller/home_slider_controller.dart';
import 'package:mihu/network/models/frame_model.dart';
import 'package:mihu/home-flow/home/controller/mediaitem.dart';
import 'package:mihu/home-flow/home/controller/slidercontroller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';


class CombinedCarouselWidget extends StatefulWidget {
  final bool showEditButttom;
  final post;

  const CombinedCarouselWidget(
      {super.key, required this.showEditButttom, required this.post});

  @override
  _CombinedCarouselWidgetState createState() => _CombinedCarouselWidgetState();
}

class _CombinedCarouselWidgetState extends State<CombinedCarouselWidget> {
  int _current = 0;
  final sliderController = Get.put(SliderController());
  final homeController = Get.put(HomeSliderController());
  double division = 3;

  @override
  Widget build(BuildContext context) {
    division = MediaQuery.of(context).devicePixelRatio + 1;

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Card(
              elevation: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height*0.42,
                                width: 500,
                                child: PageView(
                                  scrollDirection: Axis.horizontal,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  onPageChanged: (value) {

                                      setState(() {
                                        _current = value;
                                      });
                                      log('Layers for frame $_current: ${sliderController.frames[_current].layers}');


                                  },
                                  children: List.generate(
                                      sliderController.frames.length, (index) {
                                    if (index >= sliderController.frames.length) {
                                      return SizedBox(); // Return an empty widget to avoid out of range
                                    }
                                    List<Layers> layers =
                                        sliderController.frames[index].layers ??
                                            [];
                                    List<Layers> home = layers
                                        .where((element) =>
                                    element.x! <= 0 && element.y! <= 0)
                                        .toList();

                                    final String itemUrl =
                                    widget.post['item_url'];
                                    final bool isVideo =
                                        itemUrl.endsWith('.mp4') ||
                                            itemUrl.endsWith('.avi') ||
                                            itemUrl.endsWith('.mov');

                                    return Center(
                                      child: Container(
                                        height: (home.isEmpty
                                            ? 1200
                                            : home.first.height!.toDouble()) /
                                            division,
                                        width: (home.isEmpty
                                            ? 1200
                                            : home.first.width!.toDouble()) /
                                            division,
                                        child: Stack(
                                          children: [
                                            isVideo
                                                ? Center(
                                                child: Container(
                                                    height: double.infinity,
                                                    width: double.infinity,
                                                    child: VideoPlayerWidget(
                                                        videoPath: itemUrl)))
                                                : CachedNetworkImage(
                                                  imageUrl:  widget.post['item_url'],
                                                  fit: BoxFit.fill,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                                  errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                                                ),
                                            ...DownloadHelper.getFrameLayers(
                                                division, layers),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(sliderController.frames.length,
                                    (index) {
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
                      Container(
                        height: MediaQuery.of(context).size.height * 0.09,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.5.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 25.w,
                                child: CarouselButton(
                                  text: "Share",
                                  color: Color(0xFF25D366),
                                  onPressed: () async {
                                    List<Layers> layers =
                                        sliderController.frames[_current].layers ??
                                            [];
                                    DownloadHelper.shareImage(
                                        layers, widget.post['item_url']);
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
                                  text: "Download",
                                  color: Color(0xFF1D4687),
                                  onPressed: () async {
                                    final String itemUrl = widget.post['item_url'];

                                    // Check if the URL is for a video
                                    if (itemUrl.endsWith('.mp4') ||
                                        itemUrl.endsWith('.avi') ||
                                        itemUrl.endsWith('.mov')) {
                                      await _downloadVideo(itemUrl,context); // Call the download video method
                                    } else {
                                      List<Layers> layers = sliderController.frames[_current].layers ?? [];
                                      final String itemUrl = widget.post['item_url'];
                                      await DownloadHelper.downloadPhoto(layers,itemUrl); // Call the updated download image method
                                    }
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
                                    List<Layers> layers = sliderController
                                        .frames[_current].layers ??
                                        [];
                                    Get.to(() => EditprofilePost(
                                      post: widget.post,type:0,
                                      layers: layers,
                                    ));
                                  },
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
                    ],
                  ),
                ),
              ),
            ),

            // homeController.
          ],
        ));
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.green, // Set color to green for success
      ),
    );
  }



  Future<void> _downloadVideo(String videoUrl,BuildContext context) async {
    try {
      // Get temporary directory
      var tempDir = await getTemporaryDirectory();
      String savePath = '${tempDir.path}/downloaded_video.mp4'; // Specify the file name

      // Download the video
      await Dio().download(videoUrl, savePath);

      // Save to gallery
      final result = await ImageGallerySaver.saveFile(savePath);

      if (result != null && result['isSuccess']) {
        log('Video saved to gallery successfully.');
        _showSnackBar('Video saved to gallery successfully!',context);
      } else {
        log('Failed to save video to gallery.');
        _showSnackBar('Failed to save video to gallery.',context);
      }
    } catch (e) {
      log('Error downloading video: $e');
      _showSnackBar('Error downloading video: $e', context);
    }
  }
  void _showSnackBar(String message,BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
void _showSnackBar(String message,BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
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
_saveLocalImage() async {
  // RenderRepaintBoundary boundary =
  // _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  // ui.Image image = await boundary.toImage();
  // ByteData? byteData =
  // await (image.toByteData(format: ui.ImageByteFormat.png));
  // if (byteData != null) {
  //   final result =
  //   await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
  //   print(result);
  // }
}

_saveNetworkImage() async {
  var response = await Dio().get(
      "https://ss0.baidu.com/94o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=a62e824376d98d1069d40a31113eb807/838ba61ea8d3fd1fc9c7b6853a4e251f94ca5f46.jpg",
      options: Options(responseType: ResponseType.bytes));
  final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.data),
      quality: 60,
      name: "hello");
  print(result);
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

    // Check if the video path is a URL or an asset
    if (widget.videoPath.startsWith('http://') ||
        widget.videoPath.startsWith('https://')) {
      _controller = VideoPlayerController.network(widget.videoPath);
    } else {
      _controller = VideoPlayerController.asset(widget.videoPath);
    }

    _controller.initialize().then((_) {

      _controller.play();
    }).catchError((error) {
      // Handle any error during initialization
      print('Error initializing video: $error');
   // Update the UI in case of an error
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
        : Center(child: CircularProgressIndicator());
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
  Future<void> _downloadVideo(MediaItem mediaItem,context) async {
    try {
      String videoUrl = mediaItem.path; // URL or file path of the video

      var tempDir = await getTemporaryDirectory();
      String savePath = '${tempDir.path}/downloaded_video.mp4';
      await Dio().download(videoUrl, savePath);

      final result = await ImageGallerySaver.saveFile(savePath);

      if (result != null && result['isSuccess']) {
        log('Video saved to gallery successfully.');
        _showSnackBar('Video saved to gallery successfully!',context);
      } else {
        log('Failed to save video to gallery.');
        _showSnackBar('Failed to save video to gallery.',context);
      }
    } catch (e) {
      log('Error downloading video: $e');
      _showSnackBar('Error downloading video: $e',context);
    }
  }

  void _showSnackBar(String message,BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

}
