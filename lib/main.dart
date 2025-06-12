import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Konversi Suhu',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const KonversiSuhuPage(),
    );
  }
}

class KonversiSuhuPage extends StatefulWidget {
  const KonversiSuhuPage({super.key});

  @override
  State<KonversiSuhuPage> createState() => _KonversiSuhuPageState();
}

class _KonversiSuhuPageState extends State<KonversiSuhuPage> {
  final TextEditingController _controller = TextEditingController();
  String _from = "Celcius";
  String _to = "Kelvin";
  String _result = "";

  final List<String> _units = ["Celcius", "Fahrenheit", "Kelvin", "Reamur"];

  void _convert() {
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Masukkan angka terlebih dahulu")),
      );
      return;
    }

    double? input = double.tryParse(_controller.text);
    if (input == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Input tidak valid. Harus berupa angka.")),
      );
      return;
    }

    double output = input;

    if (_from == _to) {
      output = input;
    } else {
      // Konversi ke Celsius sebagai perantara
      double celsius;

      switch (_from) {
        case "Celcius":
          celsius = input;
          break;
        case "Fahrenheit":
          celsius = (input - 32) * 5 / 9;
          break;
        case "Kelvin":
          celsius = input - 273.15;
          break;
        case "Reamur":
          celsius = input * 5 / 4;
          break;
        default:
          celsius = input;
      }

      // Konversi dari Celsius ke tujuan
      switch (_to) {
        case "Celcius":
          output = celsius;
          break;
        case "Fahrenheit":
          output = celsius * 9 / 5 + 32;
          break;
        case "Kelvin":
          output = celsius + 273.15;
          break;
        case "Reamur":
          output = celsius * 4 / 5;
          break;
      }
    }

    setState(() {
      _result = output.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Anya image top left
          Positioned(
            top: 20,
            left: 20,
            child: Image.asset(
              'assets/anya_top.png',
              width: 60,
            ),
          ),

          // Anya image bottom right
          Positioned(
            bottom: 20,
            right: 20,
            child: Image.asset(
              'assets/anya_bottom.png',
              width: 60,
            ),
          ),

          // Main content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: const Text(
                      "Konversi Suhu",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.0),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^[\d.-]+$'))
                          ],
                          decoration: InputDecoration(
                            labelText: "Masukkan Angka",
                            labelStyle: const TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: _from,
                          dropdownColor: Colors.white.withOpacity(0.9),
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: "Pilih Suhu",
                            labelStyle: const TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                          ),
                          items: _units
                              .map((e) =>
                              DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              _from = val!;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: _to,
                          dropdownColor: Colors.white.withOpacity(0.9),
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: "Konversi ke?",
                            labelStyle: const TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                          ),
                          items: _units
                              .map((e) =>
                              DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              _to = val!;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _convert,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.pink,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Konversi"),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(12),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.pinkAccent, width: 1.5),
                          ),
                          child: Text(
                            "Hasil: $_result",
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
