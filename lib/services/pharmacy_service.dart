import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/pharmacy_model.dart';

class WeatherService {
  Future<String> getLocation() async {
    // Kullanıcının konumu açık mı kontrol ettik
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Konum servisiniz kapalı");
    }

    // Kullanıcı konum izni vermiş mi kontrol ettik
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Konum izni vermemişse tekrar izin istedik
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Yine vermemişse hata döndürdük
        throw Exception("Konum izni vermelisiniz");
      }
    }

    // Kullanıcının pozisyonunu aldık
    final Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    // Kullanıcı pozisyonundan yerleşim noktasını bulduk
    final List<Placemark> placemark = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    // Şehrimizi yerleşim noktasından kaydettik
    final String? city = placemark[0].administrativeArea;

    if (city == null) throw Exception("Şehir bulunamadı");

    return city!;
  }

  Future getPharmacyData() async {
    final String city = await getLocation();
    final String url =
        'https://api.collectapi.com/health/dutyPharmacy?il=$city';

    const Map<String, dynamic> headers = {
      "authorization": "apikey 1hNfZWchn0OL9Eo6pB7oUS:34GR3PpQym66qNIj3QI0v6",
      "content-type": "application/json",
    };
    final dio = Dio();

    final response = await dio.get(url, options: Options(headers: headers));
    if (response.statusCode != 200) {
      return Future.error("Bir sorun oluştu");
    }
    final List list = response.data['result'];
    final List<PharmacyModel> pharmacyList = list
        .map((e) => PharmacyModel.fromJson(e))
        .toList();

    return pharmacyList;
  }
}
