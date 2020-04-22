/*
 * Copyright (c) 2019 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'package:image/image.dart' as pimg;

import '../models/pet.dart';
import '../persistence/pet_access.dart';

class PreviewImageScreen extends StatefulWidget {
  final String imagePath;
  final ObservablePet pet;
  PreviewImageScreen ({ Key key, this.imagePath, this.pet }): super(key: key);

  @override
  _PreviewImageScreenState createState() => _PreviewImageScreenState();
}

class _PreviewImageScreenState extends State<PreviewImageScreen> {

  Future<String> persistImage() async {
    String newPath = join(await getPetPath(widget.pet.get()), '${DateTime.now()}.png').replaceAll(" ", "_");
    await File(widget.imagePath).rename(newPath);

    return newPath;
  }

  void addPhoto(String path) {
    pimg.Image image = pimg.decodeImage(File(path).readAsBytesSync());
    pimg.Image thumbnail = pimg.copyResize(image, width: 150);

    widget.pet.addPhoto(path);
    widget.pet.addThumbnail(thumbnail);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Preview'),
          backgroundColor: Colors.blueGrey,
        ),
        body: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                      flex: 2,
                      child: Image.file(File(widget.imagePath), fit: BoxFit.cover)),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          onPressed: () {
                            File(widget.imagePath).delete();
                            Navigator.pop(context, false);
                          },
                          child: Text('Cancelar'),
                        ),
                      ),
                      Expanded(
                          child: RaisedButton(
                            onPressed: (){
                              persistImage().then((String newpath) {
                                addPhoto(newpath);

                                Navigator.pop(context); // Exits to camera screen
                                Navigator.pop(context); // Goes back to view_pet_screen
                              });
                            },
                            child: Text('OK'),
                          ),
                      ),
                    ],
                  )
                ])
        )
    );
  }


  Future<ByteData> getBytesFromFile() async {
    Uint8List bytes = File(widget.imagePath).readAsBytesSync();
    return ByteData.view(bytes.buffer);
  }
}
