import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift_sqflite/drift_sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/notifications_table.dart';
import 'tables/users_table.dart';
import 'tables/places_table.dart';
import 'tables/waterlogging_table.dart';
import 'tables/traffic_jam_table.dart';
import 'tables/temporary_report_marker_table.dart';
import 'daos/notification_dao.dart';
import 'daos/user_dao.dart';
import 'daos/places_dao.dart';
import 'daos/waterlogging_dao.dart';
import 'daos/traffic_jam_dao.dart';
import 'daos/temporary_report_marker_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Notifications, Users, Places, Waterloggings, TrafficJams, TemporaryReportMarkers],
  daos: [NotificationDao, UserDao, PlacesDao, WaterloggingDao, TrafficJamDao, TemporaryReportMarkerDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Run all migrations sequentially
          for (var version = from; version < to; version++) {
            switch (version) {
              case 1:
                // Migration to version 2: Add avatar column
                await m.addColumn(users, users.avatar);
                break;
              case 2:
                // Migration to version 3: Add waterlogging table
                await m.createTable(waterloggings);
                break;
              case 3:
                // Migration to version 4: Add traffic jam table
                await m.createTable(trafficJams);
                break;
              case 4:
                // Migration to version 5: Add temporary report markers table
                await m.createTable(temporaryReportMarkers);
                break;
              case 5:
                // Migration to version 6: Ensure temporary report markers table exists
                try {
                  await m.createTable(temporaryReportMarkers);
                } catch (e) {
                  // Table already exists, ignore
                }
                break;
            }
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
