import 'dart:async';
import 'package:go_mep_application/common/theme/globals/globals.dart';
import 'package:go_mep_application/data/model/res/temporary_report_marker_model.dart';
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
      // Load reports from database
      final reportNews = await _loadReportsFromDatabase();

      // Sort by createdAt descending (newest first)
      reportNews.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      _newsList = reportNews;
      _newsStreamController.add(NewsLoaded(newsList: _newsList));
    } catch (e) {
      _newsStreamController.add(NewsError(message: e.toString()));
    }
  }

  /// Load reports from temporary_report_markers table
  Future<List<NewsModel>> _loadReportsFromDatabase() async {
    final repository = Globals.temporaryReportMarkerRepository;
    if (repository == null) {
      return [];
    }

    try {
      final markers = await repository.getAllActiveMarkers();

      return markers.map((marker) {
        // Convert ReportType to NewsType
        NewsType newsType;
        switch (marker.reportType) {
          case ReportType.trafficJam:
            newsType = NewsType.trafficJam;
            break;
          case ReportType.waterlogging:
            newsType = NewsType.flood;
            break;
          case ReportType.accident:
            newsType = NewsType.accident;
            break;
        }

        return NewsModel(
          id: 'report_${marker.id}',
          userId: marker.userReportedBy ?? 'current_user',
          userName: 'Tôi',
          content: 'Đã báo cáo ${marker.reportType.displayName} tại vị trí '
                   '(${marker.latitude.toStringAsFixed(6)}, ${marker.longitude.toStringAsFixed(6)}). '
                   '${marker.description ?? ''}\n'
                   'Còn lại: ${marker.formattedRemainingTime}',
          type: newsType,
          createdAt: marker.createdAt,
          likedBy: [],
          comments: [],
          isMyPost: true,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  /// Add a new report to the news list
  void addReport(TemporaryReportMarkerModel marker) {
    NewsType newsType;
    switch (marker.reportType) {
      case ReportType.trafficJam:
        newsType = NewsType.trafficJam;
        break;
      case ReportType.waterlogging:
        newsType = NewsType.flood;
        break;
      case ReportType.accident:
        newsType = NewsType.accident;
        break;
    }

    final newNews = NewsModel(
      id: 'report_${marker.id}',
      userId: marker.userReportedBy ?? 'current_user',
      userName: 'Tôi',
      content: 'Đã báo cáo ${marker.reportType.displayName} tại vị trí '
               '(${marker.latitude.toStringAsFixed(6)}, ${marker.longitude.toStringAsFixed(6)}). '
               '${marker.description ?? ''}\n'
               'Còn lại: ${marker.formattedRemainingTime}',
      type: newsType,
      createdAt: marker.createdAt,
      likedBy: [],
      comments: [],
      isMyPost: true,
    );

    _newsList.insert(0, newNews);
    _newsStreamController.add(NewsLoaded(newsList: _newsList));
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
