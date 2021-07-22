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
    
    //Regular expression part
 // final regExp=RegExp(r'^([A-Z])([A-Z])(\s)([0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9])(\s)([A-Z])$');
 // final regExp1=RegExp(r'^([A-Z])([A-Z])\s([0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9])([A-Z])$');
 // final regExp2=RegExp(r'^([A-Z])([A-Z])([0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9])\s([A-Z])$');
 // final regExp3=RegExp(r'^([A-Z])([A-Z])([0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9])([A-Z])$');
 //    List<String> str = _text.split('\n');
 //    String serialNumber='';
 //    for (String temp in str) {
 //      final match = regExp.firstMatch(temp);
 //      final match1 = regExp1.firstMatch(temp);
 //      final match2 = regExp2.firstMatch(temp);
 //      final match3 = regExp3.firstMatch(temp);
 //      final everything = match.group(0);
 //      final everything1 = match1.group(0);
 //      final everything2 = match2.group(0);
 //      final everything3 = match3.group(0);
 //      serialNumber+=everything+"##"+everything1+"##"+everything2+"##"+everything3;
 //
 //    }

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
