
import 'http.dart';
import '../models/pet.dart';
import '../persistence/pet_persistence.dart';


void syncPets(List<Pet> pets) {
  // Sincronizando os pets
  for (Pet pet in pets) {
    // Se ainda não tiver cadastro no servidor
    syncPet(pet);
  }
}

void syncPet(Pet pet) {
  if (pet.id == null) {
    // Se já tiver sincronizado antes
    _newPet(pet);
  } else {
    _editPet(pet);
  }
}

int _newPet(Pet pet) {
  var res = HTTPSingleton().savePet(pet);
  res.then((int val) {
    pet.id = val;
    print("Pet id: ${pet.id}, status: $val");
    updatePet(pet);

    // TODO: Lidar com os status codes

  });

  return 0;
}

int _editPet(Pet pet) {
  var res = HTTPSingleton().editPet(pet);

  res.then((int val) {
    print("Pet id: ${pet.id}, status: $val");
    updatePet(pet);

    // TODO: Lidar com os status codes

  });

  return 0;
}