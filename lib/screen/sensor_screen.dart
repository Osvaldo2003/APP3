import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart'; // Asegúrate de tener esta importación

class SensorScreen extends StatefulWidget {
  const SensorScreen({super.key}); // Utilizando super.key

  @override
  SensorScreenState createState() => SensorScreenState(); // Clase pública
}

class SensorScreenState extends State<SensorScreen> { // Clase pública
  String _sensorData = "Datos del sensor no disponibles";

  @override
  void initState() {
    super.initState();
    // Escuchar los eventos del acelerómetro
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _sensorData =
            "Acelerómetro:\nX: ${event.x.toStringAsFixed(2)}\nY: ${event.y.toStringAsFixed(2)}\nZ: ${event.z.toStringAsFixed(2)}";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Datos del Sensor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Añadir relleno para mejorar el diseño
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _sensorData,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Agregar un botón para refrescar los datos del sensor (opcional)
              ElevatedButton(
                onPressed: () {
                  // Aquí puedes agregar lógica para refrescar o reiniciar datos
                  setState(() {
                    _sensorData = "Datos del sensor no disponibles"; // Resetear datos
                  });
                },
                child: const Text('Reiniciar Datos'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
