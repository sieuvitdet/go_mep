import 'package:drift/drift.dart';

@DataClassName('UserEntity')
class Users extends Table {
  IntColumn get id => integer()();
  TextColumn get hashId => text().nullable()();
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get fullName => text().nullable()();
  TextColumn get dateOfBirth => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get avatar => text().nullable()(); // Avatar URL or base64
  TextColumn get userType => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isSuperuser => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
