import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/notifications_table.dart';

part 'notification_dao.g.dart';

@DriftAccessor(tables: [Notifications])
class NotificationDao extends DatabaseAccessor<AppDatabase>
    with _$NotificationDaoMixin {
  NotificationDao(AppDatabase db) : super(db);

  // Watch all notifications (reactive stream - auto updates!)
  Stream<List<NotificationEntity>> watchAllNotifications() {
    return (select(notifications)
          ..orderBy([
            (n) => OrderingTerm.desc(n.createAt),
          ]))
        .watch();
  }

  // Watch unread count
  Stream<int> watchUnreadCount() {
    return (select(notifications)..where((n) => n.isRead.equals(false)))
        .watch()
        .map((list) => list.length);
  }

  // Get all notifications (one-time query)
  Future<List<NotificationEntity>> getAllNotifications() {
    return (select(notifications)
          ..orderBy([
            (n) => OrderingTerm.desc(n.createAt),
          ]))
        .get();
  }

  // Get paginated notifications
  Future<List<NotificationEntity>> getNotifications({
    required int page,
    required int pageSize,
  }) {
    return (select(notifications)
          ..orderBy([
            (n) => OrderingTerm.desc(n.createAt),
          ])
          ..limit(pageSize, offset: page * pageSize))
        .get();
  }

  // Get unread notifications
  Future<List<NotificationEntity>> getUnreadNotifications() {
    return (select(notifications)
          ..where((n) => n.isRead.equals(false))
          ..orderBy([
            (n) => OrderingTerm.desc(n.createAt),
          ]))
        .get();
  }

  // Get notification by ID
  Future<NotificationEntity?> getNotificationById(String id) {
    return (select(notifications)..where((n) => n.id.equals(id)))
        .getSingleOrNull();
  }

  // Insert single notification (insert or update on conflict)
  Future<void> insertNotification(NotificationEntity notification) {
    return into(notifications).insertOnConflictUpdate(notification);
  }

  // Batch insert notifications
  Future<void> insertNotifications(List<NotificationEntity> items) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(notifications, items);
    });
  }

  // Mark notification as read
  Future<void> markAsRead(String id) {
    return (update(notifications)..where((n) => n.id.equals(id))).write(
      NotificationsCompanion(
        isRead: const Value(true),
        readAt: Value(DateTime.now()),
      ),
    );
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() {
    return (update(notifications)..where((n) => n.isRead.equals(false))).write(
      NotificationsCompanion(
        isRead: const Value(true),
        readAt: Value(DateTime.now()),
      ),
    );
  }

  // Delete notification by ID
  Future<void> deleteNotification(String id) {
    return (delete(notifications)..where((n) => n.id.equals(id))).go();
  }

  // Delete notifications older than specified date (cache cleanup)
  Future<void> deleteOlderThan(DateTime date) {
    return (delete(notifications)..where((n) => n.createAt.isSmallerThan(Variable(date)))).go();
  }

  // Keep only latest N notifications
  Future<void> keepLatest(int count) async {
    final all = await (select(notifications)
          ..orderBy([
            (n) => OrderingTerm.desc(n.createAt),
          ]))
        .get();

    if (all.length > count) {
      final toDelete = all.skip(count).map((n) => n.id).toList();
      await (delete(notifications)..where((n) => n.id.isIn(toDelete))).go();
    }
  }

  // Clear all notifications
  Future<void> clearAll() {
    return delete(notifications).go();
  }

  // Get total count
  Future<int> getCount() async {
    final count = countAll();
    final query = selectOnly(notifications)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }
}
