class NotificationResModel {
  final List<NotificationData>? data;
  final NotificationMetadata? metadata;

  NotificationResModel({
    this.data,
    this.metadata,
  });

  factory NotificationResModel.fromJson(Map<String, dynamic> json) {
    return NotificationResModel(
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => NotificationData.fromJson(item))
              .toList()
          : null,
      metadata: json['metadata'] != null
          ? NotificationMetadata.fromJson(json['metadata'])
          : null,
    );
  }
}

class NotificationMetadata {
  final int? total;
  final int? page;
  final int? pageSize;

  NotificationMetadata({
    this.total,
    this.page,
    this.pageSize,
  });

  factory NotificationMetadata.fromJson(Map<String, dynamic> json) {
    return NotificationMetadata(
      total: json['total'],
      page: json['page'],
      pageSize: json['pageSize'],
    );
  }
}

class NotificationData {
  final String? id;
  final String? userId;
  final String? notificationId;
  final String? title;
  final String? content;
  final String? targetKey;
  final String? targetData;
  final bool? isRead;
  final DateTime? createAt;
  final DateTime? readAt;
  final DateTime? deliveredAt;
  final String? type;
  final String? priority;

  NotificationData({
    this.id,
    this.userId,
    this.notificationId,
    this.title,
    this.content,
    this.targetKey,
    this.targetData,
    this.isRead,
    this.createAt,
    this.readAt,
    this.deliveredAt,
    this.type,
    this.priority,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['id'],
      userId: json['userId'],
      notificationId: json['notificationId'],
      title: json['title'],
      content: json['content'],
      targetKey: json['targetKey'],
      targetData: json['targetData'],
      isRead: json['isRead'],
      createAt:
          json['createAt'] != null ? DateTime.parse(json['createAt']) : null,
      readAt: json['readAt'] != null ? DateTime.parse(json['readAt']) : null,
      deliveredAt: json['deliveredAt'] != null
          ? DateTime.parse(json['deliveredAt'])
          : null,
      type: json['type'],
      priority: json['priority'],
    );
  }
}
