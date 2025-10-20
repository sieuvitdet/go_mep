# Step 7: Google Maps Integration & Restaurant Search

## Overview
This step implements comprehensive Google Maps integration with restaurant search functionality, custom markers with proper sizing, location services, geocoding, and two modes: Restaurant Mode and Taxi Mode. The implementation follows the BLoC pattern and provides 100% Figma design compliance.

## Duration
**6-8 days**

## Status
**🔄 In Progress**

## Dependencies
- Step 1: Project Setup (completed)
- Step 2: Architecture & Design System (completed)
- Step 3: Network Layer & API Integration (completed)
- Step 5: Home Screen & Main Navigation (completed)

## Objectives
- Integrate Google Maps Flutter
- Implement restaurant search functionality
- Create custom markers with size differentiation (focused vs normal)
- Add real-time location tracking
- Implement geocoding and reverse geocoding
- Build search results list
- Add taxi mode functionality
- Create map controls (zoom, pan)
- Implement route calculation
- Follow Figma design 100%

---

## Tasks Completed

### 1. Google Maps Screen UI

#### Map Screen (presentation/base/google_map/ui/map_screen.dart):
```dart
class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapBloc bloc;
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bloc = MapBloc(context);
    bloc.getCurrentLocation();

    // Listen for search query changes
    _searchController.addListener(() {
      bloc.onSearchQueryChanged(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Stack(
        children: [
          // Google Map
          _buildGoogleMap(),

          // Search bar at top
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 80,
            child: _buildSearchBar(),
          ),

          // Notification bell at top right
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: _buildNotificationButton(),
          ),

          // Search results list
          StreamBuilder<bool>(
            stream: bloc.streamShowSearchResults,
            builder: (context, snapshot) {
              if (snapshot.data == true) {
                return Positioned(
                  top: MediaQuery.of(context).padding.top + 80,
                  left: 16,
                  right: 16,
                  bottom: 100,
                  child: SearchResultsList(
                    bloc: bloc,
                    onResultTap: (restaurant) {
                      bloc.selectRestaurantFromSearch(restaurant);
                      _searchController.clear();
                      Utility.hideKeyboard();
                    },
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),

          // Mode toggle buttons at bottom
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: _buildModeToggle(),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleMap() {
    return StreamBuilder<LatLng?>(
      stream: bloc.streamCurrentLocation,
      builder: (context, locationSnapshot) {
        if (!locationSnapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return StreamBuilder<Set<Marker>>(
          stream: bloc.streamMarkers,
          builder: (context, markerSnapshot) {
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: locationSnapshot.data!,
                zoom: 14,
              ),
              markers: markerSnapshot.data ?? {},
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              onMapCreated: (controller) {
                _mapController = controller;
                bloc.setMapController(controller);
              },
              onCameraMove: (position) {
                bloc.onCameraMove(position);
              },
              onTap: (position) {
                bloc.onMapTap(position);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search restaurants...',
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: FigmaColors.textHint,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: FigmaColors.textSecondary,
          ),
          suffixIcon: StreamBuilder<String>(
            stream: bloc.streamSearchQuery,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    bloc.clearSearch();
                  },
                );
              }
              return SizedBox.shrink();
            },
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSizes.medium,
            vertical: AppSizes.medium,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: StreamBuilder<int>(
        stream: Globals.mainBloc?.streamNotificationCount,
        builder: (context, snapshot) {
          int count = snapshot.data ?? 0;
          return IconButton(
            icon: Badge(
              isLabelVisible: count > 0,
              label: Text('$count'),
              backgroundColor: FigmaColors.error,
              child: Icon(Icons.notifications),
            ),
            onPressed: () {
              Globals.mainBloc?.streamCurrentIndex.add(2);
            },
          );
        },
      ),
    );
  }

  Widget _buildModeToggle() {
    return StreamBuilder<MapMode>(
      stream: bloc.streamMapMode,
      builder: (context, snapshot) {
        MapMode currentMode = snapshot.data ?? MapMode.restaurant;

        return Row(
          children: [
            Expanded(
              child: ModeButton(
                icon: Icons.restaurant,
                label: 'Restaurant Mode',
                isSelected: currentMode == MapMode.restaurant,
                onTap: () => bloc.setMode(MapMode.restaurant),
              ),
            ),
            Gaps.hGap12,
            Expanded(
              child: ModeButton(
                icon: Icons.local_taxi,
                label: 'Taxi Mode',
                isSelected: currentMode == MapMode.taxi,
                onTap: () => bloc.setMode(MapMode.taxi),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    bloc.dispose();
    super.dispose();
  }
}
```

