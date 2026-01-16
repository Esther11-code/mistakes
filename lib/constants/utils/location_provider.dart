import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class LocationProvider {
  factory LocationProvider() => _instance;
  LocationProvider._();
  static final LocationProvider _instance = LocationProvider._();

  Stream<Position> get positionStream => _positionStreamController.stream;
  final _positionStreamController = StreamController<Position>.broadcast();
  StreamSubscription<Position>? _positionSubscription;

  Future<Position?> getCurrentLocation() async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) return null;
    return Geolocator.getCurrentPosition();
  }

  Future<void> startTracking() async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) return;

    final settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionSubscription?.cancel();
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: settings,
    ).listen(
      _positionStreamController.safeAdd,
      onError: _positionStreamController.safeAddError,
    );
  }

  void stopTracking() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  Future<bool> _handlePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return switch (permission) {
      LocationPermission.denied || LocationPermission.deniedForever => false,
      _ => true,
    };
  }
}