import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

import '../models/pet.dart';
import '../persistence/pet_persistence.dart' as persist;
import 'add_pet_screen.dart';

class ViewPetScreen extends StatefulWidget {
  final Pet pet;
  final ObservableList<Pet> pets;
  ViewPetScreen ({ Key key, this.pet, this.pets }): super(key: key);

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
  }

  // Displays or edits
  Widget makePetType() {
    return Expanded(child:
        Observer(
          builder: (_) {
            return ListTile(
                title: Text(persist.getPetTypeStr(widget.pet.petType))
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
              title: Text(persist.getSexStr(widget.pet.sex)),
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

  // Build thumbnail tile
  Widget buildTile(BuildContext context, int i) {
    return GridTile(
      child: GestureDetector(
        onTap: () async {
          await showDialog(context: context, builder: (_) => ImageDialog(widget.pet.photos[i].path));
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage( //widget.pet.photos[i].getThumbnail()
              image: FileImage(File(widget.pet.photos[i].getThumbnail())),
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.cancel, size: 20, color: Colors.red,),
              onPressed: () => persist.deletePhoto(widget.pet, i),
            ),
          ),
        ),
      ),

    );
  }

  Widget makeGallery() {
    print("# photos: ${widget.pet.photos.length}");
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
                  itemCount: widget.pet.photos.length,
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
    widget.pets.remove(widget.pet);
    persist.deletePet(widget.pet);
  }

  Future<bool> _showDeleteDialog() async {
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
                Navigator.pop(context); // Return to previous screen
              },
            ),
          ],
        );
      },
    );
  }

  void takePhoto(ImageSource source) {
    Future<File> f = ImagePicker.pickImage(source: source, maxHeight: 1080.0, maxWidth: 1920.0, imageQuality: 80);
    f.then((File file) {
      if (file != null) {
        setState(() {
          persist.addPhoto(widget.pet, file);
        });
      }
    });
  }


  Widget makeOptionsRow() {
    return ListTile(
      title: Row(
        children: <Widget>[
          Expanded(
            child: IconButton(
              color: Colors.red,
              icon: Icon(Icons.delete_forever),
              tooltip: "Deletar pet",
              onPressed: () {
                _showDeleteDialog();
              },
            ),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.edit),
              tooltip: "Editar",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddPetScreen(pet: widget.pet)),
                );
              },
            ),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.camera),
              tooltip: "Adicionar da câmera",
              onPressed: () => takePhoto(ImageSource.camera),
            ),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.photo_album),
              tooltip: "Adicionar da galeria",
              onPressed: () => takePhoto(ImageSource.gallery),
            ),
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
            String emoji = persist.getPetEmoji(widget.pet.petType);
            return Text(emoji + " " + widget.pet.name);
          },
        ),
      ),
      body: makeBody(),
    );
  }

}

class ImageDialog extends StatefulWidget {
  final String path;

  ImageDialog(this.path);

  State<StatefulWidget> createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog> {
  @override
  Widget build(BuildContext context) {
    var tuple = persist.getPhoto(widget.path);
    num w = tuple.item2;
    num h = tuple.item3;
    num aspect = (w > h) ? w / h : h / w;
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: MemoryImage(tuple.item1),
                fit: BoxFit.cover,
            )
        ),
        child: AspectRatio(
          aspectRatio: aspect,
          child: Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.cancel),
              color: Colors.black,
              onPressed: () => Navigator.pop(context),
            ),
          )
        ),
      ),
    );
  }
}


