import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_mep_application/common/widgets/widget.dart';
import 'package:intl/intl.dart';
import '../../../../common/theme/app_colors.dart';
import '../../../../common/theme/assets.dart';
import '../models/news_model.dart';

class CustomNewsWidget extends StatelessWidget {
  final NewsModel news;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback? onDelete;
  final String currentUserId;

  const CustomNewsWidget({
    super.key,
    required this.news,
    required this.onLike,
    required this.onComment,
    this.onDelete,
    required this.currentUserId,
  });

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else {
      return DateFormat('HH:mm   dd/MM/yyyy').format(dateTime);
    }
  }

  Color _getNewsTypeColor() {
    switch (news.type) {
      case NewsType.trafficJam:
        return const Color(0xFFFFD233);
      case NewsType.flood:
        return const Color(0xFF5691FF);
      case NewsType.accident:
        return const Color(0xFFFF0000);
      case NewsType.general:
        return Colors.grey;
    }
  }

  Widget _buildMoreOptionsMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_horiz, color: AppColors.getTextColor(context), size: 24),
      color: AppColors.getBackgroundColor(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: AppColors.greyLight),
      ),
      onSelected: (value) {
        if (value == 'delete' && onDelete != null) {
          onDelete!();
        }
      },
      itemBuilder: (context) => [
         PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, color: AppColors.getTextColor(context), size: 24),
              Gaps.hGap12,
              Text(
                'Xóa',
                style: TextStyle(
                  color: AppColors.getTextColor(context),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLiked = news.likedBy.contains(currentUserId);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.getBackgroundCard(context),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              // Avatar
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.getBackgroundColor(context),
                ),
                child: news.userAvatar != null
                    ? ClipOval(
                        child: Image.network(
                          news.userAvatar!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.person, color: AppColors.getTextColor(context));
                          },
                        ),
                      )
                    : Icon(Icons.person, color: AppColors.getTextColor(context)),
              ),
              const SizedBox(width: 12),
              // Name and time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.userName,
                      style: TextStyle(
                        color: AppColors.getTextColor(context),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto Condensed',
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          _getTimeAgo(news.createdAt),
                          style: TextStyle(
                            color: AppColors.hint,
                            fontSize: 12,
                            fontFamily: 'Roboto Condensed',
                          ),
                        ),
                        Gaps.hGap10,
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _getNewsTypeColor(),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              Assets.logoCarIcon,
                              width: 16,
                              colorFilter: ColorFilter.mode(
                                AppColors.getTextColor(context),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // More options (only for own posts)
              if (news.isMyPost) _buildMoreOptionsMenu(context),
            ],
          ),
          const SizedBox(height: 12),
          // Divider
          Container(
            height: 1,
            color: AppColors.getDividerColor(context),
          ),
          const SizedBox(height: 12),
          // Content
          Text(news.content,
            style: TextStyle(
              color: AppColors.getTextColor(context),
              fontSize: 14,
              fontFamily: 'Roboto Condensed',
            ),
          ),
          const SizedBox(height: 12),
          // Divider
          Container(
            height: 1,
            color: AppColors.getDividerColor(context),
          ),
          const SizedBox(height: 12),
          // Like info
          if (news.likedBy.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                news.likedBy.length > 1
                    ? '${news.likedBy.first} và ${news.likedBy.length - 1} người khác đã thả tim bài đăng'
                    : '${news.likedBy.first} đã thả tim bài đăng',
                style: TextStyle(
                  color: AppColors.getTextColor(context),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto Condensed',
                ),
              ),
            ),
          // Action buttons
          Row(
            children: [
              InkWell(
                onTap: onLike,
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset(
                    isLiked ? Assets.icHeartFilled : Assets.icHeartOutline,
                    colorFilter: ColorFilter.mode(
                      isLiked ? Colors.red : AppColors.getTextColor(context),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              InkWell(
                onTap: onComment,
                child:  SizedBox(
                  width: 24,
                  height: 24,
                  child: Icon(Icons.comment_outlined, color: AppColors.getTextColor(context), size: 24),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Comment count
          if (news.comments.isNotEmpty)
            InkWell(
              onTap: onComment,
              child: Text(
                'Xem ${news.commentCount} bình luận',
                style: TextStyle(
                  color: AppColors.hint,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto Condensed',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
