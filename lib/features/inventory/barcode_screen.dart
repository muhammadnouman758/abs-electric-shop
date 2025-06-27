// features/inventory/barcode_scanner.dart
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerScreen extends StatefulWidget {
  final Function(String) onScan;

  BarcodeScannerScreen({required this.onScan});

  @override
  _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Barcode'),
        actions: [
          IconButton(
            icon: Icon(Icons.camera_alt_rounded),
            // icon: ValueListenableBuilder(
            //   valueListenable: cameraController.torchState,
            //   builder: (context, state, child) {
            //     switch (state) {
            //       case TorchState.off:
            //         return Icon(Icons.flash_off, color: Colors.grey);
            //       case TorchState.on:
            //         return Icon(Icons.flash_on, color: Colors.yellow);
            //     }
            //   },
            // ),
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            icon: Icon(Icons.camera),
            // icon: ValueListenableBuilder(
            //   valueListenable: cameraController.cameraFacingState,
            //   builder: (context, state, child) {
            //     switch (state) {
            //       case CameraFacing.front:
            //         return Icon(Icons.camera_front);
            //       case CameraFacing.back:
            //         return Icon(Icons.camera_rear);
            //     }
            //   },
            // ),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            if (barcode.rawValue != null) {
              widget.onScan(barcode.rawValue!);
              Navigator.pop(context);
              break;
            }
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}