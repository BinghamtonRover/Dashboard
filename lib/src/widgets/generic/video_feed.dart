import "dart:async";  // lets us delay the code
import "dart:io";  // read the file
import "dart:typed_data";  // store the bytes
import "dart:ui";  // decode the image
import 'package:flutter/services.dart';
import "package:path/path.dart" show dirname;
import 'dart:io' show Platform;

import "package:flutter/material.dart" hide Image;

class VideoFeed extends StatefulWidget {
  @override
  State createState() => VideoFeedState();
}

class VideoFeedState extends State<VideoFeed> {
  late Timer timer;
  Image? image;
  int count = 1;
  int stats = 0;

  @override
  void initState() { 
    //timer = Timer(const Duration(milliseconds: 100), updateImage); // does not seem to be doing anything
    timer = Timer(const Duration(milliseconds: 100), () => {});
    updateImage();
    //Timer(const Duration(seconds: 1), () => Timer(const Duration(seconds: 10), () { print(stats); }));
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<Uint8List> getBytes() async => (await rootBundle.load('output/$count.jpg')).buffer.asUint8List();

  Future<Image> loadImage(Uint8List bytes) async {
    final buffer = await ImmutableBuffer.fromUint8List(bytes);
    final descriptor = await ImageDescriptor.encoded(buffer);
    final codec = await descriptor.instantiateCodec();
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  void replaceImage(Image newImage) {
    final Image? oldImage = image;
    if(!mounted) return;
    setState(() => image = newImage);
    oldImage?.dispose();
  }

  void updateState() {
    stats++;
    count++;
    if (count > 4) count = 1;
    Timer.run(updateImage);
  }

  // right now, to my understanding, updateState and updateImage are essentially 
  // calling each other as quickly as possible, so it seems like this is the fastest
  // possible frame rate right now

  Future<void> updateImage() async {
    final Uint8List bytes = await getBytes();
    final Image newImage = await loadImage(bytes);
    replaceImage(newImage);
    updateState();
  }

  @override
  Widget build(_) => Scaffold(
    appBar: AppBar(),
    body: image == null ? const Placeholder() : RawImage(image: image),
  );

}

void main() => runApp(MaterialApp(home: VideoFeed()));