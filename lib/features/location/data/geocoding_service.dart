import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class GeocodingService {
  Future<String> getCityName(Position position) async {
    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    final place = placemarks.first;

    // 🔥 fallback sistemi
    return place.locality ??
        place.subAdministrativeArea ??
        place.administrativeArea ??
        "Istanbul";
  }
}