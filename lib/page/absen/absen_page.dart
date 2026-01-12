import 'dart:io';

import 'package:app_absensi/page/absen/camera_page.dart';
import 'package:app_absensi/page/main_page.dart';
import "package:camera/camera.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import "package:geocoding/geocoding.dart";
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class AbsenPage extends StatefulWidget {
  final XFile? image;

  const AbsenPage({super.key, this.image});

  @override
  State<AbsenPage> createState() => _AbsenPageState(this.image);
}

class _AbsenPageState extends State<AbsenPage> {
  _AbsenPageState(this.image);

  // ==============================
  // VARIABEL UTAMA
  // ==============================
  XFile? image;
  String strAlamat = "";
  String strDate = "";
  String strTime = "";
  String strDateTime = "";
  String strStatus = "Absen Masuk";

  /// jenis: absen | izin | sakit
  String jenisAbsen = "absen";

  bool isLoading = false;
  double dLat = 0.0, dLong = 0.0;
  int dateHours = 0, dateMinutes = 0;

  final controllerName = TextEditingController();

  final CollectionReference dataCollection =
  FirebaseFirestore.instance.collection('absensi');

  /// 📍 LOKASI KAMPUS
  final double campusLat = -5.178753;
  final double campusLong = 119.439041;
  final double campusRadius = 150; // meter

  // ==============================
  // INIT
  // ==============================
  @override
  void initState() {
    super.initState();
    handleLocationPermission();
    setDateTime();
    setStatusAbsen();

    if (image != null) {
      isLoading = true;
      getGeoLocationPosition();
    }
  }

  // ==============================
  // UI
  // ==============================
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.pinkAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Menu Absensi",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: const EdgeInsets.all(10),
          elevation: 5,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              // ==============================
              // FOTO
              // ==============================
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const CameraAbsenPage()),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  height: 150,
                  width: size.width,
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(10),
                    dashPattern: const [5, 5],
                    color: Colors.pinkAccent,
                    child: Center(
                      child: image != null
                          ? Image.file(File(image!.path))
                          : const Icon(Icons.camera_alt,
                          size: 40, color: Colors.pinkAccent),
                    ),
                  ),
                ),
              ),

              // ==============================
              // NAMA
              // ==============================
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: controllerName,
                  decoration: const InputDecoration(
                    labelText: "Nama",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              // ==============================
              // LOKASI
              // ==============================
              Padding(
                padding: const EdgeInsets.all(10),
                child: isLoading
                    ? const CircularProgressIndicator(
                    color: Colors.pinkAccent)
                    : TextField(
                  enabled: false,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: strAlamat.isEmpty
                        ? "Lokasi belum didapat"
                        : strAlamat,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),

              // ==============================
              // BUTTON ABSEN
              // ==============================
              Container(
                margin: const EdgeInsets.all(20),
                width: size.width,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () {
                    if (image == null || controllerName.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Foto dan nama wajib diisi"),
                        backgroundColor: Colors.redAccent,
                      ));
                      return;
                    }

                    /// 🔐 CEK LOKASI HANYA UNTUK ABSEN
                    if (jenisAbsen == "absen" && !isInsideCampus()) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content:
                        Text("Anda tidak berada di lokasi kampus"),
                        backgroundColor: Colors.redAccent,
                      ));
                      return;
                    }

                    submitAbsen(
                      strAlamat,
                      controllerName.text,
                      strStatus,
                    );
                  },
                  child: const Text(
                    "Absen Sekarang",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // ==============================
  // CEK RADIUS KAMPUS
  // ==============================
  bool isInsideCampus() {
    double distance = Geolocator.distanceBetween(
      dLat,
      dLong,
      campusLat,
      campusLong,
    );
    return distance <= campusRadius;
  }

  // ==============================
  // LOCATION
  // ==============================
  Future<void> getGeoLocationPosition() async {
    Position position =
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      dLat = position.latitude;
      dLong = position.longitude;
      isLoading = false;
    });

    getAddressFromLongLat(position);
  }

  Future<void> getAddressFromLongLat(Position position) async {
    List<Placemark> placemarks =
    await placemarkFromCoordinates(
        position.latitude, position.longitude);

    Placemark place = placemarks.first;
    setState(() {
      strAlamat =
      "${place.street}, ${place.locality}, ${place.country}";
    });
  }

  // ==============================
  // PERMISSION
  // ==============================
  Future<bool> handleLocationPermission() async {
    LocationPermission permission =
    await Geolocator.requestPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  // ==============================
  // DATE TIME
  // ==============================
  void setDateTime() {
    DateTime now = DateTime.now();
    strDate = DateFormat('dd MMM yyyy').format(now);
    strTime = DateFormat('HH:mm:ss').format(now);
    strDateTime = "$strDate | $strTime";

    dateHours = now.hour;
    dateMinutes = now.minute;
  }

  // ==============================
  // STATUS ABSEN
  // ==============================
  void setStatusAbsen() {
    if (dateHours < 8 ||
        (dateHours == 8 && dateMinutes <= 30)) {
      strStatus = "Absen Masuk";
    } else if (dateHours < 18) {
      strStatus = "Absen Telat";
    } else {
      strStatus = "Absen Keluar";
    }
  }

  // ==============================
  // SUBMIT FIRESTORE
  // ==============================
  Future<void> submitAbsen(
      String alamat, String nama, String status) async {
    await dataCollection.add({
      'nama': nama,
      'alamat': alamat,
      'keterangan': status,
      'jenis': jenisAbsen,
      'datetime': strDateTime,
      'lat': dLat,
      'long': dLong,
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Absen berhasil"),
      backgroundColor: Colors.green,
    ));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainPage()),
    );
  }
}
