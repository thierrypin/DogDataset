import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as pimg;


import '../models/pet.dart';
import '../persistence/pet_access.dart';
import '../camerascreen/camera.dart';

class ViewPetScreen extends StatefulWidget {
  final ObservablePet pet;
  ViewPetScreen ({ Key key, this.pet }): super(key: key);

  State<StatefulWidget> createState() => _ViewPetScreenState();
}

class _ViewPetScreenState extends State<ViewPetScreen> {
  Directory _directory;
  bool _editingType = false;

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((Directory value) {
      setState(() {
        _directory = Directory(value.path + '/' + widget.pet.get().id.toString().padLeft(6, '0'));
        print(_directory);
      });
    });
    populateThumbnails();
  }

  void populateThumbnails() {
//    widget.pet.thumbnails = List<pimg.Image>();
    for (String img in widget.pet.get().photos) {
      print(img);
      pimg.Image image = pimg.decodeImage(File(img).readAsBytesSync());

      // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
      pimg.Image thumbnail = pimg.copyResize(image, width: 150, height: 150);
      widget.pet.addThumbnail(thumbnail);
    }
  }

  Widget buildTile(BuildContext context, int i) {
    return GridTile(
      child: Align(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: MemoryImage(pimg.encodePng(widget.pet.get().thumbnails[i])),
              fit: BoxFit.cover,
            ),
          ),
        ),
        alignment: Alignment.center,
      ),

    );
  }

  Widget makePetType() {
    if (_editingType) {

    }
  }

  Widget makeInfoRow() {
    return ListTile(
      title: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: ListTile(title: Text(getPetTypeStr(widget.pet.get().petType)))),
              Expanded(child: ListTile(title: (widget.pet.get().breed == "" || widget.pet.get().breed == null) ? Text("Vira-lata") : Text(widget.pet.get().breed))),
            ],
          ),
          ListTile(title: (widget.pet.get().sex == Sex.masc) ? Text("Macho") : Text("Fêmea")),
        ],
      ),
    );
  }


  Widget makeGallery() {
    print("# photos: ${widget.pet.get().thumbnails.length}");
    if (widget.pet.get().photos.isNotEmpty) {
      return Expanded(
        child: Container(
          decoration: new BoxDecoration(
            border: Border.all(color: Colors.black26, style: BorderStyle.solid, width: 3),
            boxShadow: [BoxShadow(color: Colors.black)],
            color: Colors.white70,
          ),
          child: Observer(
            builder: (_) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 150, crossAxisSpacing: 8, mainAxisSpacing: 8),
                itemBuilder: buildTile,
                itemCount: widget.pet.get().thumbnails.length,
              );
            }
          ),
        ),
      );
    } else {
      return Center(child: Text("Este pet não possui fotos."),);
    }
  }

  void _deletePet() {
    deletePet(widget.pet.get());
  }

  Future<bool> _showDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Deletar ${widget.pet.get().name}?"),
          content: new Text("Esta ação não poderá ser desfeita"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Não"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            new FlatButton(
              child: new Text("Sim"),
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _deletePet();
                Navigator.pop(context, "delete"); // Return to previous screen
              },
            ),
          ],
        );
      },
    );
  }

  Widget makeOptionsRow() {
    return ListTile(
      title: Row(
        children: <Widget>[
          RaisedButton(
            color: Colors.red,
            child: Row(children: <Widget>[Icon(Icons.delete_forever), Text("Deletar")],),
            onPressed: () {
              _showDialog();
            },
          ),
          SizedBox(width: 30,),
          RaisedButton(
            child: Row(children: <Widget>[Icon(Icons.edit), Text("Editar")],),
            onPressed: () {
//              var res = Navigator.push(
//                context,
//                MaterialPageRoute(builder: (context) => AddPetScreen(pet: widget.pet)),
//              );
//              res.then((val) {
//                print(widget.pet.breed);
//              });
            },
          ),
        ],
      ),
    );
  }

  Widget makeBody() {
    return Column(
      children: <Widget>[
        makeInfoRow(),
        makeGallery(),
        makeOptionsRow(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String emoji = getPetEmoji(widget.pet.get().petType);

    return Scaffold(
      appBar: AppBar(
        title: Text(emoji + " " + widget.pet.get().name),

      ),
      body: makeBody(),
      floatingActionButton: FloatingActionButton(
        child:
        Icon(Icons.camera),
        tooltip: "Add new photo",
        onPressed: (){
          var response = Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CameraScreen(pet: widget.pet)),
          );
          response.then((value) {
            if (value is String) {
              pimg.Image image = pimg.decodeImage(File(value).readAsBytesSync());
              pimg.Image thumbnail = pimg.copyResize(image, width: 200);

              setState(() {
                widget.pet.get().photos.add(value);
                widget.pet.get().thumbnails.add(thumbnail);
              });
            }
          });
        },
      ),

    );
  }

}

