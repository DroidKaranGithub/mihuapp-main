import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mihu/network/apiclient.dart/apicilent.dart';
import 'package:mihu/network/models/frame_model.dart';

class HomeFrameScreen extends StatefulWidget {

  @override
  State<HomeFrameScreen> createState() => _HomeFrameScreenState();
}

class _HomeFrameScreenState extends State<HomeFrameScreen> {
  List<FrameModel> frames = [];
  double division = 3;

  @override
  void initState() {
    fetchJsonData();
    super.initState();
  }

  Future fetchJsonData() async {
    try {
      final response = await ApiClient().getFrameById();
      if (response['status']) {
        List data =  response['data'];
        frames = data.map((e) => FrameModel.fromJson(jsonDecode(e['json']))).toList();
      } else {
        Get.snackbar('Error', response['message'],colorText: Colors.white,backgroundColor: Colors.black);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(),colorText: Colors.white,backgroundColor: Colors.black);
    }
  }

  @override
  Widget build(BuildContext context) {
    division = MediaQuery.of(context).devicePixelRatio + 1;
    print(division);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Poster Maker")),
        body: Center(
          child: ListView.separated(
            itemCount: frames.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              List<Layers> layers = frames[index].layers ?? [];

              List<Widget> frameLayers = [];

              for (int i=0; i<layers.length;i++){
                if(layers[i].type == "image"){
                  frameLayers.add(Positioned(
                    top: layers[i].y!.toDouble() / division,
                    left: layers[i].x!.toDouble() / division,
                    child: Image.network("https://mihuapp.com/public${layers[i].src}",fit: BoxFit.cover,height: layers[i].height!.toDouble() / division,width: layers[i].width!.toDouble() / division,),
                  ));
                }
                if(layers[i].type == "text"){
                  frameLayers.add(Positioned(
                    top: layers[i].y!.toDouble() / division,
                    left: layers[i].x!.toDouble() / division,
                    child: Text("${layers[i].text}",style: TextStyle(fontSize: layers[i].size!.toDouble() / (division+1),color: Color(int.parse("${layers[i].color!.replaceAll("0x", "0xff")}"))),
                    ),
                  ),
                  );
                }
              }
              List<Layers> home = layers.where((element) => element.x! <= 0 && element.y! <= 0,).toList();

              return Column(
                children: [
                  Center(
                    child: Container(
                      height: (home.isEmpty ? 1200 : home.first.height!.toDouble()) / division,
                      width: (home.isEmpty ? 1200 : home.first.width!.toDouble()) / division,
                      child: Stack(
                        children: frameLayers,
                      ),
                    ),
                  ),
                  ElevatedButton(onPressed: () async {
                    List<Widget> frameLayers2 = [];

                    for (int i=0; i<layers.length;i++){
                      if(layers[i].type == "image"){
                        frameLayers2.add(Positioned(
                          top: layers[i].y!.toDouble(),
                          left: layers[i].x!.toDouble(),
                          child: Image.network("https://mihuapp.com/public${layers[i].src}",fit: BoxFit.cover,height: layers[i].height!.toDouble(),width: layers[i].width!.toDouble(),),
                        ));
                      }
                      if(layers[i].type == "text"){
                        frameLayers2.add(Positioned(
                          top: layers[i].y!.toDouble(),
                          left: layers[i].x!.toDouble(),
                          child: Text("${layers[i].text}",style: TextStyle(fontSize: layers[i].size!.toDouble(),),
                          ),
                        ),
                        );
                      }
                    }
                    List<Layers> home = layers.where((element) => element.x! <= 0 && element.y! <= 0,).toList();

                    // var capturedImage = await ScreenshotController().captureFromLongWidget(Container(
                    //   height: (home.isEmpty ? 1200 : home.first.height!.toDouble()),
                    //   width: (home.isEmpty ? 1200 : home.first.width!.toDouble()),
                    //   child: Stack(
                    //     children: frameLayers2,
                    //   ),
                    // ),delay: Duration(seconds: 2));
                    // final result = await ImageGallerySaver.saveImage(capturedImage,
                    //   quality: 100,
                    //   name: "${DateTime.now()}",
                    // );

                  }, child: Text("Download")),
                ],
              );
            },),
        ),
      ),
    );
  }
}