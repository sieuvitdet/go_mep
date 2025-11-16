import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift_sqflite/drift_sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/notifications_table.dart';
import 'tables/users_table.dart';
import 'tables/places_table.dart';
import 'tables/waterlogging_table.dart';
import 'daos/notification_dao.dart';
import 'daos/user_dao.dart';
import 'daos/places_dao.dart';
import 'daos/waterlogging_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Notifications, Users, Places, Waterloggings],
  daos: [NotificationDao, UserDao, PlacesDao, WaterloggingDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Migration from version 1 to 2: Add avatar column
          if (from == 1 && to == 2) {
            await m.addColumn(users, users.avatar);
          }
          // Migration from version 2 to 3: Add waterlogging table
          if (from == 2 && to == 3) {
            await m.createTable(waterloggings);
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'go_mep.sqlite'));
    return SqfliteQueryExecutor.inDatabaseFolder(
      path: file.path,
      logStatements: true, // Enable SQL logging in debug mode
    );
  });
}
