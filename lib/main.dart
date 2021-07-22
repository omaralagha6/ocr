// @dart=2.9
import 'dart:collection';
import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'details.dart';

void main() => runApp(MaterialApp(
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _text = '';
  PickedFile _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Recognition'),
        actions: [
          FlatButton(
            onPressed: scanText,
            child: Text(
              'Scan',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        child: Icon(Icons.add_a_photo),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: _image != null
            ? Image.file(
                File(_image.path),
                fit: BoxFit.fitWidth,
              )
            : Container(),
      ),
    );
  }

  Future scanText() async {
    CircularProgressIndicator();
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(File(_image.path));
    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();
    final VisionText visionText =
        await textRecognizer.processImage(visionImage);
    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        _text += (line.text + '\n');
      }
    }
    print(_text);
    
   List<String> str=_text.split("\n");

    final regExp=RegExp(r'^([A-Z])([A-Z])(\s)([0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9])(\s)([A-Z])$');
    final regExp1=RegExp(r'^([A-Z])([A-Z])\s([0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9])([A-Z])$');
    final regExp2=RegExp(r'^([A-Z])([A-Z])([0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9])\s([A-Z])$');
    final regExp3=RegExp(r'^([A-Z])([A-Z])([0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9])([A-Z])$');
    List<String>serials=new List<String>();
    for(String s in str)
    {
      if(regExp.hasMatch(s)|| regExp1.hasMatch(s) ||regExp2.hasMatch(s)|| regExp3.hasMatch(s))
        serials.add(s);
    }
    print (serials);

    Navigator.of(context).pop();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Details(serials.first)));

    Navigator.of(context).pop();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Details(_text)));
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = pickedFile;
      } else {
        print("No image selected");
      }
    });
  }
}
