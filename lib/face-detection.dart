import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';

class FaceDetectionScreen extends StatefulWidget {
  const FaceDetectionScreen({super.key});

  @override
  State<FaceDetectionScreen> createState() => _FaceDetectionScreenState();
}

class _FaceDetectionScreenState extends State<FaceDetectionScreen> {
  File? _image;
  List<Face> faces = [];

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      setState(() {
        _image = File(image.path);
      });
    } catch (e) {
      print(e);
    }
  }

  Future _detetFaces(File image) async {
    final options = FaceDetectorOptions();
    final faceDetector = FaceDetector(options: options);
    final inputImage = InputImage.fromFilePath(image.path);
    faces = await faceDetector.processImage(inputImage);

    setState(() {});

    print(faces.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Detection'),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
                width: double.infinity,
                height: 250,
                color: const Color.fromARGB(54, 158, 158, 158),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                    child: _image == null
                        ? const Icon(Icons.add_a_photo, size: 60)
                        : Image.file(_image!),
                  ),
                )),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 50,
              color: Colors.blue,
              child: MaterialButton(
                onPressed: () {
                  _pickImage(ImageSource.gallery).then(
                      (value) => {if (_image != null) _detetFaces(_image!)});
                },
                child: const Text(
                  "Choose from gallery",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 50,
              color: Colors.blue,
              child: MaterialButton(
                onPressed: () {
                  _pickImage(ImageSource.camera).then(
                      (value) => {if (_image != null) _detetFaces(_image!)});
                },
                child: const Text(
                  "Take a photo",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
                width: double.infinity,
                height: 50,
                child: Center(
                  child: Text(
                    "Number of faces: ${faces.length}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ))
          ],
        ),
      )),
    );
  }
}
