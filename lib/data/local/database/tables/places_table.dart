import 'package:drift/drift.dart';

@DataClassName('PlaceEntity')
class Places extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get address => text().nullable()();
  TextColumn get formattedAddress => text().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  RealColumn get rating => real().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get website => text().nullable()();
  TextColumn get types => text().nullable()(); // Comma-separated types
  BoolColumn get isOpen => boolean().nullable()();
  TextColumn get openingHours => text().nullable()();
  TextColumn get priceLevel => text().nullable()();
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
