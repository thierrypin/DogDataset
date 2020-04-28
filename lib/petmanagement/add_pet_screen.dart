import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io';

import '../models/pet.dart';
import '../persistence/pet_access.dart';
import 'view_pet_screen.dart';

class AddPetScreen extends StatefulWidget {
  final Pet pet;
  final ObservableList<Pet> pets;
  AddPetScreen({ Key key, this.pet, this.pets }): super(key: key);

  @override
  State<StatefulWidget> createState() => _AddPetScreenState();
}


class _AddPetScreenState extends State<AddPetScreen> {
  bool _newPet;
  String _directory;
  bool _typeRadioValidationError = false;
  bool _sexRadioValidationError = false;
  final String _typeRadioValidationMsg = "Escolha uma espécie";
  final String _sexRadioValidationMsg = "Escolha um sexo";
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _breedFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    getApplicationDocumentsDirectory().then((Directory value) {
      setState(() {
        _directory = value.path;
        print(_directory);
        value.list(recursive: true).listen((FileSystemEntity e) {
          print(e.path);
        });
      });
    });

    if (widget.pet.id == null) {
      print("Id nulo");
      _newPet = true;

      SharedPreferences.getInstance().then((SharedPreferences _prefs) {
        int id = _prefs.getInt('id_counter');
        if (id == null) {
          _prefs.setInt("id_counter", 0);
          id = 0;
        }

        widget.pet.id = id;
      });
    } else {
      print("Id ${widget.pet.id}");
      print("nome ${widget.pet.name}");
      _newPet = false;

      _nameController.text = widget.pet.name;
      _breedController.text = widget.pet.breed;
    }

  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    super.dispose();
  }

  void _savePet() async {
    // VALIDATION
    // pet type
    if (widget.pet.petType == PetType.none) {
      setState(() {
        _typeRadioValidationError = true;
      });
    }
    // sex
    if (widget.pet.sex == Sex.none) {
      setState(() {
        _sexRadioValidationError = true;
      });
    }
    // text fields
    if (_formKey.currentState.validate() && widget.pet.petType != PetType.none && widget.pet.sex != Sex.none) {
      widget.pet.setName(_nameController.text);
      widget.pet.setBreed(_breedController.text);

      // Save pet
      savePet(widget.pet);
      widget.pets.add(widget.pet);

      Navigator.pop(context, widget.pet);
      if (_newPet) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ViewPetScreen(pet: widget.pet, pets: widget.pets)),
        );
      }
    }
  }

  Widget makeFormName() {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text("Nome:"),
          onTap: (){
            _nameFocusNode.requestFocus();
          },
        ),
        ListTile(
          title: TextFormField(
            textCapitalization: TextCapitalization.sentences,
            enableSuggestions: true,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value.isEmpty) {
                return 'Dê um nome para o bicho';
              }
              return null;
            },
            focusNode: _nameFocusNode,
            controller: _nameController,
            decoration: InputDecoration(
                hintText: 'Escreva o nome do bicho'
            ),
          ),
        ),
      ],
    );
  }

  Widget makeFormPetType() {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text("Espécie do pet:"),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: RadioListTile(
                title: const Text("Cachorro"),
                value: PetType.dog,
                groupValue: widget.pet.petType,
                onChanged: (PetType value) {
                  setState(() { widget.pet.setPetType(value); _typeRadioValidationError = false; });
                },
              ),
            ),
            Expanded(
              child: RadioListTile(
                title: const Text("Gato"),
                value: PetType.cat,
                groupValue: widget.pet.petType,
                onChanged: (PetType value) {
                  setState(() { widget.pet.setPetType(value); _typeRadioValidationError = false; });
                },
              ),
            ),
          ],
        ),

        Visibility(
          visible: _typeRadioValidationError,
          child: Text(_typeRadioValidationMsg, style: TextStyle(color: Colors.red), textAlign: TextAlign.center,),
        ),
      ],
    );
  }

  Widget makeFormSex() {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text("Sexo do pet:"),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: RadioListTile(
                title: const Text("Masculino"),
                value: Sex.masc,
                groupValue: widget.pet.sex,
                onChanged: (Sex value) {
                  setState(() { widget.pet.setSex(value); _sexRadioValidationError = false; });
                },
              ),
            ),
            Expanded(
              child: RadioListTile(
                title: const Text("Feminino"),
                value: Sex.fem,
                groupValue: widget.pet.sex,
                onChanged: (Sex value) {
                  setState(() { widget.pet.setSex(value); _sexRadioValidationError = false; });
                },
              ),
            ),
          ],
        ),

        Visibility(
          visible: _sexRadioValidationError,
          child: Text(_sexRadioValidationMsg, style: TextStyle(color: Colors.red), textAlign: TextAlign.center,),
        ),
      ],
    );
  }

  Widget makeFormnBreed() {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text("Raça:"),
          onTap: (){
            _breedFocusNode.requestFocus();
          },
        ),
        ListTile(
          title: TextFormField(
            textCapitalization: TextCapitalization.sentences,
            enableSuggestions: true,
            focusNode: _breedFocusNode,
            controller: _breedController,
            decoration: InputDecoration(
                hintText: 'Deixe vazio se for vira-lata'
            ),
          ),
        ),
      ],
    );
  }

  Widget makeFormButtons() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: ListTile(
                title: RaisedButton(
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                  child: Text('Cancelar', style: TextStyle(color: Colors.red),),
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                title: RaisedButton(
                  onPressed: _savePet,
                  child: Text('Próximo'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (_newPet) ? Text("Adicionar um PET") : Text("Editar Pet"),
      ),
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView (
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                makeFormName(),

                makeFormPetType(),

                makeFormSex(),

                makeFormnBreed(),

                SizedBox(height: 50),

                makeFormButtons(),

              ],
            ),
          ),
        )

      )

    );
  }

}