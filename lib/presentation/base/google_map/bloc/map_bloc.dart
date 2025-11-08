import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_mep_application/common/theme/assets.dart';
import 'package:go_mep_application/common/utils/custom_navigator.dart';
import 'package:go_mep_application/common/utils/gps_utils.dart';
import 'package:go_mep_application/common/widgets/widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

// States
enum MapMode { restaurant, taxi }

class MapState {
  final Set<Marker> markers;
  final String? selectedMarkerId;
  final MapMode mapMode;
  final RestaurantData? selectedRestaurant;
  final LatLng initialPosition;
  final List<RestaurantData> searchResults;
  final bool isSearching;

  MapState({
    required this.markers,
    this.selectedMarkerId,
    required this.mapMode,
    this.selectedRestaurant,
    required this.initialPosition,
    this.searchResults = const [],
    this.isSearching = false,
  });

  MapState copyWith({
    Set<Marker>? markers,
    String? selectedMarkerId,
    MapMode? mapMode,
    RestaurantData? selectedRestaurant,
    LatLng? initialPosition,
    List<RestaurantData>? searchResults,
    bool? isSearching,
    bool clearSelection = false,
  }) {
    return MapState(
      markers: markers ?? this.markers,
      selectedMarkerId: clearSelection ? null : (selectedMarkerId ?? this.selectedMarkerId),
      mapMode: mapMode ?? this.mapMode,
      selectedRestaurant: clearSelection ? null : (selectedRestaurant ?? this.selectedRestaurant),
      initialPosition: initialPosition ?? this.initialPosition,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}

// Restaurant Data Model
class RestaurantData {
  final String id;
  final String name;
  final LatLng position;
  final String openingHours;
  final bool isOpen;
  final String phone;
  final String address;
  final String priceRange;
  final double rating;
  final double distance;
  final bool styleFood;

  RestaurantData({
    required this.id,
    required this.name,
    required this.position,
    required this.openingHours,
    required this.isOpen,
    required this.phone,
    required this.address,
    required this.priceRange,
    required this.rating,
    required this.distance,
    required this.styleFood,
  });
}

// Stream-based Controller
class MapBloc {
  final BuildContext context;
  final BehaviorSubject<MapState> _stateController = BehaviorSubject<MapState>.seeded(
    MapState(
      markers: {},
      mapMode: MapMode.restaurant,
      initialPosition: const LatLng(10.762622, 106.660172), // Ho Chi Minh City center
    ),
  );

  // Search debounce controller
  final BehaviorSubject<String> _searchQueryController = BehaviorSubject<String>.seeded('');
  StreamSubscription<String>? _searchSubscription;

  Stream<MapState> get state$ => _stateController.stream;
  MapState get currentState => _stateController.value;
  GoogleMapController? mapController;

  MapBloc({required this.context}) {
    // Setup debounced search
    _searchSubscription = _searchQueryController
        .debounceTime(const Duration(milliseconds: 500))
        .listen((query) {
      _performSearch(query);
    });
  }

  void dispose() {
    _searchSubscription?.cancel();
    _searchQueryController.close();
    _stateController.close();
  }

  // Mock data for 50 restaurants
  static final List<RestaurantData> _mockRestaurants = [
    // District 7 cluster (southwest)
    RestaurantData(id: '1', name: 'Sườn cay', position: const LatLng(10.712622, 106.620172), openingHours: '6:00 - 22:00', isOpen: true, phone: '+84 854626548', address: '162 Đường Sáng Tạo, P. Tân Thuận Tây, Q.7', priceRange: '30.000-45.000', rating: 4.5, distance: 1.2,styleFood: true),
    RestaurantData(id: '2', name: 'Xá bì chả', position: const LatLng(10.714622, 106.612172), openingHours: '7:00 - 23:00', isOpen: true, phone: '+84 901234567', address: '45 Nguyễn Văn Linh, Q.7', priceRange: '25.000-40.000', rating: 4.2, distance: 0.8,styleFood: false),
    RestaurantData(id: '3', name: 'Nước miễn phí', position: const LatLng(10.760622, 106.658172), openingHours: '8:00 - 21:00', isOpen: true, phone: '+84 912345678', address: '78 Huỳnh Tấn Phát, Q.7', priceRange: '20.000-35.000', rating: 4.0, distance: 1.5,styleFood: true),
    RestaurantData(id: '4', name: 'Cơm tấm Hương Quê', position: const LatLng(10.733622, 106.656172), openingHours: '6:00 - 20:00', isOpen: true, phone: '+84 923456789', address: '123 Nguyễn Hữu Thọ, Q.7', priceRange: '35.000-50.000', rating: 4.7, distance: 2.1,styleFood: false),
    RestaurantData(id: '5', name: 'Rượu nho', position: const LatLng(10.766622, 106.644172), openingHours: '9:00 - 22:00', isOpen: false, phone: '+84 934567890', address: '56 Lê Văn Lương, Q.7', priceRange: '40.000-60.000', rating: 4.3, distance: 1.8,styleFood: true),
    RestaurantData(id: '6', name: 'Trà đá đây', position: const LatLng(10.765622, 106.645172), openingHours: '5:00 - 23:00', isOpen: true, phone: '+84 945678901', address: '89 Trần Xuân Soạn, Q.7', priceRange: '15.000-25.000', rating: 3.9, distance: 0.9,styleFood: false),
    RestaurantData(id: '7', name: 'Gà nướng lu', position: const LatLng(10.757622, 106.652172), openingHours: '10:00 - 22:00', isOpen: true, phone: '+84 956789012', address: '234 Nguyễn Thị Thập, Q.7', priceRange: '45.000-70.000', rating: 4.6, distance: 2.5,styleFood: true),
  ];

  Future<void> initializeMap() async {
    final markers = await _createMarkers(currentState.mapMode);
    _stateController.add(currentState.copyWith(markers: markers));
  }

  // Public method to trigger search
  void onSearchQueryChanged(String query) {
    _searchQueryController.add(query);
  }

  // Private method to perform the actual search
  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      _stateController.add(currentState.copyWith(
        searchResults: [],
        isSearching: false,
      ));
      return;
    }

    _stateController.add(currentState.copyWith(isSearching: true));

    // Search only in mock data
    final results = _mockRestaurants.where((restaurant) {
      final nameLower = restaurant.name.toLowerCase();
      final addressLower = restaurant.address.toLowerCase();
      final queryLower = query.toLowerCase();

      return nameLower.contains(queryLower) || addressLower.contains(queryLower);
    }).toList();

    _stateController.add(currentState.copyWith(
      searchResults: results,
      isSearching: false,
    ));
  }

