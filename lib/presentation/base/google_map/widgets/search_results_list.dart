import 'package:flutter/material.dart';
import 'package:go_mep_application/presentation/base/google_map/bloc/map_bloc.dart';

class SearchResultsList extends StatelessWidget {
  final List<RestaurantData> results;
  final Function(RestaurantData) onSelectRestaurant;

  const SearchResultsList({
    super.key,
    required this.results,
    required this.onSelectRestaurant,
  });

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Không tìm thấy kết quả',
          style: TextStyle(color: Colors.white54, fontSize: 14),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: results.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.white.withValues(alpha: 0.1),
          height: 1,
        ),
        itemBuilder: (context, index) {
          final restaurant = results[index];
          return SearchResultItem(
            restaurant: restaurant,
            onTap: () => onSelectRestaurant(restaurant),
          );
        },
      ),
    );
  }
}

class SearchResultItem extends StatelessWidget {
  final RestaurantData restaurant;
  final VoidCallback onTap;

  const SearchResultItem({
    super.key,
    required this.restaurant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // // Marker Icon
            // Container(
            //   width: 40,
            //   height: 40,
            //   decoration: BoxDecoration(
            //     gradient: const LinearGradient(
            //       colors: [Color(0xFF5B7FFF), Color(0xFFFF6EC7)],
            //       begin: Alignment.topLeft,
            //       end: Alignment.bottomRight,
            //     ),
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            //   child: const Icon(
            //     Icons.location_on,
            //     color: Colors.white,
            //     size: 24,
            //   ),
            // ),
            // const SizedBox(width: 12),

            // Restaurant Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant Name
                  Text(
                    restaurant.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Address
                  Text(
                    restaurant.address,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Rating, Stars, Distance
                  Row(
                    children: [
                      // Rating Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${restaurant.rating}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Icon(
                              Icons.star,
                              color: Colors.black,
                              size: 12,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Distance
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.navigation,
                              color: Color(0xFF5B7FFF),
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${restaurant.distance}km',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Arrow Icon
            const Icon(
              Icons.location_on_outlined,
              color: Colors.blue,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
