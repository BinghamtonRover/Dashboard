import "dart:async";  // lets us delay the code
import "dart:io";  // read the file
import "dart:typed_data";  // store the bytes
import "dart:ui";  // decode the image

// Flutter has an Image widget, but it does too much work. 
// We'll use RawImage instead. 
import "package:flutter/material.dart" hide Image;

class Page extends StatefulWidget {
  @override
  State createState() => PageState();
}

class PageState extends State<Page> {
  late Timer timer;
  Image? image;
  int count = 1;

  @override
  void initState() { 
    timer = Timer(const Duration(milliseconds: 100), updateImage);
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<Uint8List> getBytes() => 
    //File("///Users/dillonaldrich/Downloads/coding/Dashboard/MarsPic.jpg").readAsBytes();
    File("C:\\Users\\dillonaldrich\\Downloads\\coding\\Dashboard\\MarsPic.jpg").readAsBytes();
    //File("C:\\Users\\levi\\Coding\\BURT\\dashboard\\output\\$count.jpg").readAsBytes();
    
  Future<Image> loadImage(Uint8List bytes) async {
    final buffer = await ImmutableBuffer.fromUint8List(bytes);
    final descriptor = await ImageDescriptor.encoded(buffer);
    final codec = await descriptor.instantiateCodec();
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  void replaceImage(Image newImage) {
    final Image? oldImage = image;
    setState(() => image = newImage);
    oldImage?.dispose();
  }

  void updateState() {
    count++;
    if (count > 6) count = 1;
    timer = Timer(const Duration(milliseconds: 100), updateImage);
  }

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

void main() => runApp(MaterialApp(home: Page()));
