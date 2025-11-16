import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_mep_application/common/theme/app_colors.dart';
import 'package:go_mep_application/presentation/base/restaurant/ui/restaurant_detail_screen.dart';
import 'package:go_mep_application/presentation/main/bloc/main_bloc.dart';

class RestaurantScreen extends StatefulWidget {
  final MainBloc mainBloc;
  const RestaurantScreen({Key? key, required this.mainBloc}) : super(key: key);

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  int _selectedTabIndex = 0;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  List<RestaurantItem> _restaurants = [];

  @override
  void initState() {
    super.initState();
    _loadInitialRestaurants();
    _scrollController.addListener(_onScroll);
  }

  void _loadInitialRestaurants() {
    setState(() {
      _restaurants = _getDummyRestaurants();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.9 &&
        !_isLoadingMore) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    setState(() {
      _isLoadingMore = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _restaurants.addAll(_getDummyRestaurants());
      _isLoadingMore = false;
    });
  }

  void _toggleLike(int index) {
    setState(() {
      _restaurants[index].isLiked = !_restaurants[index].isLiked;
    });
  }

  void _showCategoryMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildCategoryMenu(),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildTabBar(),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _restaurants.length + (_isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= _restaurants.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF5691FF)),
                        ),
                      ),
                    );
                  }
                  return _buildRestaurantCard(_restaurants[index], index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5691FF), Color(0xFFDE50D0)],
              ),
            ),
            child: const Icon(
              Icons.restaurant,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Quán ăn',
            style: TextStyle(
              height: 1.2,
              color: AppColors.getTextColor(context),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Container(
            width: 24,
            height: 24,
            child: Icon(
              Icons.search,
              color: AppColors.getTextColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 35,
      color: AppColors.getBackgroundColor(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTab('Gợi ý', 0),
          _buildTab('Gần tôi', 1),
          _buildCategoryTab(),
          _buildTab('Yêu thích', 3),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          foreground: isSelected
              ? (Paint()
                ..shader = const LinearGradient(
                  colors: [Color(0xFF5691FF), Color(0xFFDE50D0)],
                ).createShader(const Rect.fromLTWH(0, 0, 100, 20)))
              : (Paint()..color = AppColors.getTextColor(context)),
        ),
      ),
    );
  }

  Widget _buildCategoryTab() {
    return GestureDetector(
      onTap: _showCategoryMenu,
      child: Row(
        children: [
          Text(
            'Chủ đề',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              foreground: _selectedTabIndex == 2
                  ? (Paint()
                    ..shader = const LinearGradient(
                      colors: [Color(0xFF5691FF), Color(0xFFDE50D0)],
                    ).createShader(const Rect.fromLTWH(0, 0, 100, 20)))
                  : (Paint()..color = AppColors.getTextColor(context)),
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.keyboard_arrow_down,
            color: _selectedTabIndex == 2
                ? const Color(0xFF5691FF)
                : AppColors.getTextColor(context),
            size: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantCard(RestaurantItem restaurant, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantDetailScreen(
              restaurantName: restaurant.name,
              rating: restaurant.rating,
              imageUrl: restaurant.imageUrl,
              priceRange: restaurant.priceRange,
              distance: restaurant.distance,
              isOpen: restaurant.isOpen,
              latLong: restaurant.latLong,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.getBackgroundColor(context),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: CachedNetworkImage(
                  imageUrl: restaurant.imageUrl,
                  placeholder: (context, url) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[800],
                    child: const Icon(Icons.restaurant, color: Colors.white),
                  ),
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: TextStyle(
                        color: AppColors.getTextColor(context),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    _buildStarRating(restaurant.rating),
                    const SizedBox(height: 6),
                    Text(
                      restaurant.priceRange,
                      style: TextStyle(
                        color: AppColors.getTextColor(context),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Text(
                          restaurant.status,
                          style: TextStyle(
                            color: restaurant.isOpen
                                ? const Color(0xFF3FDF6C)
                                : Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                        Text(
                          restaurant.distance,
                          style: TextStyle(
                            color: AppColors.getTextColor(context),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _toggleLike(index),
                child: Icon(
                  restaurant.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: restaurant.isLiked
                      ? Colors.red
                      : AppColors.getTextColor(context),
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      children: List.generate(5, (index) {
        if (rating >= index + 1) {
          return const Icon(Icons.star, color: Color(0xFFFFC107), size: 12);
        } else if (rating > index) {
          return const Icon(Icons.star_half,
              color: Color(0xFFFFC107), size: 12);
        } else {
          return const Icon(Icons.star_border,
              color: Color(0xFFFFC107), size: 12);
        }
      }),
    );
  }

  Widget _buildCategoryMenu() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF333333),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
        border: Border(
          top: BorderSide(color: Color(0xFF414141), width: 1),
          left: BorderSide(color: Color(0xFF414141), width: 1),
          right: BorderSide(color: Color(0xFF414141), width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCategoryMenuItem('Đồ uống', false),
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF5691FF).withOpacity(0.3),
                  const Color(0xFFDE50D0).withOpacity(0.3),
                ],
              ),
            ),
          ),
          _buildCategoryMenuItem('Đồ ăn', true),
        ],
      ),
    );
  }

  Widget _buildCategoryMenuItem(String title, bool isSelected) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        setState(() {
          _selectedTabIndex = 2;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              foreground: isSelected
                  ? (Paint()
                    ..shader = const LinearGradient(
                      colors: [Color(0xFF5691FF), Color(0xFFDE50D0)],
                    ).createShader(const Rect.fromLTWH(0, 0, 100, 20)))
                  : (Paint()..color = Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  List<RestaurantItem> _getDummyRestaurants() {
    return [
      RestaurantItem(
        name: 'Nhà hàng Nhật Bản',
        rating: 5.0,
        priceRange: '30.000-35.000',
        status: 'Mở cửa',
        isOpen: true,
        distance: '3.2km',
        imageUrl:
            'https://lh3.googleusercontent.com/p/AF1QipPqC1ehip-d710CSgrg5RbRk88sVV833JGW5lzr=w408-h544-k-no',
        isLiked: false,
        latLong: '10.776900,106.705700',
      ),
      RestaurantItem(
        name: 'Nhà hàng NoWhere',
        rating: 5.0,
        priceRange: '30.000-35.000',
        status: 'Đóng cửa',
        isOpen: false,
        distance: '4.1km',
        imageUrl:
            'https://lh3.googleusercontent.com/p/AF1QipPqC1ehip-d710CSgrg5RbRk88sVV833JGW5lzr=w408-h544-k-no',
        isLiked: true,
        latLong: '10.776900,106.705700',
      ),
      RestaurantItem(
        name: 'Nhà hàng The Sweet',
        rating: 5.0,
        priceRange: '30.000-35.000',
        status: 'Mở cửa',
        isOpen: true,
        distance: '5.3km',
        imageUrl:
            'https://lh3.googleusercontent.com/p/AF1QipPqC1ehip-d710CSgrg5RbRk88sVV833JGW5lzr=w408-h544-k-no',
        isLiked: false,
        latLong: '10.776900,106.705700',
      ),
      RestaurantItem(
        name: 'Nhà hàng Âu',
        rating: 4.5,
        priceRange: '30.000-35.000',
        status: 'Mở cửa',
        isOpen: true,
        distance: '7.5km',
        imageUrl:
            'https://lh3.googleusercontent.com/p/AF1QipPqC1ehip-d710CSgrg5RbRk88sVV833JGW5lzr=w408-h544-k-no',
        isLiked: true,
        latLong: '10.776900,106.705700',
      ),
      RestaurantItem(
        name: 'Nhà hàng NoWhere',
        rating: 5.0,
        priceRange: '30.000-35.000',
        status: 'Đóng cửa',
        isOpen: false,
        distance: '8.2km',
        imageUrl:
            'https://lh3.googleusercontent.com/p/AF1QipPqC1ehip-d710CSgrg5RbRk88sVV833JGW5lzr=w408-h544-k-no',
        isLiked: false,
        latLong: '10.776900,106.705700',
      ),
      RestaurantItem(
        name: 'Nhà hàng The Sweet',
        rating: 5.0,
        priceRange: '30.000-35.000',
        status: 'Mở cửa',
        isOpen: true,
        distance: '15km',
        imageUrl:
            'https://lh3.googleusercontent.com/p/AF1QipPqC1ehip-d710CSgrg5RbRk88sVV833JGW5lzr=w408-h544-k-no',
        isLiked: false,
        latLong: '10.776900,106.705700',
      ),
      RestaurantItem(
        name: 'Nhà hàng Á',
        rating: 4.5,
        priceRange: '30.000-35.000',
        status: 'Mở cửa',
        isOpen: true,
        distance: '3.2km',
        imageUrl:
            'https://lh3.googleusercontent.com/p/AF1QipPqC1ehip-d710CSgrg5RbRk88sVV833JGW5lzr=w408-h544-k-no',
        isLiked: true,
        latLong: '10.776900,106.705700',
      ),
      RestaurantItem(
        name: 'Nhà hàng The Sweet',
        rating: 5.0,
        priceRange: '30.000-35.000',
        status: 'Mở cửa',
        isOpen: true,
        distance: '3.2km',
        imageUrl:
            'https://lh3.googleusercontent.com/p/AF1QipPqC1ehip-d710CSgrg5RbRk88sVV833JGW5lzr=w408-h544-k-no',
        isLiked: false,
        latLong: '10.776900,106.705700',
      ),
    ];
  }
}

class RestaurantItem {
  final String name;
  final double rating;
  final String priceRange;
  final String status;
  final bool isOpen;
  final String distance;
  final String imageUrl;
  bool isLiked;
  final String latLong;

  RestaurantItem({
    required this.name,
    required this.rating,
    required this.priceRange,
    required this.status,
    required this.isOpen,
    required this.distance,
    required this.imageUrl,
    required this.isLiked,
    required this.latLong,
  });
}
