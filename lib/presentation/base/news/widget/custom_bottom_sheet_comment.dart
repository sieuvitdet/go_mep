import 'package:flutter/material.dart';
import 'package:go_mep_application/common/theme/app_colors.dart';
import 'package:go_mep_application/common/theme/app_dimens.dart';
import 'package:go_mep_application/common/widgets/widget.dart';
import 'package:intl/intl.dart';
import '../bloc/news_bloc.dart';
import '../models/news_model.dart';

class CustomBottomSheetComment extends StatefulWidget {
  final NewsModel news;
  final String currentUserId;
  final String currentUserName;
  final NewsController newsController;

  const CustomBottomSheetComment({
    super.key,
    required this.news,
    required this.currentUserId,
    required this.currentUserName,
    required this.newsController,
  });

  @override
  State<CustomBottomSheetComment> createState() =>
      _CustomBottomSheetCommentState();
}

class _CustomBottomSheetCommentState extends State<CustomBottomSheetComment> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _editController = TextEditingController();
  String? _editingCommentId;

  @override
  void dispose() {
    _commentController.dispose();
    _editController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

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

  void _showDeleteConfirmDialog(BuildContext context, String commentId) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Thông báo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto Condensed',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Bạn có chắc chắn muốn xóa bình luận này?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Roboto Condensed',
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Hủy',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto Condensed',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.newsController.deleteComment(
                          newsId: widget.news.id,
                          commentId: commentId,
                        );
                        Navigator.of(dialogContext).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5691FF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Đồng ý',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto Condensed',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentItem(CommentModel comment) {
    final isEditing = _editingCommentId == comment.id;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.getBackgroundCard(context),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.greyLight,
            ),
            child: comment.userAvatar != null
                ? ClipOval(
                    child: Image.network(
                      comment.userAvatar!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.person, color: AppColors.getTextColor(context));
                      },
                    ),
                  )
                : Icon(Icons.person, color: AppColors.getTextColor(context)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                         comment.userName,
                          maxLines: 2,
                          style: TextStyle(
                            color: AppColors.getTextColor(context),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto Condensed',
                          ),
                        ),
                      ),
                       if (comment.isMyComment) Gaps.hGap24
                    ],
                  ),
                  if (comment.isMyComment)
                        Positioned(
                          top: -16,
                          right: -10,
                          child: PopupMenuButton<String>(
                            icon: Icon(Icons.more_horiz,
                                color: Colors.white, size: 20),
                            color: AppColors.getBackgroundCard(context),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: BorderSide(color: AppColors.getBackgroundCard(context)),
                            ),
                            onSelected: (value) {
                              if (value == 'edit') {
                                setState(() {
                                  _editingCommentId = comment.id;
                                  _editController.text = comment.content;
                                });
                              } else if (value == 'delete') {
                                _showDeleteConfirmDialog(context, comment.id);
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem<String>(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit_outlined,
                                        color: AppColors.getTextColor(context), size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Chỉnh sửa',
                                      style: TextStyle(
                                        color: AppColors.getTextColor(context),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Roboto Condensed',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete_outline,
                                        color: AppColors.getTextColor(context), size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Xóa',
                                      style: TextStyle(
                                        color: AppColors.getTextColor(context),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Roboto Condensed',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                ]),
                Text(
                  _getTimeAgo(comment.createdAt),
                  style: TextStyle(
                    color: AppColors.hint,
                    fontSize: 12,
                    fontFamily: 'Roboto Condensed',
                  ),
                ),
                const SizedBox(height: 8),
                if (isEditing)
                  Column(
                    children: [
                      TextField(
                        controller: _editController,
                        style: TextStyle(color: AppColors.getTextColor(context)),
                        decoration: InputDecoration(
                          hintText: 'Chỉnh sửa bình luận...',
                          hintStyle: TextStyle(color: AppColors.hint),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.gradientEnd),
                          ),
                        ),
                        maxLines: null,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _editingCommentId = null;
                                _editController.clear();
                              });
                            },
                            child: Text('Hủy', style: TextStyle(color: AppColors.getTextColor(context)),),
                          ),
                          TextButton(
                            onPressed: () {
                              if (_editController.text.isNotEmpty) {
                                widget.newsController.editComment(
                                  newsId: widget.news.id,
                                  commentId: comment.id,
                                  newContent: _editController.text,
                                );
                                setState(() {
                                  _editingCommentId = null;
                                  _editController.clear();
                                });
                              }
                            },
                            child: Text('Lưu', style: TextStyle(color: AppColors.getTextColor(context)),),
                          ),
                        ],
                      ),
                    ],
                  )
                else
                  Text(
                    comment.content,
                    style: TextStyle(
                      color: AppColors.getTextColor(context),
                      fontSize: 14,
                      fontFamily: 'Roboto Condensed',
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: AppSizes.screenSize(context).height * 0.3,
          ),
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.getBackgroundCard(context),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: AppSizes.regular),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.getTextColor(context),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  StreamBuilder<NewsState>(
                    stream: widget.newsController.newsStream,
                    initialData: null,
                    builder: (context, snapshot) {
                      NewsModel currentNews = widget.news;

                      if (snapshot.hasData && snapshot.data is NewsLoaded) {
                        final state = snapshot.data as NewsLoaded;
                        try {
                          currentNews = state.newsList.firstWhere(
                            (n) => n.id == widget.news.id,
                          );
                        } catch (e) {
                          currentNews = widget.news;
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.only(left: 16, right: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${currentNews.comments.length} Bình luận',
                              style: TextStyle(
                                color: AppColors.getTextColor(context),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto Condensed',
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close, color: AppColors.getTextColor(context),),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Divider(color: AppColors.getDividerColor(context), height: 1),
                  Flexible(
                    child: StreamBuilder<NewsState>(
                      stream: widget.newsController.newsStream,
                      initialData: null,
                      builder: (context, snapshot) {
                        // Lấy comments từ news được truyền vào
                        NewsModel currentNews = widget.news;

                        // Nếu có update từ stream, lấy news mới nhất
                        if (snapshot.hasData && snapshot.data is NewsLoaded) {
                          final state = snapshot.data as NewsLoaded;
                          try {
                            currentNews = state.newsList.firstWhere(
                              (n) => n.id == widget.news.id,
                            );
                          } catch (e) {
                            // Nếu không tìm thấy, giữ nguyên widget.news
                            currentNews = widget.news;
                          }
                        }

                        if (currentNews.comments.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(32),
                              child: Text(
                                'Chưa có bình luận nào',
                                style: TextStyle(
                                  color: AppColors.hint,
                                  fontSize: 14,
                                  fontFamily: 'Roboto Condensed',
                                ),
                              ),
                            ),
                          );
                        }

                        // Đảo ngược danh sách để comment mới nhất nằm trên đầu
                        final reversedComments =
                            currentNews.comments.reversed.toList();

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: reversedComments.length,
                          itemBuilder: (context, index) {
                            return _buildCommentItem(reversedComments[index]);
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.getBackgroundCard(context),
                      border: Border(
                        top: BorderSide(color: AppColors.getDividerColor(context), width: 1),
                      ),
                    ),
                    child: SafeArea(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.getDividerColor(context), width: 1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextField(
                                controller: _commentController,
                                style: TextStyle(color: AppColors.getTextColor(context)),
                                decoration: InputDecoration(
                                  hintText: 'Viết bình luận...',
                                  hintStyle: TextStyle(color: AppColors.hint),
                                  filled: true,
                                  fillColor: AppColors.getBackgroundCard(context),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          IconButton(
                            onPressed: () {
                              if (_commentController.text.isNotEmpty) {
                                widget.newsController.addComment(
                                  newsId: widget.news.id,
                                  content: _commentController.text,
                                  currentUserId: widget.currentUserId,
                                  currentUserName: widget.currentUserName,
                                );
                                _commentController.clear();
                              }
                            },
                            icon: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFF5691FF), Color(0xFFDE50D0)],
                                ),
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(Icons.send,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
  }
}
