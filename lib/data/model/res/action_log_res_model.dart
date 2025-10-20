class ActionLogResModel {
  final List<ActionLogItem>? data;
  final ActionLogMetadata? metadata;

  ActionLogResModel({this.data, this.metadata});

  factory ActionLogResModel.fromJson(Map<String, dynamic> json) {
    return ActionLogResModel(
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => ActionLogItem.fromJson(item))
              .toList()
          : null,
      metadata: json['metadata'] != null
          ? ActionLogMetadata.fromJson(json['metadata'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.map((item) => item.toJson()).toList(),
      'metadata': metadata?.toJson(),
    };
  }
}

class ActionLogItem {
  final String? id;
  final String? referenceId;
  final String? userId;
  final String? avatar;
  final String? userName;
  final String? category;
  final String? action;
  final String? additionalMessage;
  final DateTime? createdAt;

  ActionLogItem({
    this.id,
    this.referenceId,
    this.userId,
    this.avatar,
    this.userName,
    this.category,
    this.action,
    this.additionalMessage,
    this.createdAt,
  });

  factory ActionLogItem.fromJson(Map<String, dynamic> json) {
    return ActionLogItem(
      id: json['id'],
      referenceId: json['referenceId'],
      userId: json['userId'],
      avatar: json['avatar'],
      userName: json['userName'],
      category: json['category'],
      action: json['action'],
      additionalMessage: json['additionalMessage'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'referenceId': referenceId,
      'userId': userId,
      'avatar': avatar,
      'userName': userName,
      'category': category,
      'action': action,
      'additionalMessage': additionalMessage,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  String get formattedDate {
    if (createdAt == null) return '';
    return '${createdAt!.day.toString().padLeft(2, '0')}/${createdAt!.month.toString().padLeft(2, '0')}/${createdAt!.year}';
  }

  String get actionDescription {
    switch (action) {
      case 'CREATED':
        return 'Đã tạo báo cáo sự cố';
      case 'APPROVED':
        return 'Đã phê duyệt báo cáo sự cố';
      case 'REJECTED':
        return 'Đã từ chối báo cáo sự cố';
      case 'REVOKED':
        return 'Đã thu hồi báo cáo sự cố';
      default:
        return additionalMessage ?? 'Thực hiện hành động';
    }
  }
}

class ActionLogMetadata {
  final int? total;
  final int? page;
  final int? pageSize;

  ActionLogMetadata({this.total, this.page, this.pageSize});

  factory ActionLogMetadata.fromJson(Map<String, dynamic> json) {
    return ActionLogMetadata(
      total: json['total'],
      page: json['page'],
      pageSize: json['pageSize'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'page': page,
      'pageSize': pageSize,
    };
  }
}
