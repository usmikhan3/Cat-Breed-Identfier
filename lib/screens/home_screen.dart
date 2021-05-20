import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<File> imageFile;
  File _image;
  String result = '';
  ImagePicker imagePicker;
  List _output;







  selectPhoto() async{
    PickedFile pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    if(pickedFile == null) return null;
    setState(() {
      _image = File(pickedFile.path);

    });
    doImageClassification();
  }


  capturePhoto() async{
    PickedFile pickedFile = await imagePicker.getImage(source: ImageSource.camera);
    if(pickedFile == null) return null;

    setState(() {
      _image = File(pickedFile.path);

    });
    doImageClassification();
  }

  loadModel() async{
    String output = await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
        numThreads: 1,
      isAsset: true,
      useGpuDelegate: false
    );
    print(output);

  }

  doImageClassification() async {
    var recognition = await Tflite.runModelOnImage(path: _image.path,
    imageMean: 0.0,
    imageStd: 255.0,
    threshold: 2,
    asynch: true);
    print(recognition.length.toString());
    setState(() {
      result = "";
    });

    recognition.forEach((element) {
      setState(() {
        print(element.toString());
        result += element["label"];
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagePicker = ImagePicker();
    loadModel().then((value){
      setState(() {

      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Tflite.close();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.jpg"),
                fit: BoxFit.cover
              )
            ),
            child: Column(
              children: [
                SizedBox(width: 100,),
                Container(
                  margin: EdgeInsets.only(top: 40),
                  child: Stack(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: ElevatedButton(
                            onPressed: ()=>selectPhoto(),
                            onLongPress: ()=>capturePhoto(),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.white),
                                shadowColor: MaterialStateProperty.all(Colors.black) ,
                            ),
                            child: Container(
                              margin: EdgeInsets.only(top: 30,right: 35,left: 18),
                              child: _image != null ?
                              Image.file(_image,height: 160,width: 400,fit: BoxFit.cover,) :
                              Container(
                                 width: 140,
                                height: 190,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.black,
                                ),
                              ) ,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height:160 ,),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: _output != null ? Text("$result",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Brand Bold",
                    fontSize: 25,
                    color: Colors.blueAccent,
                    backgroundColor: Colors.white60
                  ),) : Container(),
                ),
              ],
            ),
          ),
        )
    );
  }
}
