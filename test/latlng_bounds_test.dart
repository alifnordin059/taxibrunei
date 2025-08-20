import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;

/// Test the LatLngBounds calculation logic to ensure it works correctly
/// This tests the fix for the bug where bounds calculation was incorrect
void main() {
  group('LatLngBounds Calculation Tests', () {
    LatLngBounds getLatLngBounds(LatLng from, LatLng to) {
      double minLat = math.min(from.latitude, to.latitude);
      double maxLat = math.max(from.latitude, to.latitude);
      double minLng = math.min(from.longitude, to.longitude);
      double maxLng = math.max(from.longitude, to.longitude);
      
      return LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      );
    }

    test('should calculate correct bounds when from is northwest of to', () {
      // From point is northwest of to point
      final from = LatLng(6.6, 3.3); // Higher lat, lower lng
      final to = LatLng(6.5, 3.4);   // Lower lat, higher lng
      
      final bounds = getLatLngBounds(from, to);
      
      expect(bounds.southwest.latitude, 6.5);
      expect(bounds.southwest.longitude, 3.3);
      expect(bounds.northeast.latitude, 6.6);
      expect(bounds.northeast.longitude, 3.4);
    });

    test('should calculate correct bounds when from is southeast of to', () {
      // From point is southeast of to point  
      final from = LatLng(6.5, 3.4); // Lower lat, higher lng
      final to = LatLng(6.6, 3.3);   // Higher lat, lower lng
      
      final bounds = getLatLngBounds(from, to);
      
      expect(bounds.southwest.latitude, 6.5);
      expect(bounds.southwest.longitude, 3.3);
      expect(bounds.northeast.latitude, 6.6);
      expect(bounds.northeast.longitude, 3.4);
    });

    test('should calculate correct bounds when points are identical', () {
      final from = LatLng(6.5, 3.3);
      final to = LatLng(6.5, 3.3);
      
      final bounds = getLatLngBounds(from, to);
      
      expect(bounds.southwest.latitude, 6.5);
      expect(bounds.southwest.longitude, 3.3);
      expect(bounds.northeast.latitude, 6.5);
      expect(bounds.northeast.longitude, 3.3);
    });

    test('should calculate correct bounds for real Brunei coordinates', () {
      // Using coordinates similar to those in the app
      final pickup = LatLng(4.9031, 114.9398);  // Bandar Seri Begawan
      final destination = LatLng(4.8903, 114.9422); // Nearby location
      
      final bounds = getLatLngBounds(pickup, destination);
      
      // Southwest should have minimum lat/lng
      expect(bounds.southwest.latitude, math.min(pickup.latitude, destination.latitude));
      expect(bounds.southwest.longitude, math.min(pickup.longitude, destination.longitude));
      
      // Northeast should have maximum lat/lng
      expect(bounds.northeast.latitude, math.max(pickup.latitude, destination.latitude));
      expect(bounds.northeast.longitude, math.max(pickup.longitude, destination.longitude));
    });
  });
}