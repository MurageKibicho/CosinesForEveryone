// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, non_constant_identifier_names, sized_box_for_whitespace, use_key_in_widget_constructors

import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:jpegtran_ffi/jpegtran_ffi.dart';

/*void main() {
  runApp(const MyApp());
}*/

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ImageScreen(),
    );
  }
}

class ImageScreen extends StatefulWidget {
  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  ImageValueNotifier imageValueNotifier = ImageValueNotifier();
  double sliderValue = 100;
  @override
  void initState()
  {
    super.initState();
    imageValueNotifier.LoadAsset();
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Material(
        child: Container(
          height: screenHeight,
          width: screenWidth,
          color: Colors.white,
          child: Column(
            children: [
              Center(
                child: ValueListenableBuilder<Uint8List?>(
                    valueListenable: imageValueNotifier,
                    builder: (BuildContext context, Uint8List? result, Widget? child)
                    {
                      return Container(
                        height: screenHeight/2,
                        width: screenWidth,
                        child: (result == null) ?
                        CircularProgressIndicator()
                            :
                        Image.memory(result),
                      );
                    }
                ),
              ),
              Slider(
                  min: 1,
                  max: 100,
                  divisions: 10,
                  value: sliderValue,
                  onChanged: (value)
                  {
                    setState(() {
                      sliderValue = value;
                    });
                    imageValueNotifier.ChangeQuality(sliderValue.toInt());
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ImageValueNotifier extends ValueNotifier<Uint8List?>
{
  ImageValueNotifier() : super(null);
  late Uint8List initial;

  void LoadAsset() async
  {
    String asset = "assets/user3.jpeg";
    var startImage = rootBundle.load(asset);
    startImage.then((result)
    {
      value = result.buffer.asUint8List();
    });
  }

  void ChangeQuality(int quality)
  {
    String asset = "assets/user3.jpeg";
    var startImage = rootBundle.load(asset);
    startImage.then((result)
    {
      var transformer = JpegTransformer(result.buffer.asUint8List());
      try
      {
        value = transformer.recompress(quality: quality, preserveEXIF: true);
      }
      finally
      {
        transformer.dispose();
      }
    });
  }
}


