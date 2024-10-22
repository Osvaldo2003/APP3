import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({Key? key}) : super(key: key);

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  String? qrCode;
  bool isScanned = false; 

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
                
                final List<Barcode> barcodes = barcodeCapture.barcodes;

                
                if (barcodes.isNotEmpty && !isScanned) {
                  final String code = barcodes.first.rawValue ?? "---";

                  setState(() {
                    qrCode = code;
                    isScanned = true; // Evita múltiples escaneos
                  });

                  
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              qrCode != null ? 'Código QR: $qrCode' : 'Escanea un código QR',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