---

### 2. Mode Button Widget

```dart
class ModeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const ModeButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.medium,
          vertical: AppSizes.medium,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? FigmaColors.primaryBlue
              : Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          border: Border.all(
            color: isSelected
                ? FigmaColors.primaryBlue
                : FigmaColors.textSecondary,
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: FigmaColors.primaryBlue.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : FigmaColors.textPrimary,
            ),
            Gaps.hGap8,
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? Colors.white : FigmaColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### 3. Search Results List Widget

```dart
class SearchResultsList extends StatelessWidget {
  final MapBloc bloc;
  final Function(RestaurantModel) onResultTap;

  const SearchResultsList({
    Key? key,
    required this.bloc,
    required this.onResultTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RestaurantModel>>(
      stream: bloc.streamSearchResults,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        List<RestaurantModel> results = snapshot.data ?? [];

        if (results.isEmpty) {
          return _buildEmptyState();
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ListView.separated(
            padding: EdgeInsets.all(AppSizes.small),
            itemCount: results.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              return SearchResultItem(
                restaurant: results[index],
                onTap: () => onResultTap(results[index]),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(AppSizes.large),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off,
            size: 48,
            color: FigmaColors.textSecondary,
          ),
          Gaps.vGap8,
          Text(
            'No restaurants found',
            style: AppTextStyles.bodyMedium.copyWith(
              color: FigmaColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
```

#### Search Result Item:
```dart
class SearchResultItem extends StatelessWidget {
  final RestaurantModel restaurant;
  final VoidCallback onTap;

  const SearchResultItem({
    Key? key,
    required this.restaurant,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: FigmaColors.primaryBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.restaurant,
          color: FigmaColors.primaryBlue,
        ),
      ),
      title: Text(
        restaurant.name ?? '',
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        restaurant.address ?? '',
        style: AppTextStyles.bodySmall.copyWith(
          color: FigmaColors.textSecondary,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        '${restaurant.distance?.toStringAsFixed(1) ?? "0"} km',
        style: AppTextStyles.bodySmall.copyWith(
          color: FigmaColors.primaryBlue,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
```

---

### 4. Map BLoC Implementation

#### Map BLoC (presentation/base/google_map/bloc/map_bloc.dart):
```dart
enum MapMode { restaurant, taxi }

class MapBloc {
  late BuildContext context;
  GoogleMapController? mapController;

  final streamCurrentLocation = BehaviorSubject<LatLng?>();
  final streamMarkers = BehaviorSubject<Set<Marker>>();
  final streamSearchQuery = BehaviorSubject<String>();
  final streamSearchResults = BehaviorSubject<List<RestaurantModel>>();
  final streamShowSearchResults = BehaviorSubject<bool>();
  final streamMapMode = BehaviorSubject<MapMode>();
  final streamIsLoading = BehaviorSubject<bool>();
  final streamFocusedRestaurant = BehaviorSubject<RestaurantModel?>();

  List<RestaurantModel> _allRestaurants = [];
  Set<Marker> _markers = {};
  String? _focusedMarkerId;

  // Marker sizes
  static const double normalMarkerSize = 80.0;
  static const double focusedMarkerSize = 120.0;

  MapBloc(BuildContext context) {
    this.context = context;
    streamIsLoading.add(false);
    streamShowSearchResults.add(false);
    streamMapMode.add(MapMode.restaurant);
    streamMarkers.add({});
  }

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      LatLng currentLocation = LatLng(position.latitude, position.longitude);
      streamCurrentLocation.add(currentLocation);

      // Load nearby restaurants
      await loadNearbyRestaurants(currentLocation);
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> loadNearbyRestaurants(LatLng location) async {
    streamIsLoading.add(true);

    try {
      // Call API to get nearby restaurants
      ResponseModel response = await Repository.getNearbyRestaurants(
        context,
        latitude: location.latitude,
        longitude: location.longitude,
        radius: 5000, // 5km radius
      );

      if (response.success ?? false) {
        _allRestaurants = (response.result['restaurants'] as List?)
            ?.map((json) => RestaurantModel.fromJson(json))
            .toList() ?? [];

        // Create markers for all restaurants
        await _createMarkersForRestaurants();
      }
    } catch (e) {
      print('Error loading restaurants: $e');
    }

    streamIsLoading.add(false);
  }

  Future<void> _createMarkersForRestaurants() async {
    _markers.clear();

    for (var restaurant in _allRestaurants) {
      if (restaurant.latitude != null && restaurant.longitude != null) {
        bool isFocused = _focusedMarkerId == restaurant.id;

        BitmapDescriptor icon = await _createCustomMarkerIcon(
          isFocused: isFocused,
          size: isFocused ? focusedMarkerSize : normalMarkerSize,
        );

        Marker marker = Marker(
          markerId: MarkerId(restaurant.id ?? ''),
          position: LatLng(restaurant.latitude!, restaurant.longitude!),
          icon: icon,
          onTap: () => onMarkerTap(restaurant),
          zIndex: isFocused ? 1000 : 1,
        );

        _markers.add(marker);
      }
    }

    streamMarkers.add(_markers);
  }

  Future<BitmapDescriptor> _createCustomMarkerIcon({
    required bool isFocused,
    required double size,
  }) async {
    // Load the restaurant icon from assets
    final ByteData data = await rootBundle.load('assets/icons/restaurant_marker.png');
    final Uint8List bytes = data.buffer.asUint8List();

    // Resize the image based on focus state
    final image.Image? originalImage = image.decodeImage(bytes);
    if (originalImage == null) {
      return BitmapDescriptor.defaultMarker;
    }

    final image.Image resizedImage = image.copyResize(
      originalImage,
      width: size.toInt(),
      height: size.toInt(),
    );

    final Uint8List resizedBytes = Uint8List.fromList(
      image.encodePng(resizedImage),
    );

    return BitmapDescriptor.fromBytes(resizedBytes);
  }

  void onSearchQueryChanged(String query) {
    streamSearchQuery.add(query);

    if (query.isEmpty) {
      streamShowSearchResults.add(false);
      streamSearchResults.add([]);
      return;
    }

    streamShowSearchResults.add(true);

    // Filter restaurants by name
    List<RestaurantModel> results = _allRestaurants
        .where((restaurant) =>
            restaurant.name?.toLowerCase().contains(query.toLowerCase()) ??
            false)
        .toList();

    // Calculate distance for each result
    LatLng? currentLocation = streamCurrentLocation.value;
    if (currentLocation != null) {
      for (var restaurant in results) {
        if (restaurant.latitude != null && restaurant.longitude != null) {
          double distance = Geolocator.distanceBetween(
            currentLocation.latitude,
            currentLocation.longitude,
            restaurant.latitude!,
            restaurant.longitude!,
          ) / 1000; // Convert to km
          restaurant.distance = distance;
        }
      }

      // Sort by distance
      results.sort((a, b) => (a.distance ?? 0).compareTo(b.distance ?? 0));
    }

    streamSearchResults.add(results);
  }

  Future<void> selectRestaurantFromSearch(RestaurantModel restaurant) async {
    streamShowSearchResults.add(false);
    streamFocusedRestaurant.add(restaurant);

    // Update focused marker ID
    _focusedMarkerId = restaurant.id;

    // Recreate all markers with new focus
    await _createMarkersForRestaurants();

    // Move camera to restaurant location
    if (restaurant.latitude != null && restaurant.longitude != null) {
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(restaurant.latitude!, restaurant.longitude!),
          16,
        ),
      );
    }
  }

  void onMarkerTap(RestaurantModel restaurant) {
    streamFocusedRestaurant.add(restaurant);
    _focusedMarkerId = restaurant.id;
    _createMarkersForRestaurants();
  }

  void clearSearch() {
    streamSearchQuery.add('');
    streamShowSearchResults.add(false);
    streamSearchResults.add([]);
    _focusedMarkerId = null;
    _createMarkersForRestaurants();
  }

  void onCameraMove(CameraPosition position) {
    // Handle camera movement if needed
  }

  void onMapTap(LatLng position) {
    // Hide search results when tapping map
    streamShowSearchResults.add(false);
    Utility.hideKeyboard();
  }

  void setMode(MapMode mode) {
    streamMapMode.add(mode);

    if (mode == MapMode.restaurant) {
      // Show restaurant markers
      _createMarkersForRestaurants();
    } else {
      // Show taxi markers (future implementation)
      _markers.clear();
      streamMarkers.add(_markers);
    }
  }

  void dispose() {
    streamCurrentLocation.close();
    streamMarkers.close();
    streamSearchQuery.close();
    streamSearchResults.close();
    streamShowSearchResults.close();
    streamMapMode.close();
    streamIsLoading.close();
    streamFocusedRestaurant.close();
  }
}
```

---

### 5. Restaurant Data Model

```dart
class RestaurantModel {
  String? id;
  String? name;
  String? address;
  double? latitude;
  double? longitude;
  double? rating;
  String? phone;
  String? imageUrl;
  double? distance;
  List<String>? categories;

  RestaurantModel({
    this.id,
    this.name,
    this.address,
    this.latitude,
    this.longitude,
    this.rating,
    this.phone,
    this.imageUrl,
    this.distance,
    this.categories,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      rating: json['rating']?.toDouble(),
      phone: json['phone'],
      imageUrl: json['imageUrl'],
      categories: (json['categories'] as List?)?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'phone': phone,
      'imageUrl': imageUrl,
      'categories': categories,
    };
  }
}
```

---

## Tasks To Complete

### 1. Custom Marker Icons
- [x] Create normal size marker (80px)
- [x] Create focused size marker (120px)
- [ ] Add marker icon from assets
- [ ] Implement marker color variations
- [ ] Add marker animation on focus

### 2. Search Enhancement
- [ ] Add search debounce (300ms)
- [ ] Implement search history
- [ ] Add autocomplete suggestions
- [ ] Cache search results

### 3. Restaurant Details
- [ ] Show restaurant details on marker tap
- [ ] Add bottom sheet with restaurant info
- [ ] Display route to restaurant
- [ ] Show estimated time and distance

### 4. Taxi Mode
- [ ] Implement taxi marker icons
- [ ] Add available taxi display
- [ ] Implement taxi booking flow
- [ ] Show taxi live tracking

---

## Map Features Flow

```
User Opens Map Screen
     ↓
Get Current Location
     ↓
Load Nearby Restaurants
     ↓
Create Markers (Normal Size)
     ↓
Display on Map
     │
     ├─→ User Searches Restaurant
     │        ↓
     │   Filter Restaurants by Name
     │        ↓
     │   Show Search Results List
     │        ↓
     │   User Selects Restaurant
     │        ↓
     │   Update Focused Marker ID
     │        ↓
     │   Recreate All Markers
     │        ├─→ Focused: 120px size
     │        └─→ Others: 80px size
     │        ↓
     │   Animate Camera to Restaurant
     │        ↓
     │   Display Restaurant Details
     │
     └─→ User Taps Marker
              ↓
         Set as Focused
              ↓
         Update Marker Sizes
              ↓
         Show Details
```

---

## Key Deliverables

✅ **Google Maps Integration**: Maps displaying correctly
✅ **Current Location**: User location tracking
✅ **Restaurant Markers**: Custom markers on map
✅ **Marker Sizing**: Focused (120px) vs Normal (80px)
✅ **Search Functionality**: Text-based restaurant search
✅ **Search Results**: List display with distances
✅ **Camera Movement**: Smooth animation to selected location
✅ **Mode Toggle**: Restaurant and Taxi modes
🔄 **Custom Marker Icons**: Using asset images
🔄 **Restaurant Details**: Bottom sheet implementation
🔄 **Route Calculation**: Distance and time to restaurant
🔄 **Taxi Mode**: Full taxi functionality

---

## Success Criteria

✅ Maps load successfully
✅ Current location displays correctly
✅ Restaurant search works
✅ Markers appear with correct sizes
✅ Focused marker is 1.5x larger than normal
✅ Camera animates to selected restaurant
✅ Search results show with distances
✅ Mode toggle switches correctly
🔄 Custom marker icons load from assets
🔄 Marker focus animation is smooth
🔄 100% Figma design compliance

---

**Step Status**: 🔄 In Progress
**Next Step**: [Step 8: Personal Account Management](STEP_8_ACCOUNT_MANAGEMENT.md)
