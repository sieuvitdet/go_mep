import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_mep_application/common/theme/app_colors.dart';
import 'package:go_mep_application/common/theme/assets.dart';
import 'package:go_mep_application/common/utils/custom_navigator.dart';
import 'package:go_mep_application/common/widgets/widget.dart';
import 'package:go_mep_application/presentation/base/notifications/ui/notification_screen.dart';
import 'package:go_mep_application/presentation/main/bloc/main_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../bloc/map_bloc.dart';
import '../widgets/search_results_list.dart';

class MapScreen extends StatefulWidget {
  final MainBloc mainBloc;
  const MapScreen({super.key, required this.mainBloc});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapBloc _mapBloc;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mapBloc = MapBloc(context: context);
    _mapBloc.initializeMap();
  }

  @override
  void dispose() {
    _mapBloc.mapController?.dispose();
    _searchController.dispose();
    _mapBloc.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapBloc.mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<MapState>(
        stream: _mapBloc.state$,
        initialData: _mapBloc.currentState,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
    
          final state = snapshot.data!;
          return Stack(
            children: [
              // Google Map
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: state.initialPosition,
                  zoom: 13.0,
                ),
                markers: state.markers,
                polylines: state.polylines,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
              ),
    
              // Top Search Bar with Results
              Positioned(
                top: MediaQuery.of(context).padding.top,
                left: 16,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Search Input
                    Row(children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: CustomTextField(
                            controller: _searchController,
                            hintText: 'Tìm kiếm',
                            textInputColor: Colors.white,
                            backgroundColor: const Color(0xFF1A1A1A),
                            borDerColor: Colors.transparent,
                            maxLines: 1,
                            suffixIconWidget: state.isSearching &&
                            _searchController.text.isNotEmpty ? InkWell(
                              onTap: () {
                                _searchController.clear();
                                _mapBloc.onSearchQueryChanged('');
                              },
                              child: Icon(Icons.clear,
                                color: Colors.white54, size: 20,),
                            ) : null,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            onChanged: (value) {
                              _mapBloc.onSearchQueryChanged(value);
                            },
                            onSubmitted: (value) {
                              _mapBloc.onSearchQueryChanged(value);
                            },
                          ),
                        ),
                      ),
                      Gaps.hGap16,
                      InkWell(
                        onTap: () => CustomNavigator.push(context, NotificationScreen()),
                        child: Container(
                          width: 50,
                          height: 48,
                          child: Stack(
                            children: [
                              Center(
                                child: Icon(Icons.notifications_outlined, color: AppColors.black),
                              ),
                              Positioned(
                                top: 10,
                                right: 12,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ]),
    
                    // Search Results List
                    if (_searchController.text.isNotEmpty &&
                        (state.isSearching || state.searchResults.isNotEmpty))
                      Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: SearchResultsList(
                          results: state.searchResults,
                          onSelectRestaurant: (restaurant) {
                            _searchController.clear();
                            _mapBloc.selectRestaurantFromSearch(restaurant);
                          },
                        ),
                      ),
                  ],
                ),
              ),
              // // Banner Message
              // Positioned(
              //   top: MediaQuery.of(context).padding.top + 70,
              //   left: 16,
              //   child: Container(
              //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //     child: Row(
              //       mainAxisSize: MainAxisSize.min,
              //         children: [
              //           Text('Bạn có muốn thưởng thức cafe. ',style: TextStyle(color: Colors.black, fontSize: 14),),
              //           Text(' Đang ngồi!',style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
    
              // Floating Action Buttons - Mode Switchers
              Positioned(
                  bottom: 12,
                  right: 26,
                  child: Column(children: [
                    // Restaurant Mode Button
                    GestureDetector(
                      onTap: () {
                        _mapBloc.changeMapMode(MapMode.restaurant);
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: state.mapMode == MapMode.taxi
                              ? Colors.white
                              : Color(0xFF3478F6),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            // White circle background
                            SvgPicture.asset(
                              'assets/icons/car_fill.svg',
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(
                                Colors.black,
                                BlendMode.srcIn,
                              ),
                            ),
                            // Restaurant waves icon
                            Positioned(
                              bottom: 8,
                              right: 0,
                              left: 0,
                              child: CustomImage(
                                image: Assets.iconWaves,
                                width: 32,
                                height: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        _mapBloc.changeMapMode(MapMode.taxi);
                      },
                      child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: state.mapMode == MapMode.taxi
                                ? const Color(0xFFFFD700)
                                : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.local_taxi,
                            color: state.mapMode == MapMode.taxi
                                ? Colors.black
                                : Colors.black,
                          )),
                    ),
                  ])),
            ],
          );
        },
      ),
    );
  }
}
