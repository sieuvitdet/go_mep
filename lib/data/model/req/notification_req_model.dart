class NotificationReqModel {
  final int pageNumber;
  final int pageSize;

  NotificationReqModel({
    required this.pageNumber,
    required this.pageSize,
  });

  Map<String, dynamic> toJson() {
    return {
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };
  }
}
