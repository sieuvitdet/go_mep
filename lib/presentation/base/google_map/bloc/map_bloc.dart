import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_mep_application/common/theme/assets.dart';
import 'package:go_mep_application/common/theme/globals/globals.dart';
import 'package:go_mep_application/common/utils/custom_navigator.dart';
import 'package:go_mep_application/common/utils/gps_utils.dart';
import 'package:go_mep_application/common/widgets/widget.dart';
import 'package:go_mep_application/data/model/res/places_search_res_model.dart';
import 'package:go_mep_application/data/model/res/temporary_report_marker_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rxdart/rxdart.dart';

// States
enum MapMode { restaurant, taxi }

class MapState {
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final String? selectedMarkerId;
  final MapMode mapMode;
  final RestaurantData? selectedRestaurant;
  final LatLng initialPosition;
  final List<RestaurantData> searchResults;
  final bool isSearching;
  final bool isLoading;

  MapState({
    required this.markers,
    this.polylines = const {},
    this.selectedMarkerId,
    required this.mapMode,
    this.selectedRestaurant,
    required this.initialPosition,
    this.searchResults = const [],
    this.isSearching = false,
    this.isLoading = false,
  });

  MapState copyWith({
    Set<Marker>? markers,
    Set<Polyline>? polylines,
    String? selectedMarkerId,
    MapMode? mapMode,
    RestaurantData? selectedRestaurant,
    LatLng? initialPosition,
    List<RestaurantData>? searchResults,
    bool? isSearching,
    bool? isLoading,
    bool clearSelection = false,
  }) {
    return MapState(
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
      selectedMarkerId: clearSelection ? null : (selectedMarkerId ?? this.selectedMarkerId),
      mapMode: mapMode ?? this.mapMode,
      selectedRestaurant: clearSelection ? null : (selectedRestaurant ?? this.selectedRestaurant),
      initialPosition: initialPosition ?? this.initialPosition,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
      isLoading: isLoading ?? this.isLoading,
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

  /// Factory method to convert from PlaceResultModel to RestaurantData
  factory RestaurantData.fromPlaceModel(PlaceResultModel place, {double distance = 0.0}) {
    return RestaurantData(
      id: place.id ?? '',
      name: place.name ?? 'Unknown',
      position: LatLng(
        place.location?.lat ?? 0.0,
        place.location?.lng ?? 0.0,
      ),
      openingHours: place.openingHours ?? 'N/A',
      isOpen: place.isOpen ?? false,
      phone: place.phone ?? 'N/A',
      address: place.formattedAddress ?? place.address ?? 'N/A',
      priceRange: _parsePriceLevel(place.priceLevel),
      rating: place.rating ?? 0.0,
      distance: distance,
      styleFood: _isFood(place.types),
    );
  }

  static String _parsePriceLevel(String? priceLevel) {
    if (priceLevel == null) return 'N/A';
    switch (priceLevel.toLowerCase()) {
      case 'inexpensive':
        return '20.000-40.000';
      case 'moderate':
        return '40.000-80.000';
      case 'expensive':
        return '80.000-150.000';
      case 'very_expensive':
        return '150.000+';
      default:
        return '30.000-60.000';
    }
  }

  static bool _isFood(List<String>? types) {
    if (types == null) return true;
    // If contains 'bar', 'cafe', 'night_club' -> drink icon
    final drinkTypes = ['bar', 'cafe', 'night_club', 'liquor_store'];
    return !types.any((type) => drinkTypes.contains(type.toLowerCase()));
  }
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

  // Cached restaurants list
  List<RestaurantData> _allRestaurants = [];

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

  /// Initialize map with cached places and waterlogging routes
  Future<void> initializeMap() async {
    _stateController.add(currentState.copyWith(isLoading: true));

    try {
      // Load from cache first
      await _loadPlacesFromCache();

      // Load waterlogging and traffic jam routes and create polylines
      final waterloggingPolylines = await _loadWaterloggingPolylines();
      final trafficJamPolylines = await _loadTrafficJamPolylines();

      // Combine all polylines
      final polylines = <Polyline>{
        ...waterloggingPolylines,
        ...trafficJamPolylines,
      };

      // Create markers (including temporary report markers)
      final markers = await _createMarkers(currentState.mapMode);
      final temporaryMarkers = await _loadTemporaryReportMarkers();

      final allMarkers = <Marker>{
        ...markers,
        ...temporaryMarkers,
      };

      _stateController.add(currentState.copyWith(
        markers: allMarkers,
        polylines: polylines,
        isLoading: false,
      ));

      // Fetch fresh data in background (if needed)
      _refreshPlacesInBackground();
    } catch (e) {
      debugPrint('❌ Error initializing map: $e');
      _stateController.add(currentState.copyWith(isLoading: false));
    }
  }

  /// Load places from cache
  Future<void> _loadPlacesFromCache() async {
    final repository = Globals.placesRepository;
    if (repository == null) {
      debugPrint('❌ PlacesRepository not initialized');
      return;
    }

    try {
      final cachedPlaces = await repository.getAllCachedPlaces();
      _allRestaurants = cachedPlaces
          .map((place) => RestaurantData.fromPlaceModel(place))
          .toList();

      debugPrint('📱 Loaded ${_allRestaurants.length} places from cache');
    } catch (e) {
      debugPrint('❌ Error loading places from cache: $e');
    }
  }

  /// Refresh places in background (don't block UI)
  Future<void> _refreshPlacesInBackground() async {
    final repository = Globals.placesRepository;
    if (repository == null) return;

    try {
      // Search for popular place types in Ho Chi Minh City
      final result = await repository.searchPlaces(
        context: context,
        query: 'restaurant',
        latitude: currentState.initialPosition.latitude,
        longitude: currentState.initialPosition.longitude,
        radius: 5000, // 5km radius
      );

      if (result != null && result.results != null && result.results!.isNotEmpty) {
        _allRestaurants = result.results!
            .map((place) => RestaurantData.fromPlaceModel(place))
            .toList();

        // Update markers
        final markers = await _createMarkers(currentState.mapMode);
        _stateController.add(currentState.copyWith(markers: markers));

        debugPrint('✅ Refreshed ${_allRestaurants.length} places from API');
      }
    } catch (e) {
      debugPrint('❌ Error refreshing places: $e');
    }
  }

  // Public method to trigger search
  void onSearchQueryChanged(String query) {
    _searchQueryController.add(query);
  }

  /// Perform search with cache-first strategy
  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      _stateController.add(currentState.copyWith(
        searchResults: [],
        isSearching: false,
      ));
      return;
    }

    _stateController.add(currentState.copyWith(isSearching: true));

    final repository = Globals.placesRepository;

    try {
      // Step 1: Search in cached data first
      final cachedResults = _allRestaurants.where((restaurant) {
        final nameLower = restaurant.name.toLowerCase();
        final addressLower = restaurant.address.toLowerCase();
        final queryLower = query.toLowerCase();

        return nameLower.contains(queryLower) || addressLower.contains(queryLower);
      }).toList();

      // Show cached results immediately
      if (cachedResults.isNotEmpty) {
        _stateController.add(currentState.copyWith(
          searchResults: cachedResults,
          isSearching: false,
        ));
      }

      // Step 2: Search via API (if repository available)
      if (repository != null) {
        final result = await repository.searchPlaces(
          context: context,
          query: query,
          latitude: currentState.initialPosition.latitude,
          longitude: currentState.initialPosition.longitude,
          radius: 5000,
        );

        if (result != null && result.results != null) {
          final apiResults = result.results!
              .map((place) => RestaurantData.fromPlaceModel(place))
              .toList();

          // Update _allRestaurants with search results to show markers on map
          _allRestaurants = apiResults;
          final markers = await _createMarkers(currentState.mapMode);
          final temporaryMarkers = await _loadTemporaryReportMarkers();

          // Update with API results and markers
          _stateController.add(currentState.copyWith(
            searchResults: apiResults,
            markers: {...markers, ...temporaryMarkers},
            isSearching: false,
          ));

          debugPrint('✅ Found ${apiResults.length} places for "$query"');
        }
      } else {
        // No repository, use cached results only
        _stateController.add(currentState.copyWith(
          searchResults: cachedResults,
          isSearching: false,
        ));
      }
    } catch (e) {
      debugPrint('❌ Error searching places: $e');

      // On error, use cached results
      final cachedResults = _allRestaurants.where((restaurant) {
        final nameLower = restaurant.name.toLowerCase();
        final addressLower = restaurant.address.toLowerCase();
        final queryLower = query.toLowerCase();

        return nameLower.contains(queryLower) || addressLower.contains(queryLower);
      }).toList();

      _stateController.add(currentState.copyWith(
        searchResults: cachedResults,
        isSearching: false,
      ));
    }
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
    final restaurant = _allRestaurants.firstWhere(
      (r) => r.id == markerId,
      orElse: () => _allRestaurants.first,
    );
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
      builder: (context) => ItemRestaurantBottomSheet(
        restaurant: state.selectedRestaurant!,
        onTap: (restaurant) {
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

    for (var restaurant in _allRestaurants) {
      final isSelected = restaurant.id == selectedId;
      final icon = await createIconBitmap(
        isMarkerDrink: restaurant.styleFood,
        isSelected: isSelected,
      );

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

  static Future<BitmapDescriptor> createIconBitmap({
    bool isMarkerDrink = false,
    bool isSelected = false,
  }) async {
    return await BitmapDescriptor.asset(
      ImageConfiguration(
        devicePixelRatio: 2.5,
        size: isSelected ? Size(32, 32) : Size(28, 28),
      ),
      isMarkerDrink ? Assets.markerDrink : Assets.markerFood,
    );
  }

  /// Refresh all places (force API call)
  Future<void> refreshPlaces() async {
    await _refreshPlacesInBackground();
  }

  /// Get nearby places
  Future<void> getNearbyPlaces({double radiusInKm = 5.0}) async {
    final repository = Globals.placesRepository;
    if (repository == null) return;

    try {
      _stateController.add(currentState.copyWith(isLoading: true));

      final places = await repository.getNearbyPlaces(
        latitude: currentState.initialPosition.latitude,
        longitude: currentState.initialPosition.longitude,
        radiusInKm: radiusInKm,
      );

      _allRestaurants = places
          .map((place) => RestaurantData.fromPlaceModel(place))
          .toList();

      final markers = await _createMarkers(currentState.mapMode);
      _stateController.add(currentState.copyWith(
        markers: markers,
        isLoading: false,
      ));

      debugPrint('✅ Loaded ${_allRestaurants.length} nearby places');
    } catch (e) {
      debugPrint('❌ Error loading nearby places: $e');
      _stateController.add(currentState.copyWith(isLoading: false));
    }
  }

  /// Load waterlogging routes and create polylines
  Future<Set<Polyline>> _loadWaterloggingPolylines() async {
    final repository = Globals.waterloggingRepository;
    if (repository == null) {
      debugPrint('❌ WaterloggingRepository not initialized');
      return {};
    }

    try {
      final routes = await repository.getAllRoutes();
      final Set<Polyline> polylines = {};

      for (var route in routes) {
        // Convert WaterloggingPoint to LatLng
        final points = route.points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();

        // Parse color from hex string (e.g., '#2196F3')
        final parsedColor = _parseHexColor(route.lineColor);

        polylines.add(Polyline(
          polylineId: PolylineId('waterlogging_${route.routeId}'),
          points: points,
          color: parsedColor,
          width: route.lineWidth.toInt(),
          geodesic: true,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ));
      }

      debugPrint('✅ Loaded ${polylines.length} waterlogging polylines');
      return polylines;
    } catch (e) {
      debugPrint('❌ Error loading waterlogging polylines: $e');
      return {};
    }
  }

  /// Load traffic jam routes and create polylines
  Future<Set<Polyline>> _loadTrafficJamPolylines() async {
    final repository = Globals.trafficJamRepository;
    if (repository == null) {
      debugPrint('❌ TrafficJamRepository not initialized');
      return {};
    }

    try {
      final routes = await repository.getAllRoutes();
      final Set<Polyline> polylines = {};

      for (var route in routes) {
        // Convert TrafficJamPoint to LatLng
        final points = route.points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();

        // Parse color from hex string (e.g., '#FF5722')
        final color = _parseHexColor(route.lineColor);

        polylines.add(Polyline(
          polylineId: PolylineId('traffic_jam_${route.routeId}'),
          points: points,
          color: color,
          width: route.lineWidth.toInt(),
          geodesic: true,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ));
      }

      debugPrint('✅ Loaded ${polylines.length} traffic jam polylines');
      return polylines;
    } catch (e) {
      debugPrint('❌ Error loading traffic jam polylines: $e');
      return {};
    }
  }

  /// Load temporary report markers (auto-expire after 1 hour)
  Future<Set<Marker>> _loadTemporaryReportMarkers() async {
    final repository = Globals.temporaryReportMarkerRepository;
    if (repository == null) {
      debugPrint('❌ TemporaryReportMarkerRepository not initialized');
      return {};
    }

    try {
      final markers = await repository.getAllActiveMarkers();
      final Set<Marker> mapMarkers = {};

      for (var reportMarker in markers) {
        // Choose icon based on report type
        BitmapDescriptor icon;
        switch (reportMarker.reportType) {
          case ReportType.trafficJam:
            icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
            break;
          case ReportType.waterlogging:
            icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
            break;
          case ReportType.accident:
            icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
            break;
        }

        mapMarkers.add(Marker(
          markerId: MarkerId('temp_report_${reportMarker.id}'),
          position: LatLng(reportMarker.latitude, reportMarker.longitude),
          icon: icon,
          infoWindow: InfoWindow(
            title: reportMarker.reportType.displayName,
            snippet: reportMarker.description ??
                     'Báo cáo ${reportMarker.formattedRemainingTime} trước',
          ),
          onTap: () {
            debugPrint('Tapped report marker: ${reportMarker.reportType.displayName}');
          },
        ));
      }

      debugPrint('✅ Loaded ${mapMarkers.length} temporary report markers');
      return mapMarkers;
    } catch (e) {
      debugPrint('❌ Error loading temporary report markers: $e');
      return {};
    }
  }

  /// Parse hex color string to Color
  Color _parseHexColor(String hexColor) {
    try {
      final hex = hexColor.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    } catch (e) {
      debugPrint('❌ Error parsing color $hexColor: $e');
    }
    // Default to blue
    return const Color(0xFF2196F3);
  }
}
