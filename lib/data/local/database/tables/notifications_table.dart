import 'package:drift/drift.dart';

@DataClassName('NotificationEntity')
class Notifications extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get notificationId => text().nullable()();
  TextColumn get title => text()();
  TextColumn get content => text()();
  TextColumn get targetKey => text().nullable()();
  TextColumn get targetData => text().nullable()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createAt => dateTime()();
  DateTimeColumn get readAt => dateTime().nullable()();
  DateTimeColumn get deliveredAt => dateTime().nullable()();
  TextColumn get type => text().nullable()();
  TextColumn get priority => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
