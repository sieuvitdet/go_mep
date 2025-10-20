import 'dart:io';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_mep_application/common/utils/constant.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class GpsUtils {
  GpsUtils._();

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Vui lòng bật định vị và thử lại');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Vui lòng cấp quyền định vị để tiếp tục');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Vui lòng cấp quyền định vị để tiếp tục');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  /// Show the location [destination] in google maps app
  // static Future<void> googleMapsLocation({required LatLng destination}) async {
  //   String googleUrl = 'https://www.google.com/maps/search/?api=1&query=${destination.latitude},${destination.longitude}';
  //   Uri googleUri = Uri.parse(googleUrl);

  //   if (await canLaunchUrl(googleUri)) {
  //     await launchUrl(googleUri, mode: LaunchMode.externalApplication);
  //   }
  // }
  static Future<LatLng> getCurrentLocation() async {
    return await determinePosition().then((value) => LatLng(value.latitude, value.longitude));
  }


  static Future<List<LatLng>> findDirection(LatLng departure, LatLng destination) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(departure.latitude, departure.longitude),
        destination: PointLatLng(destination.latitude, destination.longitude),
        mode: TravelMode.driving,
      ),
      googleApiKey: Constants.GG_API_KEY,
    );
    return result.points.map((e) => LatLng(e.latitude, e.longitude)).toList();
  }

  static Future<void> googleMapsDirection({LatLng? origin, required LatLng destination}) async {
    String appleUrl = 'https://maps.apple.com/?saddr=&daddr=${destination.latitude},${destination.longitude}&directionsmode=bicycling';
    String googleUrl = 'https://www.google.com/maps/dir/?api=1&origin=${await _getOrigin(origin)}&destination=${destination.latitude},${destination.longitude}&travelmode=Bicycling&mode=bicycling';

    Uri appleUri = Uri.parse(appleUrl);
    Uri googleUri = Uri.parse(googleUrl);

    if (Platform.isIOS) {
      if (await canLaunchUrl(googleUri)) {
        await launchUrl(googleUri, mode: LaunchMode.externalApplication);
      } else {
        if (await canLaunchUrl(appleUri)) {
          await launchUrl(appleUri, mode: LaunchMode.externalApplication);
        }
      }
    } else {
      if (await canLaunchUrl(googleUri)) {
        await launchUrl(googleUri, mode: LaunchMode.externalApplication);
      }
    }
  }

  static Future<String> _getOrigin(LatLng? origin) async {
    origin ??= await getCurrentLocation();
    return '${origin.latitude},${origin.longitude}';
  }

}