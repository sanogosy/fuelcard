import 'package:flutter/material.dart';
import 'package:fuelcard/main_screens/found_qr_code_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ReadQrCodeScreen extends StatefulWidget {
  const ReadQrCodeScreen({super.key});

  @override
  State<ReadQrCodeScreen> createState() => _ReadQrCodeScreenState();
}

class _ReadQrCodeScreenState extends State<ReadQrCodeScreen> {

  MobileScannerController cameraController = MobileScannerController();
  bool _screenOpened = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mobile Scanner"),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state as TorchState) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state as CameraFacing) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: _foundBarcode,
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(title: const Text('QR Scanner')),
    //   body: SizedBox(
    //     height: 400,
    //     child: MobileScanner(
    //       onDetect: (capture) {
    //         if(capture.image != null){
    //
    //         }
    //         else {
    //           final List<Barcode> barcodes = capture.barcodes;
    //           for (final barcode in barcodes) {
    //             print(barcode.rawValue ?? "No Data found in QR");
    //           }
    //         }
    //       }
    //     ),
    //   ),
    // );

  }

  Future<String> getResultCode(BarcodeCapture capture) async {
    String value = '';
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      print("Data in QR");
      print(barcode.rawValue ?? "No Data found in QR");
      value = barcode.rawValue ?? "No Data found in QR";
    }

    return value;
  }

  void _foundBarcode(BarcodeCapture capture) async {
    /// open screen
    if (!_screenOpened) {
      // final String code = barcode.rawValue ?? "---";
      // final List<Barcode> barcodes = capture.barcodes;
      String value = '';
      // debugPrint('>>>>>>>>> Barcode found! $barcodes');
      _screenOpened = true;
      value = await getResultCode(capture);
      Navigator.push(context, MaterialPageRoute(builder: (context) =>
          FoundQrCodeScreen(screenClosed: _screenWasClosed, value: value),));
    }
  }

  void _screenWasClosed() {
    _screenOpened = false;
  }
}
