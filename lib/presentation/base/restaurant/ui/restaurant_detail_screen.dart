import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_mep_application/common/theme/app_colors.dart';
import 'package:go_mep_application/common/utils/gps_utils.dart';
import 'package:go_mep_application/common/widgets/widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final String restaurantName;
  final double rating;
  final String imageUrl;
  final String priceRange;
  final String distance;
  final bool isOpen;
  final String latLong;

  const RestaurantDetailScreen({
    Key? key,
    required this.restaurantName,
    required this.rating,
    required this.imageUrl,
    required this.priceRange,
    required this.distance,
    required this.isOpen,
    required this.latLong,
  }) : super(key: key);

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  bool _isInfoExpanded = true;
  bool _isReviewExpanded = true;
  final Set<int> _expandedReviews = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                pinned: false,
                stretch: true,
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.getBackgroundCard(context),
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                  background: _buildHeaderImage(),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRestaurantInfo(),
                    _buildDivider(),
                    _buildExpandableSection(
                      title: 'Thông tin',
                      isExpanded: _isInfoExpanded,
                      onTap: () {
                        setState(() {
                          _isInfoExpanded = !_isInfoExpanded;
                        });
                      },
                      child: _buildInfoContent(),
                    ),
                    _buildDivider(),
                    _buildExpandableSection(
                      title: 'Nhận xét',
                      isExpanded: _isReviewExpanded,
                      onTap: () {
                        setState(() {
                          _isReviewExpanded = !_isReviewExpanded;
                        });
                      },
                      child: _buildReviewsContent(),
                    ),
                    _buildDirectionsButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
          // Back button ở vị trí cố định
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderImage() {
    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      placeholder: (context, url) => CustomPlaceholder(),
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      errorWidget: (context, error, stackTrace) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.grey[800],
          child: const Icon(
            Icons.restaurant,
            color: Colors.white,
            size: 80,
          ),
        );
      },
    );
  }

  Widget _buildRestaurantInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.restaurantName,
                  style: TextStyle(
                    color: AppColors.getTextColor(context),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildStarRating(widget.rating),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.location_on,
            '11-17, 11B, Số 65, Quận 7, Hồ Chí Minh',
            AppColors.blue,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.phone,
            '0908 726 915',
            AppColors.green,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.attach_money,
            widget.priceRange,
            AppColors.red,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.access_time,
            '6:00 - 22:00',
            AppColors.getTextColor(context),
          ),
          const SizedBox(height: 8),
          Text(
            widget.isOpen ? 'Đang mở' : 'Đóng cửa',
            style: TextStyle(
              color: widget.isOpen ? AppColors.green : AppColors.red,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color iconColor) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: text == widget.priceRange ? AppColors.red : AppColors.getTextColor(context),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStarRating(double rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.getBackgroundCard(context),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '(${rating.toStringAsFixed(1)}',
            style: TextStyle(
              color: AppColors.getTextColor(context),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '/5',
            style: TextStyle(
              color: AppColors.getTextColor(context),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(Icons.star, color: AppColors.yellow, size: 16),
          Text(
            ')',
            style: TextStyle(
              color: AppColors.getTextColor(context),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.blue.withValues(alpha: 0.3),
            AppColors.gradientEnd.withValues(alpha: 0.3),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.getTextColor(context),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppColors.getTextColor(context),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded) child,
      ],
    );
  }

  Widget _buildInfoContent() {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 0),
      child: Text(
        '"Nhà hàng Hải Sản Hương Lửa 9 - Phục vụ chuyên về hải sản, đa dạng, món ăn 3 miền. Món ăn đậm chất hương vị Việt Nam. Phục vụ chuyên nghiệp, tận tâm. Không gian sang trọng, thoáng mát, sức chứa tới 100 khách. Nhiều chương trình ưu đãi khi đặt tiệc tại nhà hàng."',
        style: TextStyle(
          color: AppColors.getTextColor(context),
          fontSize: 14,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildReviewsContent() {
    return Column(
      children: [
        _buildReviewCard(
          index: 0,
          name: 'Khanh Tran',
          subtitle: 'Local Guide',
          reviewCount: '77 đánh giá',
          rating: 5.0,
          review:
              'Món ăn ngon và đa dạng, món nào cũng chất lượng. Công ty mình hơn 30 người nhưng hóa đơn không quá cao. Quán có phục vụ lẩu và tivi hát karaoke. Có phòng riêng phù hợp họp nhóm, liên hoan sinh nhật...',
        ),
        const SizedBox(height: 12),
        _buildReviewCard(
          index: 1,
          name: 'Hong Phan',
          subtitle: 'Local Guide',
          reviewCount: '8 đánh giá',
          rating: 5.0,
          review:
              'Món ăn ngon, giá hợp lý. Không gian sạch sẽ thoáng mát, nhân viên thân thiện. Sẽ quay lại cùng bạn bè.',
        ),
        const SizedBox(height: 12),
        _buildReviewCard(
          index: 2,
          name: 'Le Giang',
          subtitle: 'Local Guide',
          reviewCount: '12 đánh giá',
          rating: 5.0,
          review:
              'Đồ ăn tươi, nêm nếm vừa miệng. Phục vụ nhanh, chu đáo. Có bãi đỗ xe thuận tiện.',
        ),
      ],
    );
  }

  Widget _buildReviewCard({
    required int index,
    required String name,
    required String subtitle,
    required String reviewCount,
    required double rating,
    required String review,
  }) {
    final isExpanded = _expandedReviews.contains(index);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.getBackgroundCard(context),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.getBackgroundCard(context),
                child: Icon(Icons.person, color: AppColors.getTextColor(context)),
              ),
              Gaps.hGap12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: AppColors.getTextColor(context),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: AppColors.getTextColor(context),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$reviewCount',
                          style: TextStyle(
                            color: AppColors.getTextColor(context),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(
              5,
              (starIndex) => Icon(
                Icons.star,
                color: AppColors.yellow,
                size: 16,
              ),
            ),
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              TextStyle textStyle = TextStyle(
                color: AppColors.getTextColor(context),
                fontSize: 14,
                height: 1.5,
              );

              final textSpan = TextSpan(text: review, style: textStyle);
              final textPainter = TextPainter(
                text: textSpan,
                maxLines: 3,
                textDirection: TextDirection.ltr,
              );
              textPainter.layout(maxWidth: constraints.maxWidth);

              final isTextOverflow = textPainter.didExceedMaxLines;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review,
                    style: textStyle,
                    maxLines: isExpanded ? null : 3,
                    overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                  ),
                  if (isTextOverflow) ...[
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isExpanded) {
                            _expandedReviews.remove(index);
                          } else {
                            _expandedReviews.add(index);
                          }
                        });
                      },
                      child: Text(
                        isExpanded ? 'Thu gọn' : 'Xem thêm',
                        style: TextStyle(
                          color: AppColors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDirectionsButton() {
    return InkWell(
      onTap: () {
        if (widget.latLong.isNotEmpty && widget.latLong.split(',').length == 2) {
          GpsUtils.googleMapsDirection(destination: LatLng(double.parse(widget.latLong.split(',')[0]), double.parse(widget.latLong.split(',')[1])));
        }
      },
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.blue,
              AppColors.gradientEnd,
            ],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Chỉ đường (${widget.distance})',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
