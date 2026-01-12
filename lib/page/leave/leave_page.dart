import 'package:app_absensi/page/main_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeavePage extends StatefulWidget {
  const LeavePage({super.key});

  @override
  State<LeavePage> createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  final controllerName = TextEditingController();
  final fromController = TextEditingController();
  final toController = TextEditingController();

  String dropValueCategories = "Pilih:";
  final List<String> categoriesList = [
    "Pilih:",
    "Izin",
    "Sakit",
  ];

  final CollectionReference dataCollection =
  FirebaseFirestore.instance.collection('izin');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Menu Pengajuan Izin",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: const EdgeInsets.all(12),
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Container(
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.pinkAccent,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: const Center(
                  child: Text(
                    "Isi Form Sesuai Pengajuan",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              // NAMA
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: controllerName,
                  decoration: InputDecoration(
                    labelText: "Nama",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),

              // DROPDOWN
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.pinkAccent),
                  ),
                  child: DropdownButton<String>(
                    value: dropValueCategories,
                    isExpanded: true,
                    underline: const SizedBox(),
                    icon: const Icon(Icons.arrow_drop_down),
                    onChanged: (String? value) {
                      setState(() {
                        dropValueCategories = value!;
                      });
                    },
                    items: categoriesList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // FROM - UNTIL
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: fromController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: "From",
                        ),
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            fromController.text =
                                DateFormat('dd/MM/yyyy').format(picked);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: toController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: "Until",
                        ),
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            toController.text =
                                DateFormat('dd/MM/yyyy').format(picked);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // BUTTON
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: size.width,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () {
                      if (controllerName.text.isEmpty ||
                          dropValueCategories == "Pilih:" ||
                          fromController.text.isEmpty ||
                          toController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Data tidak boleh kosong"),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      } else {
                        submitAbsen(
                          controllerName.text,
                          dropValueCategories,
                          fromController.text,
                          toController.text,
                        );
                      }
                    },
                    child: const Text(
                      "Ajukan Sekarang",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // LOADER
  void showLoaderDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("Mohon tunggu...")
          ],
        ),
      ),
    );
  }

  // SUBMIT FIRESTORE
  Future<void> submitAbsen(
      String nama, String ket, String from, String until) async {
    showLoaderDialog();

    try {
      await dataCollection.add({
        'nama': nama,
        'keterangan': ket,
        'tanggal': '$from - $until',
        'createdAt': Timestamp.now(),
      });

      Navigator.pop(context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const MainPage()));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pengajuan berhasil"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}
