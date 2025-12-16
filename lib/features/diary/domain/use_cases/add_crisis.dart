import '../../diary.dart';

class AddCrisis {
  final CrisisRepository repository;

  AddCrisis(this.repository);

  Future<void> call(Crisis crisis) async {
    await repository.addCrisis(crisis);
  }
}
