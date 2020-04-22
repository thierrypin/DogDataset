import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'dart:async';

import 'models/pet.dart';
import 'persistence/pet_access.dart';
import 'petmanagement/new_pet_screen.dart';
import 'petmanagement/view_pet_screen.dart';


class DogHomePage extends StatefulWidget {
  DogHomePage({Key key}) : super(key: key);
  State<StatefulWidget> createState() => _DogHomePageState();
}

class _DogHomePageState extends State<DogHomePage> {

  PetList _pets = PetList();

  @override
  void initState() {
    super.initState();

    if (_pets.isEmpty()) {
      Future<List<Pet>> fpets = loadPets();
      fpets.then((value) {
        print("pets # ${value.length}");
        setState(() {
          print("terminou");
          _pets.setList(value);
        });
      });
    }
  }

  Widget _itemBuilder(BuildContext context, int i) {
    Pet pet = _pets[i];
    print(pet.name);
    return ListTile(
      title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(pet.name, style: TextStyle(fontSize: 18.0)),
        ),
      trailing: Text(getPetEmoji(pet.petType)),
      onTap: (){
        var result = Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ViewPetScreen(pet: ObservablePet(pet))),
        );
        result.then((res) {
          if (res == "delete") {
            setState(() {
              _pets.removeAt(i);
            });
          }
        });
      },
    );
  }

  Widget _buildPetsList() {
    print("Pet Lenght: ${_pets.length()}");
    if (_pets.isEmpty()) {
      return Center(
        child: Text("Você não possui animais cadastrados"),
      );
    } else {
      print("Tem");

      return Observer(
        builder: (_) {
          return ListView.builder(
            itemCount: _pets.length(),
            itemBuilder: _itemBuilder,
          );
        },
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Unesp - Dataset de PET"),
      ),
      drawer: Drawer(
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
              title: Text("Sobre"),
              onTap: () {
                print("tapou sobre");
              },
            )
          ],
        ),
      ),
      body:
      Column(
        children: <Widget>[
          ListTile(title: Text("Animais cadastrados"),),
          Expanded(child: _buildPetsList(),),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child:
        Icon(Icons.add),
        tooltip: "Add new pet",
        onPressed: (){
          var result = Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPetScreen(pet: Pet())),
          );
          result.then((value){
            if(value is Pet) {
              setState((){
                _pets.add(value);
              });
            }
          });
        },
      ),
    );
  }

}
