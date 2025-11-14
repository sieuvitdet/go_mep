import 'package:flutter/material.dart';
import '../local/database/app_database.dart';
import '../local/database/daos/user_dao.dart';
import '../model/res/user_me_res_model.dart';

/// Repository for managing authentication with local database
///
/// Features:
/// 1. Seed default user on first launch
/// 2. Validate login credentials
/// 3. Get current logged-in user
class AuthRepository {
  final UserDao _userDao;

  AuthRepository(this._userDao);

  /// Default user credentials for testing
  static const String defaultPhoneNumber = '0123456789';
  static const String defaultPassword = 'Admin@123';
  static const String defaultFullName = 'Dinh Hai Minh';
  static const String defaultHashId = 'default_user_001';

  /// Seed default user if database is empty
  Future<void> seedDefaultUser() async {
    final hasUser = await _userDao.hasUser();

    if (!hasUser) {
      debugPrint('📦 Seeding default user into database...');

      final defaultUser = UserEntity(
        id: 1,
        hashId: defaultHashId,
        phoneNumber: defaultPhoneNumber,
        fullName: defaultFullName,
        dateOfBirth: '01-01-2006',
        address: 'Hà Nội, Việt Nam',
        avatar: null,
        userType: 'admin',
        isActive: true,
        isSuperuser: true,
        updatedAt: DateTime.now(),
      );

      await _userDao.upsertUser(defaultUser);
      debugPrint('✅ Default user seeded successfully');
      debugPrint('   📱 Phone: $defaultPhoneNumber');
      debugPrint('   🔑 Password: $defaultPassword');
    }
  }

  /// Validate login credentials
  /// For demo purposes, validates that user exists and password is not empty
  /// In production, this would validate against hashed passwords in database
  Future<UserMeResModel?> login({
    required String phoneNumber,
    required String password,
  }) async {
    debugPrint('🔐 Attempting login for phone: $phoneNumber');

    // Check if password is provided
    if (password.isEmpty) {
      debugPrint('❌ Login failed: Password is empty');
      return null;
    }

    // Check if user exists in database
    final user = await _userDao.getUserByPhone(phoneNumber);

    if (user != null) {
      // For demo: Allow login if user exists and password is not empty
      // In production, verify password hash here
      debugPrint('✅ Login successful for user: ${user.fullName}');
      return _entityToModel(user);
    }

    debugPrint('❌ Login failed: User not found');
    return null;
  }

  /// Get user by phone number
  Future<UserMeResModel?> getUserByPhone(String phoneNumber) async {
    final entity = await _userDao.getUserByPhone(phoneNumber);
    if (entity == null) return null;
    return _entityToModel(entity);
  }

  /// Check if default user exists
  Future<bool> hasDefaultUser() async {
    final user = await _userDao.getUserByPhone(defaultPhoneNumber);
    return user != null;
  }

  /// Register a new user
  /// Returns the created user if successful, null if phone number already exists
  Future<UserMeResModel?> register({
    required String phoneNumber,
    required String password,
    required String fullName,
    String? dateOfBirth,
    String? address,
  }) async {
    debugPrint('📝 Attempting to register user: $phoneNumber');

    // Check if phone number already exists
    final existingUser = await _userDao.getUserByPhone(phoneNumber);
    if (existingUser != null) {
      debugPrint('❌ Registration failed: Phone number already exists');
      return null;
    }

    // Create new user entity
    final newUser = UserEntity(
      id: DateTime.now().millisecondsSinceEpoch, // Use timestamp as ID
      hashId: 'user_${DateTime.now().millisecondsSinceEpoch}',
      phoneNumber: phoneNumber,
      fullName: fullName,
      dateOfBirth: dateOfBirth ?? '',
      address: address ?? '',
      avatar: null,
      userType: 'user', // Regular user
      isActive: true,
      isSuperuser: false,
      updatedAt: DateTime.now(),
    );

    // Save to database
    await _userDao.upsertUser(newUser);

    // Note: In production, you would hash and store the password securely
    // For now, we're just storing user info without password
    debugPrint('✅ User registered successfully: $fullName');

    return _entityToModel(newUser);
  }

  /// Check if phone number is already registered
  Future<bool> isPhoneNumberExists(String phoneNumber) async {
    final user = await _userDao.getUserByPhone(phoneNumber);
    return user != null;
  }

  // Helper method to convert Entity to Model
  UserMeResModel _entityToModel(UserEntity entity) {
    return UserMeResModel(
      id: entity.id,
      hashId: entity.hashId,
      phoneNumber: entity.phoneNumber,
      fullName: entity.fullName,
      dateOfBirth: entity.dateOfBirth,
      address: entity.address,
      avatar: entity.avatar,
      userType: entity.userType,
      isActive: entity.isActive,
      isSuperuser: entity.isSuperuser,
    );
  }
}
