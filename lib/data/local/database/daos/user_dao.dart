import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/users_table.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(AppDatabase db) : super(db);

  // Watch current user (reactive stream)
  Stream<UserEntity?> watchCurrentUser() {
    return select(users).watchSingleOrNull();
  }

  // Get current user (one-time query)
  Future<UserEntity?> getCurrentUser() {
    return select(users).getSingleOrNull();
  }

  // Get user by ID
  Future<UserEntity?> getUserById(int id) {
    return (select(users)..where((u) => u.id.equals(id))).getSingleOrNull();
  }

  // Get user by phone number (for authentication)
  Future<UserEntity?> getUserByPhone(String phoneNumber) {
    return (select(users)..where((u) => u.phoneNumber.equals(phoneNumber))).getSingleOrNull();
  }

  // Insert or update user
  Future<void> upsertUser(UserEntity user) {
    return into(users).insertOnConflictUpdate(
      user.copyWith(updatedAt: DateTime.now()),
    );
  }

  // Update user profile
  Future<void> updateUser(UsersCompanion user) {
    return update(users).write(
      user.copyWith(updatedAt: Value(DateTime.now())),
    );
  }

  // Delete user (logout)
  Future<void> deleteCurrentUser() {
    return delete(users).go();
  }

  // Check if user exists
  Future<bool> hasUser() async {
    final user = await getCurrentUser();
    return user != null;
  }

  // Check if user data is stale (older than specified duration)
  Future<bool> isUserDataStale(Duration maxAge) async {
    final user = await getCurrentUser();
    if (user == null) return true;

    final now = DateTime.now();
    final age = now.difference(user.updatedAt);
    return age > maxAge;
  }
}
