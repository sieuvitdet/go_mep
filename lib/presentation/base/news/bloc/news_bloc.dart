import 'dart:async';
import '../models/news_model.dart';

// States
abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<NewsModel> newsList;

  NewsLoaded({required this.newsList});
}

class NewsError extends NewsState {
  final String message;

  NewsError({required this.message});
}

// Controller using StreamController  
class NewsController {
  final _newsStreamController = StreamController<NewsState>.broadcast();

  Stream<NewsState> get newsStream => _newsStreamController.stream;

  List<NewsModel> _newsList = [];

  NewsController() {
    _newsStreamController.add(NewsInitial());
  }

  Future<void> loadNews() async {
    _newsStreamController.add(NewsLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));

      final mockNews = [
        NewsModel(
          id: '1',
          userId: 'current_user',
          userName: 'Tôi',
          content: 'Đã đăng thông tin cảnh báo kẹt xe ở địa điểm 15 Huỳnh Tấn Phát phường Tân Thuận Tây, quận 7, thành phố Hồ Chí Minh.',
          type: NewsType.trafficJam,
          createdAt: DateTime.now().subtract(const Duration(minutes: 29)),
          likedBy: ['user1', 'user2', 'Khanh Trần'],
          comments: List.generate(
            10,
            (index) => CommentModel(
              id: 'comment_$index',
              userId: 'user_$index',
              userName: 'User $index',
              content: 'Bình luận số $index',
              createdAt: DateTime.now().subtract(Duration(minutes: index)),
              isMyComment: index == 0,
            ),
          ),
          isMyPost: true,
        ),
        NewsModel(
          id: '2',
          userId: 'user2',
          userName: 'Trần Đức Duy',
          content: 'Đã đăng thông tin cảnh báo ngập ở địa điểm 15 Huỳnh Tấn Phát phường Tân Thuận Tây, quận 7, thành phố Hồ Chí Minh.',
          type: NewsType.flood,
          createdAt: DateTime.parse('2024-07-13 19:07:00'),
          likedBy: ['current_user', 'user1', 'user3', 'Khanh Trần'],
          comments: List.generate(
            10,
            (index) => CommentModel(
              id: 'comment2_$index',
              userId: 'user2_$index',
              userName: 'User Comment $index',
              content: 'Bình luận cho bài viết 2 - số $index',
              createdAt: DateTime.now().subtract(Duration(minutes: index * 2)),
              isMyComment: false,
            ),
          ),
          isMyPost: false,
        ),
        NewsModel(
          id: '2',
          userId: 'user2',
          userName: 'Trần Đức Duy',
          content: 'Đã đăng thông tin cảnh báo ngập ở địa điểm 15 Huỳnh Tấn Phát phường Tân Thuận Tây, quận 7, thành phố Hồ Chí Minh.',
          type: NewsType.flood,
          createdAt: DateTime.parse('2024-07-13 19:07:00'),
          likedBy: ['current_user', 'user1', 'user3', 'Khanh Trần'],
          comments: List.generate(
            10,
            (index) => CommentModel(
              id: 'comment2_$index',
              userId: 'user2_$index',
              userName: 'User Comment $index',
              content: 'Bình luận cho bài viết 2 - số $index',
              createdAt: DateTime.now().subtract(Duration(minutes: index * 2)),
              isMyComment: false,
            ),
          ),
          isMyPost: false,
        ),
        NewsModel(
          id: '2',
          userId: 'user2',
          userName: 'Trần Đức Duy',
          content: 'Đã đăng thông tin cảnh báo ngập ở địa điểm 15 Huỳnh Tấn Phát phường Tân Thuận Tây, quận 7, thành phố Hồ Chí Minh.',
          type: NewsType.flood,
          createdAt: DateTime.parse('2024-07-13 19:07:00'),
          likedBy: ['current_user', 'user1', 'user3', 'Khanh Trần'],
          comments: List.generate(
            10,
            (index) => CommentModel(
              id: 'comment2_$index',
              userId: 'user2_$index',
              userName: 'User Comment $index',
              content: 'Bình luận cho bài viết 2 - số $index',
              createdAt: DateTime.now().subtract(Duration(minutes: index * 2)),
              isMyComment: false,
            ),
          ),
          isMyPost: false,
        ),
      ];

      _newsList = mockNews;
      _newsStreamController.add(NewsLoaded(newsList: _newsList));
    } catch (e) {
      _newsStreamController.add(NewsError(message: e.toString()));
    }
  }

  void toggleLike(String newsId, String currentUserId) {
    final updatedNews = _newsList.map((news) {
      if (news.id == newsId) {
        final likedBy = List<String>.from(news.likedBy);
        if (likedBy.contains(currentUserId)) {
          likedBy.remove(currentUserId);
        } else {
          likedBy.add(currentUserId);
        }
        return news.copyWith(likedBy: likedBy);
      }
      return news;
    }).toList();

    _newsList = updatedNews;
    _newsStreamController.add(NewsLoaded(newsList: _newsList));
  }

  void addComment({
    required String newsId,
    required String content,
    required String currentUserId,
    required String currentUserName,
  }) {
    final updatedNews = _newsList.map((news) {
      if (news.id == newsId) {
        final newComment = CommentModel(
          id: 'comment_${DateTime.now().millisecondsSinceEpoch}',
          userId: currentUserId,
          userName: currentUserName,
          content: content,
          createdAt: DateTime.now(),
          isMyComment: true,
        );
        final comments = List<CommentModel>.from(news.comments)..add(newComment);
        return news.copyWith(comments: comments);
      }
      return news;
    }).toList();

    _newsList = updatedNews;
    _newsStreamController.add(NewsLoaded(newsList: _newsList));
  }

  void editComment({
    required String newsId,
    required String commentId,
    required String newContent,
  }) {
    final updatedNews = _newsList.map((news) {
      if (news.id == newsId) {
        final updatedComments = news.comments.map((comment) {
          if (comment.id == commentId) {
            return comment.copyWith(content: newContent);
          }
          return comment;
        }).toList();
        return news.copyWith(comments: updatedComments);
      }
      return news;
    }).toList();

    _newsList = updatedNews;
    _newsStreamController.add(NewsLoaded(newsList: _newsList));
  }

  void deleteComment({
    required String newsId,
    required String commentId,
  }) {
    final updatedNews = _newsList.map((news) {
      if (news.id == newsId) {
        final updatedComments = news.comments
            .where((comment) => comment.id != commentId)
            .toList();
        return news.copyWith(comments: updatedComments);
      }
      return news;
    }).toList();

    _newsList = updatedNews;
    _newsStreamController.add(NewsLoaded(newsList: _newsList));
  }

  void deleteNews(String newsId) {
    final updatedNews = _newsList.where((news) => news.id != newsId).toList();

    _newsList = updatedNews;
    _newsStreamController.add(NewsLoaded(newsList: _newsList));
  }

  void dispose() {
    _newsStreamController.close();
  }
}
