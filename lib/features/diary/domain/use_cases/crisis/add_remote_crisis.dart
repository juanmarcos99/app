import 'package:app/features/diary/diary.dart';

class AddRemoteCrisis {
  final CrisisRepository repository;

  AddRemoteCrisis(this.repository);

  Future<void> call(Crisis crisis) async {
    return await repository.addRemoteCrisis(crisis);
  }
}
