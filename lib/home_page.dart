import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'dart:async';

import 'conn/sync.dart';
import 'models/pet.dart';
import 'persistence/pet_persistence.dart';
import 'petmanagement/add_pet_screen.dart';
import 'petmanagement/view_pet_screen.dart';


class DogHomePage extends StatefulWidget {
  DogHomePage({Key key}) : super(key: key);
  State<StatefulWidget> createState() => _DogHomePageState();
}

class _DogHomePageState extends State<DogHomePage> {

  List<Pet> _pets = List<Pet>();
  ObservableList<Pet> _observablePets = ObservableList<Pet>();

  @override
  void initState() {
    super.initState();

    if (_pets.isEmpty) {
      Future<List<Pet>> fpets = loadPets();
      fpets.then((value) {
        print("pets # ${value.length}");
        setState(() {
          _pets = value;
        });
        _observablePets = ObservableList<Pet>.of(_pets);
      });
    }
  }

  Widget _itemBuilder(BuildContext context, int i) {
    Pet pet = _observablePets[i];
    print("==============");
    print(pet.name);
    return ListTile(
      title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(pet.name, style: TextStyle(fontSize: 18.0)),
        ),
      trailing: Text(getPetEmoji(pet.petType)),
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ViewPetScreen(pet: pet, pets: _observablePets)),
        );
      },
    );
  }

  Widget _buildPetsList() {
    print("Pet Lenght: ${_observablePets.length}");
    if (_observablePets.isEmpty) {
      return Center(
        child: Text("Você não possui animais cadastrados"),
      );
    } else {
      return Observer(
        builder: (_) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: _observablePets.length,
            itemBuilder: _itemBuilder,
          );
        },
      );

    }
  }

  Widget addPetButton() {
    return IconButton(
      icon: Icon(Icons.add),
      tooltip: "Novo pet",
      onPressed: (){
        var result = Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddPetScreen(pet: Pet(), pets: _observablePets)),
        );
        result.then((value){
          if(value is Pet) {
            setState((){
              _pets.add(value);
            });
          }
        });
      },
    );
  }

  Widget makeDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(child: Text('Opções'),),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text("Instruções"),
            onTap: () {
              print("tapou instruções");
            },
          ),
          ListTile(
            title: Text("Sobre"),
            onTap: () {
              print("tapou sobre");
            },
          ),
        ],
      ),
    );
  }

  Widget uploadButton() {
    return FloatingActionButton(
        child: Icon(Icons.cloud_upload),
        tooltip: "Enviar fotos",
        onPressed: () {syncPets(_pets);},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Unesp - Dataset de PET"),
        actions: <Widget>[
          addPetButton(),
        ],
      ),
      drawer: makeDrawer(),
      body: Column(
        children: <Widget>[
          Align(alignment: Alignment.centerLeft, child: ListTile(title: Text("Animais salvos", style: Theme.of(context).textTheme.headline5))),
          Expanded(child: _buildPetsList(),),
        ],
      ),
      floatingActionButton: uploadButton(),
    );
  }

}
