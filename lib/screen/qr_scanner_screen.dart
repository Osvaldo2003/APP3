import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:screenshot/screenshot.dart';  // Para capturar el widget como imagen
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:url_launcher/url_launcher.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({Key? key}) : super(key: key);

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  String? qrCode;
  bool isScanned = false;  // Para evitar múltiples redirecciones
  final ScreenshotController screenshotController = ScreenshotController();  // Controlador para capturas

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escáner de Código QR'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: (barcodeCapture) async {
                // Obtener la lista de códigos escaneados
                final List<Barcode> barcodes = barcodeCapture.barcodes;

                // Asegurarse de que hay al menos un código escaneado
                if (barcodes.isNotEmpty && !isScanned) {
                  final String code = barcodes.first.rawValue ?? "---";

                  setState(() {
                    qrCode = code;
                    isScanned = true;  // Evita múltiples escaneos
                  });

                  // Intenta abrir la URL si el QR contiene un link
                  if (await canLaunch(code)) {
                    await launch(code);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Código escaneado: $code')),
                    );
                  }
                }
              },
            ),
          ),
          Screenshot(
            controller: screenshotController,  // Controlador para capturar
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                qrCode != null ? 'Código QR: $qrCode' : 'Escanea un código QR',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: qrCode != null ? _takeScreenshot : null,
            child: const Text('Guardar QR como imagen'),
          ),
        ],
      ),
    );
  }

  // Función para capturar el widget y guardar como imagen
  Future<void> _takeScreenshot() async {
    final directory = await getApplicationDocumentsDirectory();
    final String imagePath = '${directory.path}/qr_code_image.png';

    screenshotController.capture().then((Uint8List? image) {
      if (image != null) {
        File imageFile = File(imagePath);
        imageFile.writeAsBytes(image).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Imagen guardada en $imagePath')),
          );
        });
      }
    }).catchError((onError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar la imagen: $onError')),
      );
    });
  }
}
