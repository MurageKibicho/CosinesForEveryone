// ignore_for_file: file_names, prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace, non_constant_identifier_names

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:jpegtran_ffi/jpegtran_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../Networking/LoginAndSignup.dart';
import '../Providers/Settings.dart';
import 'HomeScreen.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:image_size_getter/image_size_getter.dart' as Getsize;
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';




class ImageScreen extends StatefulWidget {
  final String jwt;

  const ImageScreen({Key? key, required this.jwt}) : super(key: key);
  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  ImageValueNotifier imageValueNotifier = ImageValueNotifier();
  final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
  double sliderValue = 100;
  String savedFilePath = "";
  String imageName = "";
  int imageHeight = 0;
  int imageWidth = 0;
  int imageSize = 0;
  String bb = " ";

  void StartWork() async
  {
    var result = await imageValueNotifier.LoadNetworkAsset(widget.jwt);
    savedFilePath = result.filePath;
    imageHeight = result.height;
    imageWidth = result.width;
    imageName = result.imageID;
    imageSize = result.fileSize;
    print("height: ${imageHeight}, width:${imageWidth},size :${imageSize}, location " +
        savedFilePath);
  }

  @override
  void initState() {
    super.initState();
    StartWork();
    //imageValueNotifier.LoadAsset();
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final settingsClass = Provider.of<Settings>(context);
    return Scaffold(
      body: Material(
        child: Container(
          height: screenHeight,
          width: screenWidth,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              SizedBox(height: 60,),
              GestureDetector(
                  onTap: () {},
                  child: ExitButtonResetButton(50, screenWidth, context)),
              ValueListenableBuilder<Uint8List?>(
                  valueListenable: imageValueNotifier,
                  builder: (BuildContext context, Uint8List? result,
                      Widget? child) {
                    return (result == null) ?
                    Container(
                      height: screenHeight / 2,
                      width: screenWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                              child: CircularProgressIndicator()),
                          Center(child: Text(
                            "Loading Image", style: TextStyle(fontSize: 30),))
                        ],
                      ),
                    )
                        :
                    Stack(
                      children: <Widget>[
                        Container(
                          height: (imageHeight > screenHeight) ? screenHeight *
                              0.8 : imageHeight.toDouble(),
                          width: (imageWidth > screenWidth)
                              ? screenWidth
                              : imageWidth.toDouble(),
                          child: Image.memory(result),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: screenWidth,
                            color: Colors.white.withOpacity(0.3),
                            child: Column(
                              children: <Widget>[
                                Slider(
                                    min: 1,
                                    max: 100,
                                    divisions: 10,
                                    value: sliderValue,
                                    onChanged: (value) {
                                      setState(() {
                                        sliderValue = value;
                                      });
                                    },
                                    onChangeEnd: (value) {
                                      print(sliderValue);
                                      //print("Here $savedFilePath");
                                      imageValueNotifier.ChangeQuality(
                                          savedFilePath, sliderValue.toInt());
                                    }
                                ),
                                SizedBox(height: 30),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: Size(screenWidth / 2, 50),
                                    primary: Color(0xffe46b10),
                                    side: BorderSide(
                                        width: 3, color: Color(0xffe46b10)),
                                  ),
                                  onPressed: () {
                                    imageValueNotifier.SubmitThenNewImage(sliderValue,settingsClass.email,imageName,widget.jwt);
                                  },
                                  child: Text("Submit"),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ExitButtonResetButton(double arrowHeight, double screenWidth,
      BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, bottom: 20),
      height: arrowHeight,
      width: screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xffe46b10),
                ),
                Text("Exit",
                  style: TextStyle(color: Color(0xffe46b10), fontSize: 20),),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.refresh,
                color: Color(0xffe46b10),
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      sliderValue = 100;
                    });
                    imageValueNotifier.ChangeQuality(
                        savedFilePath, sliderValue.toInt());
                  },
                  child: Text("Reset",
                    style: TextStyle(color: Color(0xffe46b10), fontSize: 20),)),
              SizedBox(width: 15,),
            ],
          ),
        ],
      ),
    );
  }
}

class ImageSize
{
    final int height;
    final int width;
    final int fileSize;
    final String filePath;
    final String imageID;
    ImageSize(this.height,this.width,this.fileSize, this.filePath, this.imageID);
}

class ImageValueNotifier extends ValueNotifier<Uint8List?>
{
  ImageValueNotifier() : super(null);
  late Uint8List initial;

  void CreateVideoImage

  void SubmitThenNewImage(double sliderValue, String email, String imageID, String jwt) async
  {
    var result = await SubmitWork(sliderValue, email, imageID, jwt);
    print(imageID);
    if(result == 200)
      {
        LoadNetworkAsset(jwt);
      }
    else
      {

      }

  }

