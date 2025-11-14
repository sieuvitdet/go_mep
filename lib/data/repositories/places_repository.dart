import 'package:flutter/material.dart';
import '../local/database/app_database.dart';
import '../local/database/daos/places_dao.dart';
import '../model/req/places_search_req_model.dart';
import '../model/res/places_search_res_model.dart';
import '../../net/repository/repository.dart';

/// Repository for managing places/restaurant data with cache-first strategy
///
/// Strategy:
/// 1. For searches, check cache first for matching results
/// 2. If cached results are fresh (< 6 hours), return them
/// 3. Fetch from API in background
/// 4. Update cache with fresh data
/// 5. Support offline browsing of recently searched places
class PlacesRepository {
  final PlacesDao _placesDao;

  /// Cache validity duration (6 hours for search results)
  static const Duration cacheValidity = Duration(hours: 6);

  PlacesRepository(this._placesDao);

  /// Watch all places (reactive stream)
  Stream<List<PlaceEntity>> watchAllPlaces() {
    return _placesDao.watchAllPlaces();
  }

  /// Get all cached places
  Future<List<PlaceResultModel>> getAllCachedPlaces() async {
    final entities = await _placesDao.getAllPlaces();
    return entities.map(_entityToModel).toList();
  }

  /// Search places with cache-first strategy
  Future<PlacesSearchResModel?> searchPlaces({
    required BuildContext context,
    required String query,
    double? latitude,
    double? longitude,
    int? radius,
    bool forceRefresh = false,
  }) async {
    // Try cache first if not forcing refresh
    if (!forceRefresh) {
      final cached = await _placesDao.searchPlacesByName(query);

      if (cached.isNotEmpty) {
        // Check if cache is still fresh
        final oldestPlace = cached.first;
        final age = DateTime.now().difference(oldestPlace.cachedAt);

        if (age < cacheValidity) {
          // Cache is fresh, return it
          return PlacesSearchResModel(
            results: cached.map(_entityToModel).toList(),
            totalResults: cached.length,
          );
        }
      }
    }

    // Fetch from API
    try {
      final response = await Repository.searchPlaces(
        context,
        PlacesSearchReqModel(
          query: query,
          location: latitude != null && longitude != null
              ? '$latitude,$longitude'
              : null,
          maxResults: 20,
        ),
      );

      if (response != null && response.result != null) {
        final resModel = PlacesSearchResModel.fromJson(response.result);

        if (resModel.results != null && resModel.results!.isNotEmpty) {
          // Cache the search results
          await cachePlaces(resModel.results!);
          return resModel;
        }
      }

      // If API failed, return cached results
      final cached = await _placesDao.searchPlacesByName(query);
      if (cached.isNotEmpty) {
        return PlacesSearchResModel(
          results: cached.map(_entityToModel).toList(),
          totalResults: cached.length,
        );
      }

      return null;
    } catch (e) {
      debugPrint('Error searching places from API: $e');

      // On error, return cached results
      final cached = await _placesDao.searchPlacesByName(query);
      if (cached.isNotEmpty) {
        return PlacesSearchResModel(
          results: cached.map(_entityToModel).toList(),
          totalResults: cached.length,
        );
      }

      return null;
    }
  }

  /// Get nearby places (from cache)
  Future<List<PlaceResultModel>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    double radiusInKm = 5.0,
  }) async {
    final entities = await _placesDao.getPlacesNearby(
      centerLat: latitude,
      centerLng: longitude,
      radiusInKm: radiusInKm,
    );
    return entities.map(_entityToModel).toList();
  }

  /// Get top rated places (from cache)
  Future<List<PlaceResultModel>> getTopRatedPlaces({int limit = 10}) async {
    final entities = await _placesDao.getTopRatedPlaces(limit: limit);
    return entities.map(_entityToModel).toList();
  }

  /// Get place by ID
  Future<PlaceResultModel?> getPlaceById(String id) async {
    final entity = await _placesDao.getPlaceById(id);
    if (entity == null) return null;
    return _entityToModel(entity);
  }

  /// Check if place is cached
  Future<bool> isPlaceCached(String id) async {
    return await _placesDao.isPlaceCached(id);
  }

  /// Cache places to local database
  Future<void> cachePlaces(List<PlaceResultModel> places) async {
    final entities = places.map(_modelToEntity).toList();
    await _placesDao.insertPlaces(entities);
  }

  /// Cache single place
  Future<void> cachePlace(PlaceResultModel place) async {
    final entity = _modelToEntity(place);
    await _placesDao.insertPlace(entity);
  }

  /// Clean up old places (keep last 7 days)
  Future<void> cleanupOldPlaces() async {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    await _placesDao.deleteOlderThan(sevenDaysAgo);
  }

  /// Clear all cached places
  Future<void> clearCache() async {
    await _placesDao.clearAll();
  }

  /// Get total cached places count
  Future<int> getCachedPlacesCount() async {
    return await _placesDao.getCount();
  }

  // Helper methods to convert between Entity and Model

  PlaceResultModel _entityToModel(PlaceEntity entity) {
    return PlaceResultModel(
      id: entity.id,
      name: entity.name,
      address: entity.address,
      formattedAddress: entity.formattedAddress,
      location: (entity.latitude != null && entity.longitude != null)
          ? LocationModel(
              lat: entity.latitude,
              lng: entity.longitude,
            )
          : null,
      rating: entity.rating,
      phone: entity.phone,
      website: entity.website,
      types: entity.types?.split(',').map((e) => e.trim()).toList(),
      isOpen: entity.isOpen,
      openingHours: entity.openingHours,
      priceLevel: entity.priceLevel,
    );
  }

  PlaceEntity _modelToEntity(PlaceResultModel model) {
    return PlaceEntity(
      id: model.id ?? '',
      name: model.name ?? '',
      address: model.address,
      formattedAddress: model.formattedAddress,
      latitude: model.location?.lat,
      longitude: model.location?.lng,
      rating: model.rating,
      phone: model.phone,
      website: model.website,
      types: model.types?.join(', '),
      isOpen: model.isOpen,
      openingHours: model.openingHours,
      priceLevel: model.priceLevel,
      cachedAt: DateTime.now(),
    );
  }
}