  // Method to select restaurant from search results
  Future<void> selectRestaurantFromSearch(RestaurantData restaurant) async {
    // Close search
    _stateController.add(currentState.copyWith(
      searchResults: [],
      isSearching: false,
    ));

    // Select marker and animate to location
    await selectMarker(restaurant.id);
    animateToMarker(restaurant.position);
  }

  Future<void> selectMarker(String markerId) async {
    final restaurant = _mockRestaurants.firstWhere((r) => r.id == markerId);
    final markers = await _createMarkers(currentState.mapMode, selectedId: markerId);

    _stateController.add(currentState.copyWith(
      markers: markers,
      selectedMarkerId: markerId,
      selectedRestaurant: restaurant,
    ));
    showDetailRestaurantBottomSheet(currentState);
  }

   void animateToMarker(LatLng position) {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: 15.0,
        ),
      ),
    );
  }

  void showDetailRestaurantBottomSheet(MapState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ItemRestaurantBottomSheet(restaurant: state.selectedRestaurant!, onTap: (restaurant) {
          animateToMarker(restaurant.position);
        },
        onClearSelection: () {
          CustomNavigator.pop(context);
          clearSelection();
        },
        onDrawLineDirection: () {
          CustomNavigator.pop(context);
          clearSelection();
          GpsUtils.googleMapsDirection(destination: state.selectedRestaurant!.position);
        },
        ),
    );
  }

  Future<void> changeMapMode(MapMode mode) async {
    final markers = await _createMarkers(mode);
    _stateController.add(currentState.copyWith(
      mapMode: mode,
      markers: markers,
      clearSelection: true,
    ));
  }

  Future<void> clearSelection() async {
    final markers = await _createMarkers(currentState.mapMode);
    _stateController.add(currentState.copyWith(
      markers: markers,
      clearSelection: true,
    ));
  }

  Future<Set<Marker>> _createMarkers(MapMode mode, {String? selectedId}) async {
    final Set<Marker> markers = {};

    for (var restaurant in _mockRestaurants) {
      final isSelected = restaurant.id == selectedId;
      final icon = await createIconBitmap(isMarkerDrink: restaurant.styleFood,isSelected: isSelected );

      markers.add(
        Marker(
          markerId: MarkerId(restaurant.id),
          position: restaurant.position,
          icon: icon,
          onTap: () {
            selectMarker(restaurant.id);
          },
          anchor: const Offset(0.5, 0.5),
        ),
      );
    }

    return markers;
  }


  static Future<BitmapDescriptor> createIconBitmap({bool isMarkerDrink = false,bool isSelected = false}) async {
    return await BitmapDescriptor.asset(
       ImageConfiguration(
        devicePixelRatio: 2.5,
        size:isSelected ? Size(32, 32) : Size(28, 28),
      ),
      isMarkerDrink ? Assets.markerDrink : Assets.markerFood, 
    );
  }
}
