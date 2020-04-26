import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as pimg;

import '../models/pet.dart';
import '../persistence/pet_access.dart';
import '../camerascreen/camera.dart';
import 'new_pet_screen.dart';

class ViewPetScreen extends StatefulWidget {
  final Pet pet;
  ViewPetScreen ({ Key key, this.pet }): super(key: key);

  State<StatefulWidget> createState() => _ViewPetScreenState();
}

class _ViewPetScreenState extends State<ViewPetScreen> {
  Directory _directory;

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((Directory value) {
      setState(() {
        _directory = Directory(value.path + '/' + widget.pet.id.toString().padLeft(6, '0'));
        print(_directory);
      });
    });
    populateThumbnails();
  }


  void populateThumbnails() {
//    widget.pet.thumbnails = List<pimg.Image>();
    for (String img in widget.pet.photos) {
      print(img);
      pimg.Image image = pimg.decodeImage(File(img).readAsBytesSync());

      // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
      pimg.Image thumbnail = pimg.copyResize(image, width: 150, height: 150);
      widget.pet.addThumbnail(thumbnail);
    }
  }

  // Build thumbnail tile
  Widget buildTile(BuildContext context, int i) {
    return GridTile(
      child: Align(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: MemoryImage(pimg.encodePng(widget.pet.thumbnails[i])),
              fit: BoxFit.cover,
            ),
          ),
        ),
        alignment: Alignment.center,
      ),

    );
  }

  // Displays or edits
  Widget makePetType() {
    return Expanded(child:
        Observer(
          builder: (_) {
            return ListTile(
                title: Text(getPetTypeStr(widget.pet.petType))
            );
          },
        )

    );
  }

  Widget makePetSex() {
      return Expanded(
        child:
        Observer(
          builder: (_) {
            return ListTile(
              title: Text(getSexStr(widget.pet.sex)),
            );
          }
        )
      );
  }

  Widget makePetBreed() {
    return Expanded(
      child: Observer(
        builder: (_) {
          return ListTile(
              title: (widget.pet.breed == "" || widget.pet.breed == null) ? Text("Vira-lata") : Text(widget.pet.breed)
          );
        },
      )
    );
  }

  Widget makeInfoRow() {
    return ListTile(
      title: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              makePetType(),
              makePetBreed(),
            ],
          ),
          Row(
            children: <Widget>[
              makePetSex(),
              Expanded(child: Text(""),),
            ],
          )

        ],
      ),
    );
  }


  Widget makeGallery() {
    print("# photos: ${widget.pet.thumbnails.length}");
    if (widget.pet.photos.isNotEmpty) {
      return Expanded(
        child: Observer(
          builder: (_){
            return Container(
                decoration: new BoxDecoration(
                  border: Border.all(color: Colors.black26, style: BorderStyle.solid, width: 3),
                  boxShadow: [BoxShadow(color: Colors.black)],
                  color: Colors.white70,
                ),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 150, crossAxisSpacing: 8, mainAxisSpacing: 8),
                  itemBuilder: buildTile,
                  itemCount: widget.pet.thumbnails.length,
                )
            );

          },
        )
      );
    } else {
      return Center(child: Text("Este pet não possui fotos."),);
    }
  }

  void _deletePet() {
    // TODO
    deletePet(widget.pet);
  }

  Future<bool> _showDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Deletar ${widget.pet.name}?"),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddPetScreen(pet: widget.pet)),
              );
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
    return Scaffold(
      appBar: AppBar(
        title: Observer(
          builder: (_) {
            String emoji = getPetEmoji(widget.pet.petType);
            return Text(emoji + " " + widget.pet.name);
          },
        ),

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
//          response.then((value) {
//            if (value is String) {
//              pimg.Image image = pimg.decodeImage(File(value).readAsBytesSync());
//              pimg.Image thumbnail = pimg.copyResize(image, width: 200);
//
////              setState(() {
////              widget.pet.photos.add(value);
////              widget.pet.thumbnails.add(thumbnail);
////              });
//            }
//          });
        },
      ),

    );
  }

}