  Future<ImageSize> LoadNetworkAsset(String jwt) async
  {
    try {
      // Saved with this method.
      var result = await GetWorkurl(jwt);
      if(result == "400")
        {
          return ImageSize(0,0, 0, " ", " ");
        }

      var parsed = json.decode(result);
      String downloadPath = parsed['address'];
      var imageId = await ImageDownloader.downloadImage(downloadPath);
      if (imageId == null) {
        return ImageSize(0, 0,0, " ", " ");
      }
      var fileName = await ImageDownloader.findName(imageId);
      var filePath = await ImageDownloader.findPath(imageId);
      var mimeType = await ImageDownloader.findMimeType(imageId);

      File file = File(filePath!);
      var fileSize = file.lengthSync();
      if(file.existsSync())
      {
        final size = Getsize.ImageSizeGetter.getSize(FileInput(file));
        Uint8List bytes = file.readAsBytesSync();
        value = bytes;
        return ImageSize(size.height, size.width,bytes.length, filePath, parsed['fileName']);;
      }
    } on PlatformException catch (error) {
      print(error);
      return ImageSize(0, 0,0, " ", " ");
    }
    return ImageSize(0, 0,0," ", " ");
  }
  void LoadAsset() async
  {
    String asset = "assets/user3.jpeg";
    var startImage = rootBundle.load(asset);
    startImage.then((result)
    {
      value = result.buffer.asUint8List();
    });
  }

  void ChangeQuality(String filePath,int quality)
  {
    var file = File(filePath);
    print(filePath);
    if(file.existsSync())
      {
        Uint8List bytes = file.readAsBytesSync();
        var transformer = JpegTransformer(bytes);
        try
        {
          print("Here");
          value = transformer.recompress(quality: quality, preserveEXIF: true);
        }
        catch(error)
        {
          print("Error: $error");
        }
        finally
        {
          transformer.dispose();
        }
      }
  }
}




Widget ImageContainer(double height, double screenWidth)
{
  return Container(
    height: height,
    width: screenWidth,
    color: Colors.black,
  );
}

Widget SliderTwo(double arrowHeight, double screenWidth)
{
  return Container(
    height: arrowHeight,
    width: screenWidth,
    color: Colors.green,
  );
}




Future<String> getNetworkPath() async
{
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String documentsPath = documentsDirectory.path;
  late String filePath = " ";
  filePath = "${documentsPath}/bicho.bae";
  return filePath;
}

Future<String> getInitialPath(int type, int quantizationLevel) async
{
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String documentsPath = documentsDirectory.path;
  late String filePath = " ";
  if(type == 0)
  {
    filePath = "${documentsPath}/sample-${quantizationLevel}.bmp";
  }
  else
  {
    filePath = "${documentsPath}/sample-${quantizationLevel}.pgm";
  }
  return filePath;
}

Future<String> getFilePath(int quantizationLevel) async
{
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String documentsPath = documentsDirectory.path;
  String filePath = "${documentsPath}/sample-${quantizationLevel}.bmp";
  return filePath;
}

Future<List<int>> GetAvailability(String jwt) async
{
  var url = Uri.parse(baseUrl+"/api/getAvailability");
  List<int> nullInt = [0,0];
  try {
    var result = await http.get(
      url,
      headers: <String, String>{
        "Content-type": "application/json",
        "auth-token": jwt
      },
    );
    if(result.statusCode == 200)
    {
      var parsed = json.decode(result.body);
      nullInt[0] = parsed['width'];
      nullInt[1] = parsed['height'];
      print(nullInt[0]);
      return nullInt;
    }
    else
    {
      print("Availability Network Error");
      return nullInt;
    }
  }on Exception{
    return nullInt;
  }
}

Future<Uint8List> GetWork(String jwt) async
{
  var url = Uri.parse(baseUrl+"/api/getwork");
  List <int> nullList = [1];
  try {
    var result = await http.get(
      url,
      headers: <String, String>{
        "Content-type": "application/json",
        "auth-token": jwt
      },
    );
    if(result.statusCode == 200)
    {
      print("200 Here");
      return result.bodyBytes;
    }
    else
    {
      print("Network Error: " + result.statusCode.toString());
      return Uint8List.fromList(nullList);
    }
  } on SocketException
  {
    print("You are not connected");
    return Uint8List.fromList(nullList);
  } on HttpException
  {
    print("Cannot find post");
    List <int> nullList = [1,0,0];
    return Uint8List.fromList(nullList);
  } on FormatException
  {
    print("Bad response");
    return Uint8List.fromList(nullList);
  }
}


