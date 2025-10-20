import 'package:flutter/material.dart';
import 'package:go_mep_application/common/theme/app_colors.dart';
import 'package:go_mep_application/presentation/main/bloc/main_bloc.dart';
import '../bloc/news_bloc.dart';
import '../models/news_model.dart';
import '../widget/custom_bottom_sheet_comment.dart';
import '../widget/custom_news_widget.dart';

class NewsScreen extends StatefulWidget {
  final MainBloc mainBloc;
  const NewsScreen({super.key, required this.mainBloc});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final String currentUserId = 'current_user';
  final String currentUserName = 'Tôi';
  late NewsController _newsController;

  @override
  void initState() {
    super.initState();
    _newsController = NewsController();
    _newsController.loadNews();
  }

  @override
  void dispose() {
    _newsController.dispose();
    super.dispose();
  }

  void _showCommentBottomSheet(NewsModel news) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomBottomSheetComment(
          news: news,
          currentUserId: currentUserId,
          currentUserName: currentUserName,
          newsController: _newsController,
        ),
    );
  }

  void _showDeleteNewsConfirmDialog(String newsId) {
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
                'Bạn có chắc chắn muốn xóa bài đăng này?',
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
                        _newsController.deleteNews(newsId);
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
                      child: Container(
                        child: const Center(
                          child: Text(
                            'Đồng ý',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto Condensed',
                            ),
                          ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      body: SafeArea(
        top: false,
        child: StreamBuilder<NewsState>(
          stream: _newsController.newsStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data is NewsInitial) {
              return const SizedBox.shrink();
            }

            if (snapshot.data is NewsLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF5691FF),
                ),
              );
            } else if (snapshot.data is NewsLoaded) {
              final state = snapshot.data as NewsLoaded;
              if (state.newsList.isEmpty) {
                return CustomScrollView(
                  slivers: [
                    _buildSliverAppBar(context),
                    const SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'Chưa có tin tức nào',
                          style: TextStyle(
                            color: Color(0xFF7C7C7C),
                            fontSize: 16,
                            fontFamily: 'Roboto Condensed',
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await _newsController.loadNews();
                },
                color: const Color(0xFF5691FF),
                backgroundColor: AppColors.getBackgroundColor(context),
                child: CustomScrollView(
                  slivers: [
                    _buildSliverAppBar(context),
                    SliverPadding(
                      padding: const EdgeInsets.only(bottom: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final news = state.newsList[index];
                            return CustomNewsWidget(
                              news: news,
                              currentUserId: currentUserId,
                              onLike: () {
                                _newsController.toggleLike(news.id, currentUserId);
                              },
                              onComment: () => _showCommentBottomSheet(news),
                              onDelete: news.isMyPost
                                  ? () => _showDeleteNewsConfirmDialog(news.id)
                                  : null,
                            );
                          },
                          childCount: state.newsList.length,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.data is NewsError) {
              final state = snapshot.data as NewsError;
              return CustomScrollView(
                slivers: [
                  _buildSliverAppBar(context),
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Có lỗi xảy ra',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Roboto Condensed',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            style: const TextStyle(
                              color: Color(0xFF7C7C7C),
                              fontSize: 14,
                              fontFamily: 'Roboto Condensed',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              _newsController.loadNews();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5691FF),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      leading: const SizedBox.shrink(),
      floating: true,
      snap: true,
      pinned: false,
      backgroundColor: AppColors.getBackgroundColor(context),
      elevation: 0,
      expandedHeight: 70,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tin tức',
              style: TextStyle(
                color: AppColors.getTextColor(context),
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.notifications_outlined,
                color: AppColors.getTextColor(context),
                size: 16,
              ),
              onPressed: () {},
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}
