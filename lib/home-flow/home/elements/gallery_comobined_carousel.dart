import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mihu/home-flow/buisness_personal/business_slider.dart';
import 'package:mihu/network/apiclient.dart/apicilent.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart'as http;

import '../../../constrants/colors/colors.dart';


import 'package:flutter/services.dart';


class GalleryComobinedCarousel extends StatefulWidget {
  const GalleryComobinedCarousel({super.key});

  @override
  State<GalleryComobinedCarousel> createState() => _GalleryComobinedCarouselState();
}

class _GalleryComobinedCarouselState extends State<GalleryComobinedCarousel> {
  int _current = 0;
  List<String> mediaPaths = []; // List to hold multiple media paths
  late List<Widget> framesList;
  List<GlobalKey> _globalKeys = List.generate(5, (index) => GlobalKey());

  @override
  void initState() {
    super.initState();
    _updateFrames();
  }

  Future<void> _pickMedia(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.image),
              title: Text('Pick Image'),
              onTap: () async {
                Navigator.pop(context);
                final List<XFile>? images = await _picker.pickMultiImage();
                if (images != null) {
                  bool allUploadsSuccessful = true; // Track upload success

                  for (var image in images) {
                    bool uploadSuccess = await _uploadMedia(image.path); // Wait for upload
                    if (!uploadSuccess) {
                      allUploadsSuccessful = false; // If any upload fails
                    }
                  }

                  setState(() {
                    mediaPaths.addAll(images.map((image) => image.path));
                    _updateFrames();
                  });

                  if (allUploadsSuccessful) {
                    Fluttertoast.showToast(msg: "All uploads successful!"); // Show success message only once
                  }
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.videocam),
              title: Text('Pick Video'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
                if (video != null) {
                  bool uploadSuccess = await _uploadMedia(video.path); // Upload video immediately

                  setState(() {
                    mediaPaths.add(video.path);
                    _updateFrames();
                  });

                  if (uploadSuccess) {
                    Fluttertoast.showToast(msg: "Upload successful!"); // Show success message only once
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

// Modify the upload method to return a boolean indicating success
  Future<bool> _uploadMedia(String mediaPath) async {
    var headers = {
      'Authorization': 'Bearer ${ApiClient().token}',
    };

    final url = Uri.parse('https://mihuapp.com/api/gallery');

    try {
      var request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('images[]', mediaPath));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var stringData = await response.stream.bytesToString();
        print("Raw Response: $stringData");
        return true; // Upload successful
      } else {
        print('Error: ${response.reasonPhrase}');
        Fluttertoast.showToast(msg: "Upload failed: ${response.reasonPhrase}"); // Show error message
        return false; // Upload failed
      }
    } catch (e, s) {
      print('Error: $e');
      print('Stack Trace: $s');
      Fluttertoast.showToast(msg: "An error occurred while uploading."); // Show error message
      return false; // Upload failed
    }
  }
  // Upload method

  void _updateFrames() {
    String defaultImagePath = 'assets/images/defaultImage.jpg';
    framesList = mediaPaths.isEmpty
        ? [
      FrameOne(mediaPath: defaultImagePath, key: _globalKeys[0]),
      FrameTwo(mediaPath: defaultImagePath, key: _globalKeys[1]),
      FrameThree(mediaPath: defaultImagePath, key: _globalKeys[2]),
      FrameFour(mediaPath: defaultImagePath, key: _globalKeys[3]),
      FrameFive(mediaPath: defaultImagePath, key: _globalKeys[4]),
    ]
        : mediaPaths.map((path) {
      return FrameOne(mediaPath: path, key: _globalKeys[0]); // Replace with the appropriate frame
    }).toList();
  }

  void _resetSelection() {
    setState(() {
      mediaPaths.clear(); // Clear the list of selected media
      _updateFrames(); // Update the frames list to reflect the default image
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  Container(
                    child: Stack(
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 37.5.h,
                            enlargeCenterPage: true,
                            enableInfiniteScroll: true,
                            autoPlay: false,
                            viewportFraction: 1.0,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            },
                          ),
                          items: framesList,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(framesList.length, (index) {
                      return Container(
                        width: 8,
                        height: 8,
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index
                              ? Color.fromRGBO(0, 0, 0, 0.9)
                              : Color.fromRGBO(0, 0, 0, 0.4),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 0.5.h),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      child: CarouselButton(
                        text: "Share",
                        color: Color(0xFF25D366),
                        onPressed: () async {
                          // Share logic, if needed
                        },
                        icon: Image.asset(
                          'assets/icons/whatsapptwo.png',
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: .5.w),
                      child: CarouselButton(
                        text: "Download",
                        color: Color(0xFF1D4687),
                        onPressed: () async {
                          // Implement download functionality
                        },
                        icon: Image.asset(
                          'assets/icons/downloadicon.png',
                          width: 15,
                          height: 15,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      child: mediaPaths.isEmpty
                          ? CarouselButton(
                        text: "Upload",
                        color: primarybuttonColor,
                        onPressed: () => _pickMedia(context),
                        icon: Image.asset(
                          'assets/icons/upload2.png',
                          width: 15,
                          height: 15,
                        ),
                      )
                          : CarouselButton(
                        text: "Cancel",
                        color: primarybuttonColor,
                        onPressed: () => _resetSelection(),
                        icon: Image.asset(
                          'assets/icons/cancel2.png',
                          width: 15,
                          height: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// Video player widget, carousel button, and frame classes remain unchanged

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;

  const VideoPlayerWidget({super.key, required this.videoPath});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = true; // Track whether the video is currently playing

  @override
  void initState() {
    super.initState();

    // Use File if the videoPath is a file path, otherwise use asset
    _controller = VideoPlayerController.file(File(widget.videoPath));

    _controller.initialize().then((_) {
      setState(() {});
      _controller.play();
      _isPlaying = true;
      _controller.setLooping(false); // Video should not loop
    });

    _controller.addListener(() {
      // Pause video when it ends
      if (_controller.value.position == _controller.value.duration) {
        _controller.pause();
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlayPause, // Pause or play video on tap
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
}

class FrameOne extends StatelessWidget {
  final String mediaPath;

  FrameOne({super.key, required this.mediaPath});

  @override
  Widget build(BuildContext context) {
    bool isAsset = !mediaPath.startsWith('/');
    return RepaintBoundary(
      child: Stack(
        children: [
          if (mediaPath.endsWith('.jpg') ||
              mediaPath.endsWith('.png') ||
              mediaPath.endsWith('.jpeg'))
            SizedBox(
              height: 50.h,
              child: isAsset
                  ? Image.asset(
                      mediaPath,
                      fit: BoxFit.fill,
                      width: 90.w,
                    )
                  : Image.file(
                      File(mediaPath),
                      fit: BoxFit.fill,
                      width: 90.w,
                    ),
            )
          else if (mediaPath.endsWith('.mp4') || mediaPath.endsWith('.mov'))
            VideoPlayerWidget(videoPath: mediaPath),
          Positioned(
            child: SizedBox(
              height: 50.h,
              child: Image.asset(
                'assets/images/frame/background.png',
                fit: BoxFit.fill,
                width: 90.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FrameTwo extends StatelessWidget {
  final String mediaPath;

  const FrameTwo({super.key, required this.mediaPath});

  @override
  Widget build(BuildContext context) {
    bool isAsset = !mediaPath.startsWith('/');
    return RepaintBoundary(
      child: Stack(
        children: [
          if (mediaPath.endsWith('.jpg') ||
              mediaPath.endsWith('.png') ||
              mediaPath.endsWith('.jpeg'))
            SizedBox(
              height: 50.h,
              child: isAsset
                  ? Image.asset(
                      mediaPath,
                      fit: BoxFit.fill,
                      width: 90.w,
                    )
                  : Image.file(
                      File(mediaPath),
                      fit: BoxFit.fill,
                      width: 90.w,
                    ),
            )
          else if (mediaPath.endsWith('.mp4') || mediaPath.endsWith('.mov'))
            VideoPlayerWidget(videoPath: mediaPath),
          Positioned(
            child: SizedBox(
              height: 50.h,
              child: Image.asset(
                'assets/images/frame/background2.png',
                fit: BoxFit.fill,
                width: 90.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FrameThree extends StatelessWidget {
  final String mediaPath;

  const FrameThree({super.key, required this.mediaPath});

  @override
  Widget build(BuildContext context) {
    bool isAsset = !mediaPath.startsWith('/');
    return RepaintBoundary(
      child: Stack(
        children: [
          if (mediaPath.endsWith('.jpg') ||
              mediaPath.endsWith('.png') ||
              mediaPath.endsWith('.jpeg'))
            SizedBox(
              height: 50.h,
              child: isAsset
                  ? Image.asset(
                      mediaPath,
                      fit: BoxFit.fill,
                      width: 90.w,
                    )
                  : Image.file(
                      File(mediaPath),
                      fit: BoxFit.fill,
                      width: 90.w,
                    ),
            )
          else if (mediaPath.endsWith('.mp4') || mediaPath.endsWith('.mov'))
            VideoPlayerWidget(videoPath: mediaPath),
          Positioned(
            child: SizedBox(
              height: 50.h,
              child: Image.asset(
                'assets/images/frame/background3.png',
                fit: BoxFit.fill,
                width: 90.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FrameFour extends StatelessWidget {
  final String mediaPath;

  const FrameFour({super.key, required this.mediaPath});

  @override
  Widget build(BuildContext context) {
    bool isAsset = !mediaPath.startsWith('/');
    return RepaintBoundary(
      child: Stack(
        children: [
          if (mediaPath.endsWith('.jpg') ||
              mediaPath.endsWith('.png') ||
              mediaPath.endsWith('.jpeg'))
            SizedBox(
              height: 50.h,
              child: isAsset
                  ? Image.asset(
                      mediaPath,
                      fit: BoxFit.fill,
                      width: 90.w,
                    )
                  : Image.file(
                      File(mediaPath),
                      fit: BoxFit.fill,
                      width: 90.w,
                    ),
            )
          else if (mediaPath.endsWith('.mp4') || mediaPath.endsWith('.mov'))
            VideoPlayerWidget(videoPath: mediaPath),
          Positioned(
            child: SizedBox(
              height: 50.h,
              child: Image.asset(
                'assets/images/frame/background4.png',
                fit: BoxFit.fill,
                width: 90.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FrameFive extends StatelessWidget {
  final String mediaPath;

  const FrameFive({super.key, required this.mediaPath});

  @override
  Widget build(BuildContext context) {
    bool isAsset = !mediaPath.startsWith('/');
    return RepaintBoundary(
      child: Stack(
        children: [
          if (mediaPath.endsWith('.jpg') ||
              mediaPath.endsWith('.png') ||
              mediaPath.endsWith('.jpeg'))
            SizedBox(
              height: 50.h,
              child: isAsset
                  ? Image.asset(
                      mediaPath,
                      fit: BoxFit.fill,
                      width: 90.w,
                    )
                  : Image.file(
                      File(mediaPath),
                      fit: BoxFit.fill,
                      width: 90.w,
                    ),
            )
          else if (mediaPath.endsWith('.mp4') || mediaPath.endsWith('.mov'))
            VideoPlayerWidget(videoPath: mediaPath),
          Positioned(
            child: SizedBox(
              height: 50.h,
              child: Image.asset(
                'assets/images/frame/background5.png',
                fit: BoxFit.fill,
                width: 90.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
