import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';

class SecondScreen extends StatefulWidget {
  final CameraDescription camera;
  SecondScreen(this.camera);
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  FlickManager flickManager;
  Offset position;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();

    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(
          "https://github.com/GeekyAnts/flick-video-player-demo-videos/blob/master/example/rio_from_above_compressed.mp4?raw=true"),
    );
    position = Offset(0.0, height - 20);
  }

  @override
  void dispose() {
    _controller.dispose();
    flickManager.dispose();
    super.dispose();
  }

  double top = 0;
  double left = 0;

  double width = 100.0, height = 100.0;

  @override
  Widget build(BuildContext context) {
    Orientation currentOrientation = MediaQuery.of(context).orientation;
    return Scaffold(
      // body: 
      // (currentOrientation == Orientation.landscape)
      //     ? Container(
      //         child: FlickVideoPlayer(
      //           flickManager: flickManager,
      //           preferredDeviceOrientation: [
      //             DeviceOrientation.landscapeLeft,
      //             DeviceOrientation.landscapeRight
      //           ],
      //         ),
      //       )
      //     :
           body: Stack(
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 2,
                        child: FlickVideoPlayer(flickManager: flickManager),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: position.dx,
                  top: position.dy - height + 20,
                  child: Draggable(
                    child: Container(
                      width: width,
                      height: height,
                      color: Colors.blue,
                      child: Center(
                        child: Text(
                          "Drag",
                          style: Theme.of(context).textTheme.headline,
                        ),
                      ),
                    ),
                    feedback: Container(
                      child: Center(
                        child: Text(
                          "Drag",
                          style: Theme.of(context).textTheme.headline,
                        ),
                      ),
                      color: Colors.red[800],
                      width: width,
                      height: height,
                    ),
                    onDraggableCanceled: (Velocity velocity, Offset offset) {
                      setState(() => position = offset);
                    },
                  ),
                ),
                Positioned(
                  left: position.dx,
                  top: position.dy - height + 20,
                  child: Draggable(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width / 2,
                      child: FutureBuilder<void>(
                        future: _initializeControllerFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            // If the Future is complete, display the preview.
                            return CameraPreview(_controller);
                          } else {
                            // Otherwise, display a loading indicator.
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                    feedback: Container(
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width / 2,
                      child: Opacity(
                        opacity: 0.5,
                        child: FutureBuilder<void>(
                          future: _initializeControllerFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              // If the Future is complete, display the preview.
                              return CameraPreview(_controller);
                            } else {
                              // Otherwise, display a loading indicator.
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                    ),
                    onDraggableCanceled: (Velocity velocity, Offset offset) {
                      setState(() => position = offset);
                    },
                  ),
                )
              ],
            ),
    );
  }
}
