class NewsModel {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String content;
  final String? location;
  final NewsType type;
  final DateTime createdAt;
  final List<String> likedBy;
  final List<CommentModel> comments;
  final bool isMyPost;

  NewsModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.content,
    this.location,
    required this.type,
    required this.createdAt,
    required this.likedBy,
    required this.comments,
    this.isMyPost = false,
  });

  bool get isLiked => likedBy.isNotEmpty;
  int get likeCount => likedBy.length;
  int get commentCount => comments.length;

  NewsModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatar,
    String? content,
    String? location,
    NewsType? type,
    DateTime? createdAt,
    List<String>? likedBy,
    List<CommentModel>? comments,
    bool? isMyPost,
  }) {
    return NewsModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      content: content ?? this.content,
      location: location ?? this.location,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      likedBy: likedBy ?? this.likedBy,
      comments: comments ?? this.comments,
      isMyPost: isMyPost ?? this.isMyPost,
    );
  }
}

class CommentModel {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String content;
  final DateTime createdAt;
  final bool isMyComment;

  CommentModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.content,
    required this.createdAt,
    this.isMyComment = false,
  });

  CommentModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatar,
    String? content,
    DateTime? createdAt,
    bool? isMyComment,
  }) {
    return CommentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      isMyComment: isMyComment ?? this.isMyComment,
    );
  }
}

enum NewsType {
  trafficJam,
  flood,
  accident,
  general;

  String get displayName {
    switch (this) {
      case NewsType.trafficJam:
        return 'Kẹt xe';
      case NewsType.flood:
        return 'Ngập nước';
      case NewsType.accident:
        return 'Tai nạn';
      case NewsType.general:
        return 'Khác';
    }
  }
}
