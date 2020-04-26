import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../models/pet.dart';
import 'preview_screen.dart';


class CameraScreen extends StatefulWidget {
  final Pet pet;
  CameraScreen ({ Key key, this.pet }): super(key: key);

  @override
  State<StatefulWidget> createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  CameraController _controller;
  List<CameraDescription> _cameras;
  int _selectedCameraIdx;
  //String _imagePath;


  @override
  void initState() {
    super.initState();
    availableCameras().then((availableCameras) {

      _cameras = availableCameras;
      if (_cameras.length > 0) {
        setState(() {
          _selectedCameraIdx = 0;
        });

        _initCameraController(_cameras[_selectedCameraIdx]).then((void v) {});
      }else{
        print("No camera available");
      }
    }).catchError((err) {
      print('Error: $err.code\nError Message: $err.message');
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tire uma foto da face do bicho"),
      ),
      body: Container(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: _cameraPreviewWidget(),
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _cameraTogglesRowWidget(),
                  _captureControlRowWidget(context),
                  Spacer()
                ],
              ),
              SizedBox(height: 20.0)
            ],
          ),
        ),
      ),
    );
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (_controller != null) {
      await _controller.dispose();
    }

    _controller = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (_controller.value.hasError) {
        print('Camera error ${_controller.value.errorDescription}');
      }
    });

    try {
      await _controller.initialize();
    } on CameraException catch (e) {
      print(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  Widget _cameraPreviewWidget() {
    if (_controller == null || !_controller.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: CameraPreview(_controller),
    );
  }

  /// Display the control bar with buttons to take pictures
  Widget _captureControlRowWidget(context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            FloatingActionButton(
                child: Icon(Icons.camera),
                backgroundColor: Colors.blueGrey,
                onPressed: () {
                  _onCapturePressed(context);
                })
          ],
        ),
      ),
    );
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget() {
    if (_cameras == null || _cameras.isEmpty) {
      return Spacer();
    }

    CameraDescription selectedCamera = _cameras[_selectedCameraIdx];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: FlatButton.icon(
            onPressed: _onSwitchCamera,
            icon: Icon(_getCameraLensIcon(lensDirection)),
            label: Text(
                "${lensDirection.toString().substring(lensDirection.toString().indexOf('.') + 1)}")),
      ),
    );
  }

  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        return Icons.device_unknown;
    }
  }

  void _onSwitchCamera() {
    _selectedCameraIdx = _selectedCameraIdx < _cameras.length - 1 ? _selectedCameraIdx + 1 : 0;
    CameraDescription selectedCamera = _cameras[_selectedCameraIdx];
    _initCameraController(selectedCamera);
  }

  void _onCapturePressed(context) async {
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
      // Attempt to take a picture and log where it's been saved
      final path = join(
        // In this example, store the picture in the temp directory. Find
        // the temp directory using the `path_provider` plugin.
        (await getTemporaryDirectory()).path, '${DateTime.now()}.png',);
      print(path);
      await _controller.takePicture(path);

      // If the picture was taken, display it on a new screen
      var result = Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewImageScreen(imagePath: path, pet: widget.pet),
        ),
      );

      result.then((res){
        print("res: $res");
        if (res is String) {
          Navigator.pop(context, res);
        }
      });

    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }
}


