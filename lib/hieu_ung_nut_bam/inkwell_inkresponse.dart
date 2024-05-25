import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('InkWell and InkResponse Example')),
        body: const GestureDetectorWidget(),
      ),
    );
  }
}

class GestureDetectorWidget extends StatefulWidget {
  const GestureDetectorWidget({super.key});

  @override
  _GestureDetectorWidgetState createState() => _GestureDetectorWidgetState();
}

class _GestureDetectorWidgetState extends State<GestureDetectorWidget> {
  Offset _startLastOffset = Offset.zero;
  Offset _lastOffset = Offset.zero;
  Offset _currentOffset = Offset.zero;
  double _lastScale = 1.0;
  double _currentScale = 1.0;

  void _onScaleStart(ScaleStartDetails details) {
    _startLastOffset = details.focalPoint;
    _lastOffset = _currentOffset;
    _lastScale = _currentScale;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      if (details.scale != 1.0) {
        double currentScale = _lastScale * details.scale;
        if (currentScale < 0.5) currentScale = 0.5;
        _currentScale = currentScale;
      } else if (details.scale == 1.0) {
        Offset offsetAdjustedForScale = (_startLastOffset - _lastOffset) / _lastScale;
        _currentOffset = details.focalPoint - (offsetAdjustedForScale * _currentScale);
      }
    });
  }

  void _onDoubleTap() {
    setState(() {
      double currentScale = _lastScale * 2.0;
      if (currentScale > 16.0) {
        currentScale = 1.0;
        _resetToDefaultValues();
      }
      _lastScale = currentScale;
      _currentScale = currentScale;
    });
  }

  void _onLongPress() {
    setState(() {
      _resetToDefaultValues();
    });
  }

  void _resetToDefaultValues() {
    _startLastOffset = Offset.zero;
    _lastOffset = Offset.zero;
    _currentOffset = Offset.zero;
    _lastScale = 1.0;
    _currentScale = 1.0;
  }

  void _setScaleSmall() {
    setState(() {
      _currentScale = 0.5;
    });
  }

  void _setScaleBig() {
    setState(() {
      _currentScale = 16.0;
    });
  }

  Widget _transformMatrix4() {
    // Placeholder for the actual transformation logic
    return Container();
  }

  Widget _positionedStatusBar(BuildContext context) {
    // Placeholder for the actual status bar widget
    return Positioned(
      top: 0,
      width: MediaQuery.of(context).size.width,
      child: Container(
        height: 50,
        color: Colors.red,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return GestureDetector(
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _transformMatrix4(),
          _positionedStatusBar(context),
          _positionedInkWellAndInkResponse(context),
        ],
      ),
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      onDoubleTap: _onDoubleTap,
      onLongPress: _onLongPress,
    );
  }

  Positioned _positionedInkWellAndInkResponse(BuildContext context) {
    return Positioned(
      top: 50.0,
      width: MediaQuery.of(context).size.width,
      child: Container(
        color: Colors.white54,
        height: 56.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            InkWell(
              child: Container(
                height: 48.0,
                width: 128.0,
                color: Colors.black12,
                child: const Icon(
                  Icons.touch_app,
                  size: 32.0,
                ),
              ),
              splashColor: Colors.lightGreenAccent,
              highlightColor: Colors.lightBlueAccent,
              onTap: _setScaleSmall,
              onDoubleTap: _setScaleBig,
              onLongPress: _onLongPress,
            ),
            InkResponse(
              child: Container(
                height: 48.0,
                width: 128.0,
                color: Colors.black12,
                child: const Icon(
                  Icons.touch_app,
                  size: 32.0,
                ),
              ),
              splashColor: Colors.lightGreenAccent,
              highlightColor: Colors.lightBlueAccent,
              onTap: _setScaleSmall,
              onDoubleTap: _setScaleBig,
              onLongPress: _onLongPress,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }
}
