import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PharmacyModel> _pharmacy = [];

  void getDataPharmacy() async {
    _pharmacy = await WeatherService().getPharmacyData();
    setState(() {});
  }

  @override
  void initState() {
    getDataPharmacy();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.separated(
          itemCount: _pharmacy.length,
          itemBuilder: (context, index) {
            final PharmacyModel pharmacy = _pharmacy[index];
            return Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Image.network(
                    'https://www.forumistanbul.com.tr/media/image/eczane.jpg',
                    width: 100,
                    height: 100,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pharmacy.isim,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(pharmacy.adres, softWrap: true),
                        Text(pharmacy.ilce),
                        Text(pharmacy.telefon),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => Divider(),
        ),
      ),
    );
  }
}
