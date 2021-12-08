// ignore_for_file: file_names, prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace, non_constant_identifier_names

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cosines_for_everyone/Networking/LoginAndSignup.dart';
import 'package:flutter/foundation.dart';
import 'package:cosines_for_everyone/CLibs/ffi_bridge.dart';
import 'package:cosines_for_everyone/Providers/Data.dart';
import 'package:cosines_for_everyone/Providers/Settings.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'HomeScreen.dart';
import 'package:flutter/painting.dart';


class ImageScreen extends StatefulWidget {
  final String jwt;

  const ImageScreen({Key? key, required this.jwt}) : super(key: key);
  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  double value = 0;

  /*New */
  ImageValueNotifier imageValueNotifier = ImageValueNotifier();
  List<int> imageWidthHeight = [0,0];
  int sliderMax = 30;

  _setup() async
  {
    List<int> _imageWidthHeight = await GetAvailability(widget.jwt);
    setState(() {
      imageWidthHeight = _imageWidthHeight;
    });
    imageValueNotifier.NetworkFileToImage(widget.jwt);
    imageValueNotifier.saveFile(_imageWidthHeight,1);
  }

  @override
  void initState() {
    super.initState();
    _setup();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final dataClass = Provider.of<Data>(context);
    void ChangeImage(List<int> _imageWidthHeight, int quantizationLevel) {
      if(dataClass.availableImages[quantizationLevel] == 0)
      {
        print("Saving");
        imageValueNotifier.saveFile(_imageWidthHeight,quantizationLevel);
        dataClass.setAvailable(quantizationLevel);
      }
      else
      {
        imageValueNotifier.loadFile(quantizationLevel);
        print("Loaded from storage");
      }
    }
    return Scaffold(
      body: Material(
        child: Container(
          height: screenHeight,
          width: screenWidth,
          child: Column(
            children:<Widget>[
              SizedBox(height: 60,),
              GestureDetector(
                  onTap: ()
                  {
                    dataClass.setQuantization(1);
                  },
                  child: ExitButtonResetButton(50, screenWidth,context)),
              ValueListenableBuilder<String?>(
                valueListenable: imageValueNotifier,
                  builder: (BuildContext context, String ? result, Widget? child) {
                    return Container(
                      width: screenWidth,
                      height: screenHeight/2,
                      child: (result == null) ?
                      CircularProgressIndicator()
                          :
                      Image.file(File(result),key: ValueKey(Random().nextInt(100)),),
                      );
                  },
              ),
              SizedBox(height: 30,),
              SizedBox(height: 30,),
              Slider(
                thumbColor: Color(0xffe46b10),
                  activeColor: Color(0xfffbb448),
                  inactiveColor: Colors.grey,
                  value: dataClass.quantizationLevel.toDouble(),
                  min: 1,
                  max: sliderMax.toDouble(),
                  divisions:sliderMax,
                  onChanged: (value)
                  {
                    dataClass.setQuantization(value);
                    ChangeImage(imageWidthHeight, dataClass.quantizationLevel);
                  }
              ),
              SizedBox(height: 30),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(screenWidth/2,50),
                  primary: Color(0xffe46b10),
                  side: BorderSide(width: 3, color:Color(0xffe46b10)),
                ),
                onPressed: ()
                {
                  imageValueNotifier.ClearCache();
                  _setup();
                  for(int i = 0; i < sliderMax; i++)
                  {
                    dataClass.setUnAvailable(i);
                  }
                  dataClass.setQuantization(1);
                  dataClass.setUnAvailable(1);
                },
                child: Text("Submit"),
              )
            ],
          ),
        ),
      ),
    );
  }
}


Widget ExitButtonResetButton(double arrowHeight, double screenWidth, BuildContext context)
{
  return Container(
    padding: EdgeInsets.only(left: 20,bottom: 20),
    height: arrowHeight,
    width: screenWidth,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: ()
          {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          child: Row(
            children:<Widget>[
              Icon(
                Icons.arrow_back_ios,
                color: Color(0xffe46b10),
              ),
              Text("Exit",style: TextStyle(color: Color(0xffe46b10),fontSize: 20),),
            ],
          ),
        ),
        Row(
          children:<Widget>[
            Icon(
              Icons.refresh,
              color: Color(0xffe46b10),
            ),
            Text("Reset",style: TextStyle(color: Color(0xffe46b10),fontSize: 20),),
            SizedBox(width: 15,),
          ],
        ),
      ],
    ),
  );
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

class ImageValueNotifier extends ValueNotifier<String?> {
  ImageValueNotifier() : super(null);

  late String initial;

  void NetworkFileToImage(String jwt)async
  {
    var response = await GetWork(jwt);
    final FFIBridge _ffiBridge = FFIBridge();
    if(response.length != 1)
    {
      String filePath = await getNetworkPath();
      File file = File(filePath);
      await file.writeAsBytes(response);
      print("Downloaded!");
      String bitmapPath = await getInitialPath(0,1);
      String pgmPath = await getInitialPath(1,1);
      if(file.existsSync())
      {
        int result = _ffiBridge.decompressFile(bitmapPath, pgmPath, filePath);
        if(result == 1)
          {
            value = bitmapPath;
          }
      }
    }
    else
      {
        print("Failing Here");
      }
  }

  void reset()
  {
    value = initial;
  }

  void ClearCache()async
  {
    imageCache!.clear();
    for(int i = 0; i < 11; i++)
      {
        String filePath = await getFilePath(i);
        File file = File(filePath);
        if(file.existsSync())
        {
          print("Deleted: $i");
          file.delete();
        }
      }
  }

  void loadFile(int quantization) async
  {
    String filePath = await getFilePath(quantization);
    File file = File(filePath);
    if(file.existsSync())
    {
      value = filePath;
      initial = value!;
    }
  }

  void saveFile(List<int> widthHeight,int quantization) async
  {
    String bitmapPath = await getInitialPath(0,quantization);
    String pgmPath = await getInitialPath(1,1);
    final FFIBridge _ffiBridge2 = FFIBridge();
    int quantizationLevel = quantization;
    Pointer<Int32> XY = calloc<Int32>(2);
    XY[0] = widthHeight[0];
    XY[1] = widthHeight[1];
    int result = _ffiBridge2.quantizeFile(pgmPath,bitmapPath, XY,quantizationLevel);
    print("Trying to save file :" + result.toString());
    calloc.free(XY);
    value = bitmapPath;
  }
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


