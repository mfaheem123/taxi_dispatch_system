
import '../../../Model/zone_model.dart';

class ZoneController {
  Zone zone = Zone();

  void updateBase(bool value) {
    zone.base = value;
  }

  void updateName(String value) {
    zone.name = value;
  }

  void updateShortName(String value) {
    zone.shortName = value;
  }

  void updateType(String value) {
    zone.type = value;
  }

  void updateCategory(String value) {
    zone.category = value;
  }

  void clear() {
    zone = Zone();
  }

  void save() {
    print(
      "Zone Saved => ${zone.name}, ${zone.shortName}, ${zone.type}, ${zone.category}, Base: ${zone.base}",
    );
  }
}
