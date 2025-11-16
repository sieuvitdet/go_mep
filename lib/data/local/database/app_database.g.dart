// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $NotificationsTable extends Notifications
    with TableInfo<$NotificationsTable, NotificationEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notificationIdMeta =
      const VerificationMeta('notificationId');
  @override
  late final GeneratedColumn<String> notificationId = GeneratedColumn<String>(
      'notification_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetKeyMeta =
      const VerificationMeta('targetKey');
  @override
  late final GeneratedColumn<String> targetKey = GeneratedColumn<String>(
      'target_key', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _targetDataMeta =
      const VerificationMeta('targetData');
  @override
  late final GeneratedColumn<String> targetData = GeneratedColumn<String>(
      'target_data', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
      'is_read', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_read" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createAtMeta =
      const VerificationMeta('createAt');
  @override
  late final GeneratedColumn<DateTime> createAt = GeneratedColumn<DateTime>(
      'create_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _readAtMeta = const VerificationMeta('readAt');
  @override
  late final GeneratedColumn<DateTime> readAt = GeneratedColumn<DateTime>(
      'read_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _deliveredAtMeta =
      const VerificationMeta('deliveredAt');
  @override
  late final GeneratedColumn<DateTime> deliveredAt = GeneratedColumn<DateTime>(
      'delivered_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
      'priority', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        notificationId,
        title,
        content,
        targetKey,
        targetData,
        isRead,
        createAt,
        readAt,
        deliveredAt,
        type,
        priority
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notifications';
  @override
  VerificationContext validateIntegrity(Insertable<NotificationEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('notification_id')) {
      context.handle(
          _notificationIdMeta,
          notificationId.isAcceptableOrUnknown(
              data['notification_id']!, _notificationIdMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('target_key')) {
      context.handle(_targetKeyMeta,
          targetKey.isAcceptableOrUnknown(data['target_key']!, _targetKeyMeta));
    }
    if (data.containsKey('target_data')) {
      context.handle(
          _targetDataMeta,
          targetData.isAcceptableOrUnknown(
              data['target_data']!, _targetDataMeta));
    }
    if (data.containsKey('is_read')) {
      context.handle(_isReadMeta,
          isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta));
    }
    if (data.containsKey('create_at')) {
      context.handle(_createAtMeta,
          createAt.isAcceptableOrUnknown(data['create_at']!, _createAtMeta));
    } else if (isInserting) {
      context.missing(_createAtMeta);
    }
    if (data.containsKey('read_at')) {
      context.handle(_readAtMeta,
          readAt.isAcceptableOrUnknown(data['read_at']!, _readAtMeta));
    }
    if (data.containsKey('delivered_at')) {
      context.handle(
          _deliveredAtMeta,
          deliveredAt.isAcceptableOrUnknown(
              data['delivered_at']!, _deliveredAtMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotificationEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      notificationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notification_id']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      targetKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_key']),
      targetData: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_data']),
      isRead: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_read'])!,
      createAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}create_at'])!,
      readAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}read_at']),
      deliveredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}delivered_at']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type']),
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}priority']),
    );
  }

  @override
  $NotificationsTable createAlias(String alias) {
    return $NotificationsTable(attachedDatabase, alias);
  }
}

class NotificationEntity extends DataClass
    implements Insertable<NotificationEntity> {
  final String id;
  final String userId;
  final String? notificationId;
  final String title;
  final String content;
  final String? targetKey;
  final String? targetData;
  final bool isRead;
  final DateTime createAt;
  final DateTime? readAt;
  final DateTime? deliveredAt;
  final String? type;
  final String? priority;
  const NotificationEntity(
      {required this.id,
      required this.userId,
      this.notificationId,
      required this.title,
      required this.content,
      this.targetKey,
      this.targetData,
      required this.isRead,
      required this.createAt,
      this.readAt,
      this.deliveredAt,
      this.type,
      this.priority});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || notificationId != null) {
      map['notification_id'] = Variable<String>(notificationId);
    }
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || targetKey != null) {
      map['target_key'] = Variable<String>(targetKey);
    }
    if (!nullToAbsent || targetData != null) {
      map['target_data'] = Variable<String>(targetData);
    }
    map['is_read'] = Variable<bool>(isRead);
    map['create_at'] = Variable<DateTime>(createAt);
    if (!nullToAbsent || readAt != null) {
      map['read_at'] = Variable<DateTime>(readAt);
    }
    if (!nullToAbsent || deliveredAt != null) {
      map['delivered_at'] = Variable<DateTime>(deliveredAt);
    }
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    if (!nullToAbsent || priority != null) {
      map['priority'] = Variable<String>(priority);
    }
    return map;
  }

  NotificationsCompanion toCompanion(bool nullToAbsent) {
    return NotificationsCompanion(
      id: Value(id),
      userId: Value(userId),
      notificationId: notificationId == null && nullToAbsent
          ? const Value.absent()
          : Value(notificationId),
      title: Value(title),
      content: Value(content),
      targetKey: targetKey == null && nullToAbsent
          ? const Value.absent()
          : Value(targetKey),
      targetData: targetData == null && nullToAbsent
          ? const Value.absent()
          : Value(targetData),
      isRead: Value(isRead),
      createAt: Value(createAt),
      readAt:
          readAt == null && nullToAbsent ? const Value.absent() : Value(readAt),
      deliveredAt: deliveredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deliveredAt),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      priority: priority == null && nullToAbsent
          ? const Value.absent()
          : Value(priority),
    );
  }

  factory NotificationEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationEntity(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      notificationId: serializer.fromJson<String?>(json['notificationId']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      targetKey: serializer.fromJson<String?>(json['targetKey']),
      targetData: serializer.fromJson<String?>(json['targetData']),
      isRead: serializer.fromJson<bool>(json['isRead']),
      createAt: serializer.fromJson<DateTime>(json['createAt']),
      readAt: serializer.fromJson<DateTime?>(json['readAt']),
      deliveredAt: serializer.fromJson<DateTime?>(json['deliveredAt']),
      type: serializer.fromJson<String?>(json['type']),
      priority: serializer.fromJson<String?>(json['priority']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'notificationId': serializer.toJson<String?>(notificationId),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'targetKey': serializer.toJson<String?>(targetKey),
      'targetData': serializer.toJson<String?>(targetData),
      'isRead': serializer.toJson<bool>(isRead),
      'createAt': serializer.toJson<DateTime>(createAt),
      'readAt': serializer.toJson<DateTime?>(readAt),
      'deliveredAt': serializer.toJson<DateTime?>(deliveredAt),
      'type': serializer.toJson<String?>(type),
      'priority': serializer.toJson<String?>(priority),
    };
  }

  NotificationEntity copyWith(
          {String? id,
          String? userId,
          Value<String?> notificationId = const Value.absent(),
          String? title,
          String? content,
          Value<String?> targetKey = const Value.absent(),
          Value<String?> targetData = const Value.absent(),
          bool? isRead,
          DateTime? createAt,
          Value<DateTime?> readAt = const Value.absent(),
          Value<DateTime?> deliveredAt = const Value.absent(),
          Value<String?> type = const Value.absent(),
          Value<String?> priority = const Value.absent()}) =>
      NotificationEntity(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        notificationId:
            notificationId.present ? notificationId.value : this.notificationId,
        title: title ?? this.title,
        content: content ?? this.content,
        targetKey: targetKey.present ? targetKey.value : this.targetKey,
        targetData: targetData.present ? targetData.value : this.targetData,
        isRead: isRead ?? this.isRead,
        createAt: createAt ?? this.createAt,
        readAt: readAt.present ? readAt.value : this.readAt,
        deliveredAt: deliveredAt.present ? deliveredAt.value : this.deliveredAt,
        type: type.present ? type.value : this.type,
        priority: priority.present ? priority.value : this.priority,
      );
  NotificationEntity copyWithCompanion(NotificationsCompanion data) {
    return NotificationEntity(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      notificationId: data.notificationId.present
          ? data.notificationId.value
          : this.notificationId,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      targetKey: data.targetKey.present ? data.targetKey.value : this.targetKey,
      targetData:
          data.targetData.present ? data.targetData.value : this.targetData,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
      createAt: data.createAt.present ? data.createAt.value : this.createAt,
      readAt: data.readAt.present ? data.readAt.value : this.readAt,
      deliveredAt:
          data.deliveredAt.present ? data.deliveredAt.value : this.deliveredAt,
      type: data.type.present ? data.type.value : this.type,
      priority: data.priority.present ? data.priority.value : this.priority,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationEntity(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('notificationId: $notificationId, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('targetKey: $targetKey, ')
          ..write('targetData: $targetData, ')
          ..write('isRead: $isRead, ')
          ..write('createAt: $createAt, ')
          ..write('readAt: $readAt, ')
          ..write('deliveredAt: $deliveredAt, ')
          ..write('type: $type, ')
          ..write('priority: $priority')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userId,
      notificationId,
      title,
      content,
      targetKey,
      targetData,
      isRead,
      createAt,
      readAt,
      deliveredAt,
      type,
      priority);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationEntity &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.notificationId == this.notificationId &&
          other.title == this.title &&
          other.content == this.content &&
          other.targetKey == this.targetKey &&
          other.targetData == this.targetData &&
          other.isRead == this.isRead &&
          other.createAt == this.createAt &&
          other.readAt == this.readAt &&
          other.deliveredAt == this.deliveredAt &&
          other.type == this.type &&
          other.priority == this.priority);
}

class NotificationsCompanion extends UpdateCompanion<NotificationEntity> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String?> notificationId;
  final Value<String> title;
  final Value<String> content;
  final Value<String?> targetKey;
  final Value<String?> targetData;
  final Value<bool> isRead;
  final Value<DateTime> createAt;
  final Value<DateTime?> readAt;
  final Value<DateTime?> deliveredAt;
  final Value<String?> type;
  final Value<String?> priority;
  final Value<int> rowid;
  const NotificationsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.notificationId = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.targetKey = const Value.absent(),
    this.targetData = const Value.absent(),
    this.isRead = const Value.absent(),
    this.createAt = const Value.absent(),
    this.readAt = const Value.absent(),
    this.deliveredAt = const Value.absent(),
    this.type = const Value.absent(),
    this.priority = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotificationsCompanion.insert({
    required String id,
    required String userId,
    this.notificationId = const Value.absent(),
    required String title,
    required String content,
    this.targetKey = const Value.absent(),
    this.targetData = const Value.absent(),
    this.isRead = const Value.absent(),
    required DateTime createAt,
    this.readAt = const Value.absent(),
    this.deliveredAt = const Value.absent(),
    this.type = const Value.absent(),
    this.priority = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        title = Value(title),
        content = Value(content),
        createAt = Value(createAt);
  static Insertable<NotificationEntity> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? notificationId,
    Expression<String>? title,
    Expression<String>? content,
    Expression<String>? targetKey,
    Expression<String>? targetData,
    Expression<bool>? isRead,
    Expression<DateTime>? createAt,
    Expression<DateTime>? readAt,
    Expression<DateTime>? deliveredAt,
    Expression<String>? type,
    Expression<String>? priority,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (notificationId != null) 'notification_id': notificationId,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (targetKey != null) 'target_key': targetKey,
      if (targetData != null) 'target_data': targetData,
      if (isRead != null) 'is_read': isRead,
      if (createAt != null) 'create_at': createAt,
      if (readAt != null) 'read_at': readAt,
      if (deliveredAt != null) 'delivered_at': deliveredAt,
      if (type != null) 'type': type,
      if (priority != null) 'priority': priority,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotificationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String?>? notificationId,
      Value<String>? title,
      Value<String>? content,
      Value<String?>? targetKey,
      Value<String?>? targetData,
      Value<bool>? isRead,
      Value<DateTime>? createAt,
      Value<DateTime?>? readAt,
      Value<DateTime?>? deliveredAt,
      Value<String?>? type,
      Value<String?>? priority,
      Value<int>? rowid}) {
    return NotificationsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      notificationId: notificationId ?? this.notificationId,
      title: title ?? this.title,
      content: content ?? this.content,
      targetKey: targetKey ?? this.targetKey,
      targetData: targetData ?? this.targetData,
      isRead: isRead ?? this.isRead,
      createAt: createAt ?? this.createAt,
      readAt: readAt ?? this.readAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (notificationId.present) {
      map['notification_id'] = Variable<String>(notificationId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (targetKey.present) {
      map['target_key'] = Variable<String>(targetKey.value);
    }
    if (targetData.present) {
      map['target_data'] = Variable<String>(targetData.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (createAt.present) {
      map['create_at'] = Variable<DateTime>(createAt.value);
    }
    if (readAt.present) {
      map['read_at'] = Variable<DateTime>(readAt.value);
    }
    if (deliveredAt.present) {
      map['delivered_at'] = Variable<DateTime>(deliveredAt.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('notificationId: $notificationId, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('targetKey: $targetKey, ')
          ..write('targetData: $targetData, ')
          ..write('isRead: $isRead, ')
          ..write('createAt: $createAt, ')
          ..write('readAt: $readAt, ')
          ..write('deliveredAt: $deliveredAt, ')
          ..write('type: $type, ')
          ..write('priority: $priority, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, UserEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _hashIdMeta = const VerificationMeta('hashId');
  @override
  late final GeneratedColumn<String> hashId = GeneratedColumn<String>(
      'hash_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneNumberMeta =
      const VerificationMeta('phoneNumber');
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
      'phone_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fullNameMeta =
      const VerificationMeta('fullName');
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
      'full_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateOfBirthMeta =
      const VerificationMeta('dateOfBirth');
  @override
  late final GeneratedColumn<String> dateOfBirth = GeneratedColumn<String>(
      'date_of_birth', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  @override
  late final GeneratedColumn<String> avatar = GeneratedColumn<String>(
      'avatar', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _userTypeMeta =
      const VerificationMeta('userType');
  @override
  late final GeneratedColumn<String> userType = GeneratedColumn<String>(
      'user_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isSuperuserMeta =
      const VerificationMeta('isSuperuser');
  @override
  late final GeneratedColumn<bool> isSuperuser = GeneratedColumn<bool>(
      'is_superuser', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_superuser" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        hashId,
        phoneNumber,
        fullName,
        dateOfBirth,
        address,
        avatar,
        userType,
        isActive,
        isSuperuser,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<UserEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('hash_id')) {
      context.handle(_hashIdMeta,
          hashId.isAcceptableOrUnknown(data['hash_id']!, _hashIdMeta));
    }
    if (data.containsKey('phone_number')) {
      context.handle(
          _phoneNumberMeta,
          phoneNumber.isAcceptableOrUnknown(
              data['phone_number']!, _phoneNumberMeta));
    }
    if (data.containsKey('full_name')) {
      context.handle(_fullNameMeta,
          fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta));
    }
    if (data.containsKey('date_of_birth')) {
      context.handle(
          _dateOfBirthMeta,
          dateOfBirth.isAcceptableOrUnknown(
              data['date_of_birth']!, _dateOfBirthMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('avatar')) {
      context.handle(_avatarMeta,
          avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta));
    }
    if (data.containsKey('user_type')) {
      context.handle(_userTypeMeta,
          userType.isAcceptableOrUnknown(data['user_type']!, _userTypeMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('is_superuser')) {
      context.handle(
          _isSuperuserMeta,
          isSuperuser.isAcceptableOrUnknown(
              data['is_superuser']!, _isSuperuserMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      hashId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hash_id']),
      phoneNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone_number']),
      fullName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}full_name']),
      dateOfBirth: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date_of_birth']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      avatar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar']),
      userType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_type']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      isSuperuser: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_superuser'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class UserEntity extends DataClass implements Insertable<UserEntity> {
  final int id;
  final String? hashId;
  final String? phoneNumber;
  final String? fullName;
  final String? dateOfBirth;
  final String? address;
  final String? avatar;
  final String? userType;
  final bool isActive;
  final bool isSuperuser;
  final DateTime updatedAt;
  const UserEntity(
      {required this.id,
      this.hashId,
      this.phoneNumber,
      this.fullName,
      this.dateOfBirth,
      this.address,
      this.avatar,
      this.userType,
      required this.isActive,
      required this.isSuperuser,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || hashId != null) {
      map['hash_id'] = Variable<String>(hashId);
    }
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    if (!nullToAbsent || fullName != null) {
      map['full_name'] = Variable<String>(fullName);
    }
    if (!nullToAbsent || dateOfBirth != null) {
      map['date_of_birth'] = Variable<String>(dateOfBirth);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || avatar != null) {
      map['avatar'] = Variable<String>(avatar);
    }
    if (!nullToAbsent || userType != null) {
      map['user_type'] = Variable<String>(userType);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['is_superuser'] = Variable<bool>(isSuperuser);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      hashId:
          hashId == null && nullToAbsent ? const Value.absent() : Value(hashId),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      fullName: fullName == null && nullToAbsent
          ? const Value.absent()
          : Value(fullName),
      dateOfBirth: dateOfBirth == null && nullToAbsent
          ? const Value.absent()
          : Value(dateOfBirth),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      avatar:
          avatar == null && nullToAbsent ? const Value.absent() : Value(avatar),
      userType: userType == null && nullToAbsent
          ? const Value.absent()
          : Value(userType),
      isActive: Value(isActive),
      isSuperuser: Value(isSuperuser),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserEntity(
      id: serializer.fromJson<int>(json['id']),
      hashId: serializer.fromJson<String?>(json['hashId']),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
      fullName: serializer.fromJson<String?>(json['fullName']),
      dateOfBirth: serializer.fromJson<String?>(json['dateOfBirth']),
      address: serializer.fromJson<String?>(json['address']),
      avatar: serializer.fromJson<String?>(json['avatar']),
      userType: serializer.fromJson<String?>(json['userType']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isSuperuser: serializer.fromJson<bool>(json['isSuperuser']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'hashId': serializer.toJson<String?>(hashId),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
      'fullName': serializer.toJson<String?>(fullName),
      'dateOfBirth': serializer.toJson<String?>(dateOfBirth),
      'address': serializer.toJson<String?>(address),
      'avatar': serializer.toJson<String?>(avatar),
      'userType': serializer.toJson<String?>(userType),
      'isActive': serializer.toJson<bool>(isActive),
      'isSuperuser': serializer.toJson<bool>(isSuperuser),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserEntity copyWith(
          {int? id,
          Value<String?> hashId = const Value.absent(),
          Value<String?> phoneNumber = const Value.absent(),
          Value<String?> fullName = const Value.absent(),
          Value<String?> dateOfBirth = const Value.absent(),
          Value<String?> address = const Value.absent(),
          Value<String?> avatar = const Value.absent(),
          Value<String?> userType = const Value.absent(),
          bool? isActive,
          bool? isSuperuser,
          DateTime? updatedAt}) =>
      UserEntity(
        id: id ?? this.id,
        hashId: hashId.present ? hashId.value : this.hashId,
        phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
        fullName: fullName.present ? fullName.value : this.fullName,
        dateOfBirth: dateOfBirth.present ? dateOfBirth.value : this.dateOfBirth,
        address: address.present ? address.value : this.address,
        avatar: avatar.present ? avatar.value : this.avatar,
        userType: userType.present ? userType.value : this.userType,
        isActive: isActive ?? this.isActive,
        isSuperuser: isSuperuser ?? this.isSuperuser,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  UserEntity copyWithCompanion(UsersCompanion data) {
    return UserEntity(
      id: data.id.present ? data.id.value : this.id,
      hashId: data.hashId.present ? data.hashId.value : this.hashId,
      phoneNumber:
          data.phoneNumber.present ? data.phoneNumber.value : this.phoneNumber,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      dateOfBirth:
          data.dateOfBirth.present ? data.dateOfBirth.value : this.dateOfBirth,
      address: data.address.present ? data.address.value : this.address,
      avatar: data.avatar.present ? data.avatar.value : this.avatar,
      userType: data.userType.present ? data.userType.value : this.userType,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isSuperuser:
          data.isSuperuser.present ? data.isSuperuser.value : this.isSuperuser,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserEntity(')
          ..write('id: $id, ')
          ..write('hashId: $hashId, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('fullName: $fullName, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('address: $address, ')
          ..write('avatar: $avatar, ')
          ..write('userType: $userType, ')
          ..write('isActive: $isActive, ')
          ..write('isSuperuser: $isSuperuser, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, hashId, phoneNumber, fullName,
      dateOfBirth, address, avatar, userType, isActive, isSuperuser, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserEntity &&
          other.id == this.id &&
          other.hashId == this.hashId &&
          other.phoneNumber == this.phoneNumber &&
          other.fullName == this.fullName &&
          other.dateOfBirth == this.dateOfBirth &&
          other.address == this.address &&
          other.avatar == this.avatar &&
          other.userType == this.userType &&
          other.isActive == this.isActive &&
          other.isSuperuser == this.isSuperuser &&
          other.updatedAt == this.updatedAt);
}

class UsersCompanion extends UpdateCompanion<UserEntity> {
  final Value<int> id;
  final Value<String?> hashId;
  final Value<String?> phoneNumber;
  final Value<String?> fullName;
  final Value<String?> dateOfBirth;
  final Value<String?> address;
  final Value<String?> avatar;
  final Value<String?> userType;
  final Value<bool> isActive;
  final Value<bool> isSuperuser;
  final Value<DateTime> updatedAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.hashId = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.fullName = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.address = const Value.absent(),
    this.avatar = const Value.absent(),
    this.userType = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isSuperuser = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    this.hashId = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.fullName = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.address = const Value.absent(),
    this.avatar = const Value.absent(),
    this.userType = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isSuperuser = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<UserEntity> custom({
    Expression<int>? id,
    Expression<String>? hashId,
    Expression<String>? phoneNumber,
    Expression<String>? fullName,
    Expression<String>? dateOfBirth,
    Expression<String>? address,
    Expression<String>? avatar,
    Expression<String>? userType,
    Expression<bool>? isActive,
    Expression<bool>? isSuperuser,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hashId != null) 'hash_id': hashId,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (fullName != null) 'full_name': fullName,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (address != null) 'address': address,
      if (avatar != null) 'avatar': avatar,
      if (userType != null) 'user_type': userType,
      if (isActive != null) 'is_active': isActive,
      if (isSuperuser != null) 'is_superuser': isSuperuser,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String?>? hashId,
      Value<String?>? phoneNumber,
      Value<String?>? fullName,
      Value<String?>? dateOfBirth,
      Value<String?>? address,
      Value<String?>? avatar,
      Value<String?>? userType,
      Value<bool>? isActive,
      Value<bool>? isSuperuser,
      Value<DateTime>? updatedAt}) {
    return UsersCompanion(
      id: id ?? this.id,
      hashId: hashId ?? this.hashId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
      avatar: avatar ?? this.avatar,
      userType: userType ?? this.userType,
      isActive: isActive ?? this.isActive,
      isSuperuser: isSuperuser ?? this.isSuperuser,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (hashId.present) {
      map['hash_id'] = Variable<String>(hashId.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<String>(dateOfBirth.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<String>(avatar.value);
    }
    if (userType.present) {
      map['user_type'] = Variable<String>(userType.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isSuperuser.present) {
      map['is_superuser'] = Variable<bool>(isSuperuser.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('hashId: $hashId, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('fullName: $fullName, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('address: $address, ')
          ..write('avatar: $avatar, ')
          ..write('userType: $userType, ')
          ..write('isActive: $isActive, ')
          ..write('isSuperuser: $isSuperuser, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PlacesTable extends Places with TableInfo<$PlacesTable, PlaceEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlacesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _formattedAddressMeta =
      const VerificationMeta('formattedAddress');
  @override
  late final GeneratedColumn<String> formattedAddress = GeneratedColumn<String>(
      'formatted_address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<double> rating = GeneratedColumn<double>(
      'rating', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _websiteMeta =
      const VerificationMeta('website');
  @override
  late final GeneratedColumn<String> website = GeneratedColumn<String>(
      'website', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typesMeta = const VerificationMeta('types');
  @override
  late final GeneratedColumn<String> types = GeneratedColumn<String>(
      'types', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isOpenMeta = const VerificationMeta('isOpen');
  @override
  late final GeneratedColumn<bool> isOpen = GeneratedColumn<bool>(
      'is_open', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_open" IN (0, 1))'));
  static const VerificationMeta _openingHoursMeta =
      const VerificationMeta('openingHours');
  @override
  late final GeneratedColumn<String> openingHours = GeneratedColumn<String>(
      'opening_hours', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _priceLevelMeta =
      const VerificationMeta('priceLevel');
  @override
  late final GeneratedColumn<String> priceLevel = GeneratedColumn<String>(
      'price_level', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cachedAtMeta =
      const VerificationMeta('cachedAt');
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
      'cached_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        address,
        formattedAddress,
        latitude,
        longitude,
        rating,
        phone,
        website,
        types,
        isOpen,
        openingHours,
        priceLevel,
        cachedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'places';
  @override
  VerificationContext validateIntegrity(Insertable<PlaceEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('formatted_address')) {
      context.handle(
          _formattedAddressMeta,
          formattedAddress.isAcceptableOrUnknown(
              data['formatted_address']!, _formattedAddressMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    }
    if (data.containsKey('rating')) {
      context.handle(_ratingMeta,
          rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('website')) {
      context.handle(_websiteMeta,
          website.isAcceptableOrUnknown(data['website']!, _websiteMeta));
    }
    if (data.containsKey('types')) {
      context.handle(
          _typesMeta, types.isAcceptableOrUnknown(data['types']!, _typesMeta));
    }
    if (data.containsKey('is_open')) {
      context.handle(_isOpenMeta,
          isOpen.isAcceptableOrUnknown(data['is_open']!, _isOpenMeta));
    }
    if (data.containsKey('opening_hours')) {
      context.handle(
          _openingHoursMeta,
          openingHours.isAcceptableOrUnknown(
              data['opening_hours']!, _openingHoursMeta));
    }
    if (data.containsKey('price_level')) {
      context.handle(
          _priceLevelMeta,
          priceLevel.isAcceptableOrUnknown(
              data['price_level']!, _priceLevelMeta));
    }
    if (data.containsKey('cached_at')) {
      context.handle(_cachedAtMeta,
          cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlaceEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaceEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      formattedAddress: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}formatted_address']),
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude']),
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude']),
      rating: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}rating']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      website: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}website']),
      types: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}types']),
      isOpen: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_open']),
      openingHours: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}opening_hours']),
      priceLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}price_level']),
      cachedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}cached_at'])!,
    );
  }

  @override
  $PlacesTable createAlias(String alias) {
    return $PlacesTable(attachedDatabase, alias);
  }
}

class PlaceEntity extends DataClass implements Insertable<PlaceEntity> {
  final String id;
  final String name;
  final String? address;
  final String? formattedAddress;
  final double? latitude;
  final double? longitude;
  final double? rating;
  final String? phone;
  final String? website;
  final String? types;
  final bool? isOpen;
  final String? openingHours;
  final String? priceLevel;
  final DateTime cachedAt;
  const PlaceEntity(
      {required this.id,
      required this.name,
      this.address,
      this.formattedAddress,
      this.latitude,
      this.longitude,
      this.rating,
      this.phone,
      this.website,
      this.types,
      this.isOpen,
      this.openingHours,
      this.priceLevel,
      required this.cachedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || formattedAddress != null) {
      map['formatted_address'] = Variable<String>(formattedAddress);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || rating != null) {
      map['rating'] = Variable<double>(rating);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || website != null) {
      map['website'] = Variable<String>(website);
    }
    if (!nullToAbsent || types != null) {
      map['types'] = Variable<String>(types);
    }
    if (!nullToAbsent || isOpen != null) {
      map['is_open'] = Variable<bool>(isOpen);
    }
    if (!nullToAbsent || openingHours != null) {
      map['opening_hours'] = Variable<String>(openingHours);
    }
    if (!nullToAbsent || priceLevel != null) {
      map['price_level'] = Variable<String>(priceLevel);
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  PlacesCompanion toCompanion(bool nullToAbsent) {
    return PlacesCompanion(
      id: Value(id),
      name: Value(name),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      formattedAddress: formattedAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(formattedAddress),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      rating:
          rating == null && nullToAbsent ? const Value.absent() : Value(rating),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      website: website == null && nullToAbsent
          ? const Value.absent()
          : Value(website),
      types:
          types == null && nullToAbsent ? const Value.absent() : Value(types),
      isOpen:
          isOpen == null && nullToAbsent ? const Value.absent() : Value(isOpen),
      openingHours: openingHours == null && nullToAbsent
          ? const Value.absent()
          : Value(openingHours),
      priceLevel: priceLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(priceLevel),
      cachedAt: Value(cachedAt),
    );
  }

  factory PlaceEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaceEntity(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String?>(json['address']),
      formattedAddress: serializer.fromJson<String?>(json['formattedAddress']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      rating: serializer.fromJson<double?>(json['rating']),
      phone: serializer.fromJson<String?>(json['phone']),
      website: serializer.fromJson<String?>(json['website']),
      types: serializer.fromJson<String?>(json['types']),
      isOpen: serializer.fromJson<bool?>(json['isOpen']),
      openingHours: serializer.fromJson<String?>(json['openingHours']),
      priceLevel: serializer.fromJson<String?>(json['priceLevel']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String?>(address),
      'formattedAddress': serializer.toJson<String?>(formattedAddress),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'rating': serializer.toJson<double?>(rating),
      'phone': serializer.toJson<String?>(phone),
      'website': serializer.toJson<String?>(website),
      'types': serializer.toJson<String?>(types),
      'isOpen': serializer.toJson<bool?>(isOpen),
      'openingHours': serializer.toJson<String?>(openingHours),
      'priceLevel': serializer.toJson<String?>(priceLevel),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  PlaceEntity copyWith(
          {String? id,
          String? name,
          Value<String?> address = const Value.absent(),
          Value<String?> formattedAddress = const Value.absent(),
          Value<double?> latitude = const Value.absent(),
          Value<double?> longitude = const Value.absent(),
          Value<double?> rating = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          Value<String?> website = const Value.absent(),
          Value<String?> types = const Value.absent(),
          Value<bool?> isOpen = const Value.absent(),
          Value<String?> openingHours = const Value.absent(),
          Value<String?> priceLevel = const Value.absent(),
          DateTime? cachedAt}) =>
      PlaceEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        address: address.present ? address.value : this.address,
        formattedAddress: formattedAddress.present
            ? formattedAddress.value
            : this.formattedAddress,
        latitude: latitude.present ? latitude.value : this.latitude,
        longitude: longitude.present ? longitude.value : this.longitude,
        rating: rating.present ? rating.value : this.rating,
        phone: phone.present ? phone.value : this.phone,
        website: website.present ? website.value : this.website,
        types: types.present ? types.value : this.types,
        isOpen: isOpen.present ? isOpen.value : this.isOpen,
        openingHours:
            openingHours.present ? openingHours.value : this.openingHours,
        priceLevel: priceLevel.present ? priceLevel.value : this.priceLevel,
        cachedAt: cachedAt ?? this.cachedAt,
      );
  PlaceEntity copyWithCompanion(PlacesCompanion data) {
    return PlaceEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      formattedAddress: data.formattedAddress.present
          ? data.formattedAddress.value
          : this.formattedAddress,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      rating: data.rating.present ? data.rating.value : this.rating,
      phone: data.phone.present ? data.phone.value : this.phone,
      website: data.website.present ? data.website.value : this.website,
      types: data.types.present ? data.types.value : this.types,
      isOpen: data.isOpen.present ? data.isOpen.value : this.isOpen,
      openingHours: data.openingHours.present
          ? data.openingHours.value
          : this.openingHours,
      priceLevel:
          data.priceLevel.present ? data.priceLevel.value : this.priceLevel,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaceEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('formattedAddress: $formattedAddress, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('rating: $rating, ')
          ..write('phone: $phone, ')
          ..write('website: $website, ')
          ..write('types: $types, ')
          ..write('isOpen: $isOpen, ')
          ..write('openingHours: $openingHours, ')
          ..write('priceLevel: $priceLevel, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      address,
      formattedAddress,
      latitude,
      longitude,
      rating,
      phone,
      website,
      types,
      isOpen,
      openingHours,
      priceLevel,
      cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaceEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.address == this.address &&
          other.formattedAddress == this.formattedAddress &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.rating == this.rating &&
          other.phone == this.phone &&
          other.website == this.website &&
          other.types == this.types &&
          other.isOpen == this.isOpen &&
          other.openingHours == this.openingHours &&
          other.priceLevel == this.priceLevel &&
          other.cachedAt == this.cachedAt);
}

class PlacesCompanion extends UpdateCompanion<PlaceEntity> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> address;
  final Value<String?> formattedAddress;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<double?> rating;
  final Value<String?> phone;
  final Value<String?> website;
  final Value<String?> types;
  final Value<bool?> isOpen;
  final Value<String?> openingHours;
  final Value<String?> priceLevel;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const PlacesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.formattedAddress = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.rating = const Value.absent(),
    this.phone = const Value.absent(),
    this.website = const Value.absent(),
    this.types = const Value.absent(),
    this.isOpen = const Value.absent(),
    this.openingHours = const Value.absent(),
    this.priceLevel = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlacesCompanion.insert({
    required String id,
    required String name,
    this.address = const Value.absent(),
    this.formattedAddress = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.rating = const Value.absent(),
    this.phone = const Value.absent(),
    this.website = const Value.absent(),
    this.types = const Value.absent(),
    this.isOpen = const Value.absent(),
    this.openingHours = const Value.absent(),
    this.priceLevel = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<PlaceEntity> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? address,
    Expression<String>? formattedAddress,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? rating,
    Expression<String>? phone,
    Expression<String>? website,
    Expression<String>? types,
    Expression<bool>? isOpen,
    Expression<String>? openingHours,
    Expression<String>? priceLevel,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (formattedAddress != null) 'formatted_address': formattedAddress,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (rating != null) 'rating': rating,
      if (phone != null) 'phone': phone,
      if (website != null) 'website': website,
      if (types != null) 'types': types,
      if (isOpen != null) 'is_open': isOpen,
      if (openingHours != null) 'opening_hours': openingHours,
      if (priceLevel != null) 'price_level': priceLevel,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlacesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? address,
      Value<String?>? formattedAddress,
      Value<double?>? latitude,
      Value<double?>? longitude,
      Value<double?>? rating,
      Value<String?>? phone,
      Value<String?>? website,
      Value<String?>? types,
      Value<bool?>? isOpen,
      Value<String?>? openingHours,
      Value<String?>? priceLevel,
      Value<DateTime>? cachedAt,
      Value<int>? rowid}) {
    return PlacesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      formattedAddress: formattedAddress ?? this.formattedAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rating: rating ?? this.rating,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      types: types ?? this.types,
      isOpen: isOpen ?? this.isOpen,
      openingHours: openingHours ?? this.openingHours,
      priceLevel: priceLevel ?? this.priceLevel,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (formattedAddress.present) {
      map['formatted_address'] = Variable<String>(formattedAddress.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (rating.present) {
      map['rating'] = Variable<double>(rating.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (website.present) {
      map['website'] = Variable<String>(website.value);
    }
    if (types.present) {
      map['types'] = Variable<String>(types.value);
    }
    if (isOpen.present) {
      map['is_open'] = Variable<bool>(isOpen.value);
    }
    if (openingHours.present) {
      map['opening_hours'] = Variable<String>(openingHours.value);
    }
    if (priceLevel.present) {
      map['price_level'] = Variable<String>(priceLevel.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlacesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('formattedAddress: $formattedAddress, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('rating: $rating, ')
          ..write('phone: $phone, ')
          ..write('website: $website, ')
          ..write('types: $types, ')
          ..write('isOpen: $isOpen, ')
          ..write('openingHours: $openingHours, ')
          ..write('priceLevel: $priceLevel, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WaterloggingsTable extends Waterloggings
    with TableInfo<$WaterloggingsTable, WaterloggingEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WaterloggingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _routeIdMeta =
      const VerificationMeta('routeId');
  @override
  late final GeneratedColumn<int> routeId = GeneratedColumn<int>(
      'route_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _routeNameMeta =
      const VerificationMeta('routeName');
  @override
  late final GeneratedColumn<String> routeName = GeneratedColumn<String>(
      'route_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _orderIndexMeta =
      const VerificationMeta('orderIndex');
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
      'order_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lineColorMeta =
      const VerificationMeta('lineColor');
  @override
  late final GeneratedColumn<String> lineColor = GeneratedColumn<String>(
      'line_color', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('#2196F3'));
  static const VerificationMeta _lineWidthMeta =
      const VerificationMeta('lineWidth');
  @override
  late final GeneratedColumn<double> lineWidth = GeneratedColumn<double>(
      'line_width', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(5.0));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        routeId,
        routeName,
        latitude,
        longitude,
        orderIndex,
        lineColor,
        lineWidth,
        description,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'waterlogging';
  @override
  VerificationContext validateIntegrity(Insertable<WaterloggingEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('route_id')) {
      context.handle(_routeIdMeta,
          routeId.isAcceptableOrUnknown(data['route_id']!, _routeIdMeta));
    } else if (isInserting) {
      context.missing(_routeIdMeta);
    }
    if (data.containsKey('route_name')) {
      context.handle(_routeNameMeta,
          routeName.isAcceptableOrUnknown(data['route_name']!, _routeNameMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
          _orderIndexMeta,
          orderIndex.isAcceptableOrUnknown(
              data['order_index']!, _orderIndexMeta));
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('line_color')) {
      context.handle(_lineColorMeta,
          lineColor.isAcceptableOrUnknown(data['line_color']!, _lineColorMeta));
    }
    if (data.containsKey('line_width')) {
      context.handle(_lineWidthMeta,
          lineWidth.isAcceptableOrUnknown(data['line_width']!, _lineWidthMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WaterloggingEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WaterloggingEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      routeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}route_id'])!,
      routeName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}route_name']),
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude'])!,
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude'])!,
      orderIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_index'])!,
      lineColor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}line_color'])!,
      lineWidth: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}line_width'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $WaterloggingsTable createAlias(String alias) {
    return $WaterloggingsTable(attachedDatabase, alias);
  }
}

class WaterloggingEntity extends DataClass
    implements Insertable<WaterloggingEntity> {
  /// ID duy nhất của điểm
  final int id;

  /// ID của tuyến đường (để nhóm các điểm lại)
  final int routeId;

  /// Tên tuyến đường
  final String? routeName;

  /// Vĩ độ
  final double latitude;

  /// Kinh độ
  final double longitude;

  /// Thứ tự điểm trong tuyến đường
  final int orderIndex;

  /// Màu của polyline (hex color)
  final String lineColor;

  /// Độ dày của đường
  final double lineWidth;

  /// Mô tả
  final String? description;

  /// Thời gian tạo
  final DateTime createdAt;

  /// Thời gian cập nhật
  final DateTime updatedAt;
  const WaterloggingEntity(
      {required this.id,
      required this.routeId,
      this.routeName,
      required this.latitude,
      required this.longitude,
      required this.orderIndex,
      required this.lineColor,
      required this.lineWidth,
      this.description,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['route_id'] = Variable<int>(routeId);
    if (!nullToAbsent || routeName != null) {
      map['route_name'] = Variable<String>(routeName);
    }
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['order_index'] = Variable<int>(orderIndex);
    map['line_color'] = Variable<String>(lineColor);
    map['line_width'] = Variable<double>(lineWidth);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WaterloggingsCompanion toCompanion(bool nullToAbsent) {
    return WaterloggingsCompanion(
      id: Value(id),
      routeId: Value(routeId),
      routeName: routeName == null && nullToAbsent
          ? const Value.absent()
          : Value(routeName),
      latitude: Value(latitude),
      longitude: Value(longitude),
      orderIndex: Value(orderIndex),
      lineColor: Value(lineColor),
      lineWidth: Value(lineWidth),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WaterloggingEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WaterloggingEntity(
      id: serializer.fromJson<int>(json['id']),
      routeId: serializer.fromJson<int>(json['routeId']),
      routeName: serializer.fromJson<String?>(json['routeName']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      lineColor: serializer.fromJson<String>(json['lineColor']),
      lineWidth: serializer.fromJson<double>(json['lineWidth']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'routeId': serializer.toJson<int>(routeId),
      'routeName': serializer.toJson<String?>(routeName),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'lineColor': serializer.toJson<String>(lineColor),
      'lineWidth': serializer.toJson<double>(lineWidth),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WaterloggingEntity copyWith(
          {int? id,
          int? routeId,
          Value<String?> routeName = const Value.absent(),
          double? latitude,
          double? longitude,
          int? orderIndex,
          String? lineColor,
          double? lineWidth,
          Value<String?> description = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      WaterloggingEntity(
        id: id ?? this.id,
        routeId: routeId ?? this.routeId,
        routeName: routeName.present ? routeName.value : this.routeName,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        orderIndex: orderIndex ?? this.orderIndex,
        lineColor: lineColor ?? this.lineColor,
        lineWidth: lineWidth ?? this.lineWidth,
        description: description.present ? description.value : this.description,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  WaterloggingEntity copyWithCompanion(WaterloggingsCompanion data) {
    return WaterloggingEntity(
      id: data.id.present ? data.id.value : this.id,
      routeId: data.routeId.present ? data.routeId.value : this.routeId,
      routeName: data.routeName.present ? data.routeName.value : this.routeName,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      orderIndex:
          data.orderIndex.present ? data.orderIndex.value : this.orderIndex,
      lineColor: data.lineColor.present ? data.lineColor.value : this.lineColor,
      lineWidth: data.lineWidth.present ? data.lineWidth.value : this.lineWidth,
      description:
          data.description.present ? data.description.value : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WaterloggingEntity(')
          ..write('id: $id, ')
          ..write('routeId: $routeId, ')
          ..write('routeName: $routeName, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('lineColor: $lineColor, ')
          ..write('lineWidth: $lineWidth, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, routeId, routeName, latitude, longitude,
      orderIndex, lineColor, lineWidth, description, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WaterloggingEntity &&
          other.id == this.id &&
          other.routeId == this.routeId &&
          other.routeName == this.routeName &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.orderIndex == this.orderIndex &&
          other.lineColor == this.lineColor &&
          other.lineWidth == this.lineWidth &&
          other.description == this.description &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WaterloggingsCompanion extends UpdateCompanion<WaterloggingEntity> {
  final Value<int> id;
  final Value<int> routeId;
  final Value<String?> routeName;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<int> orderIndex;
  final Value<String> lineColor;
  final Value<double> lineWidth;
  final Value<String?> description;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const WaterloggingsCompanion({
    this.id = const Value.absent(),
    this.routeId = const Value.absent(),
    this.routeName = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.lineColor = const Value.absent(),
    this.lineWidth = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  WaterloggingsCompanion.insert({
    this.id = const Value.absent(),
    required int routeId,
    this.routeName = const Value.absent(),
    required double latitude,
    required double longitude,
    required int orderIndex,
    this.lineColor = const Value.absent(),
    this.lineWidth = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : routeId = Value(routeId),
        latitude = Value(latitude),
        longitude = Value(longitude),
        orderIndex = Value(orderIndex);
  static Insertable<WaterloggingEntity> custom({
    Expression<int>? id,
    Expression<int>? routeId,
    Expression<String>? routeName,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<int>? orderIndex,
    Expression<String>? lineColor,
    Expression<double>? lineWidth,
    Expression<String>? description,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (routeId != null) 'route_id': routeId,
      if (routeName != null) 'route_name': routeName,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (orderIndex != null) 'order_index': orderIndex,
      if (lineColor != null) 'line_color': lineColor,
      if (lineWidth != null) 'line_width': lineWidth,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  WaterloggingsCompanion copyWith(
      {Value<int>? id,
      Value<int>? routeId,
      Value<String?>? routeName,
      Value<double>? latitude,
      Value<double>? longitude,
      Value<int>? orderIndex,
      Value<String>? lineColor,
      Value<double>? lineWidth,
      Value<String?>? description,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return WaterloggingsCompanion(
      id: id ?? this.id,
      routeId: routeId ?? this.routeId,
      routeName: routeName ?? this.routeName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      orderIndex: orderIndex ?? this.orderIndex,
      lineColor: lineColor ?? this.lineColor,
      lineWidth: lineWidth ?? this.lineWidth,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (routeId.present) {
      map['route_id'] = Variable<int>(routeId.value);
    }
    if (routeName.present) {
      map['route_name'] = Variable<String>(routeName.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (lineColor.present) {
      map['line_color'] = Variable<String>(lineColor.value);
    }
    if (lineWidth.present) {
      map['line_width'] = Variable<double>(lineWidth.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WaterloggingsCompanion(')
          ..write('id: $id, ')
          ..write('routeId: $routeId, ')
          ..write('routeName: $routeName, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('lineColor: $lineColor, ')
          ..write('lineWidth: $lineWidth, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NotificationsTable notifications = $NotificationsTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $PlacesTable places = $PlacesTable(this);
  late final $WaterloggingsTable waterloggings = $WaterloggingsTable(this);
  late final NotificationDao notificationDao =
      NotificationDao(this as AppDatabase);
  late final UserDao userDao = UserDao(this as AppDatabase);
  late final PlacesDao placesDao = PlacesDao(this as AppDatabase);
  late final WaterloggingDao waterloggingDao =
      WaterloggingDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [notifications, users, places, waterloggings];
}

typedef $$NotificationsTableCreateCompanionBuilder = NotificationsCompanion
    Function({
  required String id,
  required String userId,
  Value<String?> notificationId,
  required String title,
  required String content,
  Value<String?> targetKey,
  Value<String?> targetData,
  Value<bool> isRead,
  required DateTime createAt,
  Value<DateTime?> readAt,
  Value<DateTime?> deliveredAt,
  Value<String?> type,
  Value<String?> priority,
  Value<int> rowid,
});
typedef $$NotificationsTableUpdateCompanionBuilder = NotificationsCompanion
    Function({
  Value<String> id,
  Value<String> userId,
  Value<String?> notificationId,
  Value<String> title,
  Value<String> content,
  Value<String?> targetKey,
  Value<String?> targetData,
  Value<bool> isRead,
  Value<DateTime> createAt,
  Value<DateTime?> readAt,
  Value<DateTime?> deliveredAt,
  Value<String?> type,
  Value<String?> priority,
  Value<int> rowid,
});

class $$NotificationsTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationsTable> {
  $$NotificationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notificationId => $composableBuilder(
      column: $table.notificationId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetKey => $composableBuilder(
      column: $table.targetKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetData => $composableBuilder(
      column: $table.targetData, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isRead => $composableBuilder(
      column: $table.isRead, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createAt => $composableBuilder(
      column: $table.createAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get readAt => $composableBuilder(
      column: $table.readAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deliveredAt => $composableBuilder(
      column: $table.deliveredAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));
}

class $$NotificationsTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationsTable> {
  $$NotificationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notificationId => $composableBuilder(
      column: $table.notificationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetKey => $composableBuilder(
      column: $table.targetKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetData => $composableBuilder(
      column: $table.targetData, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isRead => $composableBuilder(
      column: $table.isRead, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createAt => $composableBuilder(
      column: $table.createAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get readAt => $composableBuilder(
      column: $table.readAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deliveredAt => $composableBuilder(
      column: $table.deliveredAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));
}

class $$NotificationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationsTable> {
  $$NotificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get notificationId => $composableBuilder(
      column: $table.notificationId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get targetKey =>
      $composableBuilder(column: $table.targetKey, builder: (column) => column);

  GeneratedColumn<String> get targetData => $composableBuilder(
      column: $table.targetData, builder: (column) => column);

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);

  GeneratedColumn<DateTime> get createAt =>
      $composableBuilder(column: $table.createAt, builder: (column) => column);

  GeneratedColumn<DateTime> get readAt =>
      $composableBuilder(column: $table.readAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deliveredAt => $composableBuilder(
      column: $table.deliveredAt, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);
}

class $$NotificationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NotificationsTable,
    NotificationEntity,
    $$NotificationsTableFilterComposer,
    $$NotificationsTableOrderingComposer,
    $$NotificationsTableAnnotationComposer,
    $$NotificationsTableCreateCompanionBuilder,
    $$NotificationsTableUpdateCompanionBuilder,
    (
      NotificationEntity,
      BaseReferences<_$AppDatabase, $NotificationsTable, NotificationEntity>
    ),
    NotificationEntity,
    PrefetchHooks Function()> {
  $$NotificationsTableTableManager(_$AppDatabase db, $NotificationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotificationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String?> notificationId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String?> targetKey = const Value.absent(),
            Value<String?> targetData = const Value.absent(),
            Value<bool> isRead = const Value.absent(),
            Value<DateTime> createAt = const Value.absent(),
            Value<DateTime?> readAt = const Value.absent(),
            Value<DateTime?> deliveredAt = const Value.absent(),
            Value<String?> type = const Value.absent(),
            Value<String?> priority = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotificationsCompanion(
            id: id,
            userId: userId,
            notificationId: notificationId,
            title: title,
            content: content,
            targetKey: targetKey,
            targetData: targetData,
            isRead: isRead,
            createAt: createAt,
            readAt: readAt,
            deliveredAt: deliveredAt,
            type: type,
            priority: priority,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            Value<String?> notificationId = const Value.absent(),
            required String title,
            required String content,
            Value<String?> targetKey = const Value.absent(),
            Value<String?> targetData = const Value.absent(),
            Value<bool> isRead = const Value.absent(),
            required DateTime createAt,
            Value<DateTime?> readAt = const Value.absent(),
            Value<DateTime?> deliveredAt = const Value.absent(),
            Value<String?> type = const Value.absent(),
            Value<String?> priority = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotificationsCompanion.insert(
            id: id,
            userId: userId,
            notificationId: notificationId,
            title: title,
            content: content,
            targetKey: targetKey,
            targetData: targetData,
            isRead: isRead,
            createAt: createAt,
            readAt: readAt,
            deliveredAt: deliveredAt,
            type: type,
            priority: priority,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NotificationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NotificationsTable,
    NotificationEntity,
    $$NotificationsTableFilterComposer,
    $$NotificationsTableOrderingComposer,
    $$NotificationsTableAnnotationComposer,
    $$NotificationsTableCreateCompanionBuilder,
    $$NotificationsTableUpdateCompanionBuilder,
    (
      NotificationEntity,
      BaseReferences<_$AppDatabase, $NotificationsTable, NotificationEntity>
    ),
    NotificationEntity,
    PrefetchHooks Function()>;
typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<String?> hashId,
  Value<String?> phoneNumber,
  Value<String?> fullName,
  Value<String?> dateOfBirth,
  Value<String?> address,
  Value<String?> avatar,
  Value<String?> userType,
  Value<bool> isActive,
  Value<bool> isSuperuser,
  Value<DateTime> updatedAt,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<String?> hashId,
  Value<String?> phoneNumber,
  Value<String?> fullName,
  Value<String?> dateOfBirth,
  Value<String?> address,
  Value<String?> avatar,
  Value<String?> userType,
  Value<bool> isActive,
  Value<bool> isSuperuser,
  Value<DateTime> updatedAt,
});

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hashId => $composableBuilder(
      column: $table.hashId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dateOfBirth => $composableBuilder(
      column: $table.dateOfBirth, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatar => $composableBuilder(
      column: $table.avatar, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userType => $composableBuilder(
      column: $table.userType, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSuperuser => $composableBuilder(
      column: $table.isSuperuser, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hashId => $composableBuilder(
      column: $table.hashId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dateOfBirth => $composableBuilder(
      column: $table.dateOfBirth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatar => $composableBuilder(
      column: $table.avatar, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userType => $composableBuilder(
      column: $table.userType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSuperuser => $composableBuilder(
      column: $table.isSuperuser, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get hashId =>
      $composableBuilder(column: $table.hashId, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get dateOfBirth => $composableBuilder(
      column: $table.dateOfBirth, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get avatar =>
      $composableBuilder(column: $table.avatar, builder: (column) => column);

  GeneratedColumn<String> get userType =>
      $composableBuilder(column: $table.userType, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get isSuperuser => $composableBuilder(
      column: $table.isSuperuser, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    UserEntity,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (UserEntity, BaseReferences<_$AppDatabase, $UsersTable, UserEntity>),
    UserEntity,
    PrefetchHooks Function()> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> hashId = const Value.absent(),
            Value<String?> phoneNumber = const Value.absent(),
            Value<String?> fullName = const Value.absent(),
            Value<String?> dateOfBirth = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> avatar = const Value.absent(),
            Value<String?> userType = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> isSuperuser = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            hashId: hashId,
            phoneNumber: phoneNumber,
            fullName: fullName,
            dateOfBirth: dateOfBirth,
            address: address,
            avatar: avatar,
            userType: userType,
            isActive: isActive,
            isSuperuser: isSuperuser,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> hashId = const Value.absent(),
            Value<String?> phoneNumber = const Value.absent(),
            Value<String?> fullName = const Value.absent(),
            Value<String?> dateOfBirth = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> avatar = const Value.absent(),
            Value<String?> userType = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> isSuperuser = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            hashId: hashId,
            phoneNumber: phoneNumber,
            fullName: fullName,
            dateOfBirth: dateOfBirth,
            address: address,
            avatar: avatar,
            userType: userType,
            isActive: isActive,
            isSuperuser: isSuperuser,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    UserEntity,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (UserEntity, BaseReferences<_$AppDatabase, $UsersTable, UserEntity>),
    UserEntity,
    PrefetchHooks Function()>;
typedef $$PlacesTableCreateCompanionBuilder = PlacesCompanion Function({
  required String id,
  required String name,
  Value<String?> address,
  Value<String?> formattedAddress,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<double?> rating,
  Value<String?> phone,
  Value<String?> website,
  Value<String?> types,
  Value<bool?> isOpen,
  Value<String?> openingHours,
  Value<String?> priceLevel,
  Value<DateTime> cachedAt,
  Value<int> rowid,
});
typedef $$PlacesTableUpdateCompanionBuilder = PlacesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> address,
  Value<String?> formattedAddress,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<double?> rating,
  Value<String?> phone,
  Value<String?> website,
  Value<String?> types,
  Value<bool?> isOpen,
  Value<String?> openingHours,
  Value<String?> priceLevel,
  Value<DateTime> cachedAt,
  Value<int> rowid,
});

class $$PlacesTableFilterComposer
    extends Composer<_$AppDatabase, $PlacesTable> {
  $$PlacesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get formattedAddress => $composableBuilder(
      column: $table.formattedAddress,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get rating => $composableBuilder(
      column: $table.rating, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get website => $composableBuilder(
      column: $table.website, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get types => $composableBuilder(
      column: $table.types, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isOpen => $composableBuilder(
      column: $table.isOpen, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get openingHours => $composableBuilder(
      column: $table.openingHours, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get priceLevel => $composableBuilder(
      column: $table.priceLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
      column: $table.cachedAt, builder: (column) => ColumnFilters(column));
}

class $$PlacesTableOrderingComposer
    extends Composer<_$AppDatabase, $PlacesTable> {
  $$PlacesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get formattedAddress => $composableBuilder(
      column: $table.formattedAddress,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get rating => $composableBuilder(
      column: $table.rating, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get website => $composableBuilder(
      column: $table.website, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get types => $composableBuilder(
      column: $table.types, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isOpen => $composableBuilder(
      column: $table.isOpen, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get openingHours => $composableBuilder(
      column: $table.openingHours,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get priceLevel => $composableBuilder(
      column: $table.priceLevel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
      column: $table.cachedAt, builder: (column) => ColumnOrderings(column));
}

class $$PlacesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlacesTable> {
  $$PlacesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get formattedAddress => $composableBuilder(
      column: $table.formattedAddress, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get website =>
      $composableBuilder(column: $table.website, builder: (column) => column);

  GeneratedColumn<String> get types =>
      $composableBuilder(column: $table.types, builder: (column) => column);

  GeneratedColumn<bool> get isOpen =>
      $composableBuilder(column: $table.isOpen, builder: (column) => column);

  GeneratedColumn<String> get openingHours => $composableBuilder(
      column: $table.openingHours, builder: (column) => column);

  GeneratedColumn<String> get priceLevel => $composableBuilder(
      column: $table.priceLevel, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$PlacesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlacesTable,
    PlaceEntity,
    $$PlacesTableFilterComposer,
    $$PlacesTableOrderingComposer,
    $$PlacesTableAnnotationComposer,
    $$PlacesTableCreateCompanionBuilder,
    $$PlacesTableUpdateCompanionBuilder,
    (PlaceEntity, BaseReferences<_$AppDatabase, $PlacesTable, PlaceEntity>),
    PlaceEntity,
    PrefetchHooks Function()> {
  $$PlacesTableTableManager(_$AppDatabase db, $PlacesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlacesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlacesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlacesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> formattedAddress = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<double?> rating = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> website = const Value.absent(),
            Value<String?> types = const Value.absent(),
            Value<bool?> isOpen = const Value.absent(),
            Value<String?> openingHours = const Value.absent(),
            Value<String?> priceLevel = const Value.absent(),
            Value<DateTime> cachedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlacesCompanion(
            id: id,
            name: name,
            address: address,
            formattedAddress: formattedAddress,
            latitude: latitude,
            longitude: longitude,
            rating: rating,
            phone: phone,
            website: website,
            types: types,
            isOpen: isOpen,
            openingHours: openingHours,
            priceLevel: priceLevel,
            cachedAt: cachedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> address = const Value.absent(),
            Value<String?> formattedAddress = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<double?> rating = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> website = const Value.absent(),
            Value<String?> types = const Value.absent(),
            Value<bool?> isOpen = const Value.absent(),
            Value<String?> openingHours = const Value.absent(),
            Value<String?> priceLevel = const Value.absent(),
            Value<DateTime> cachedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlacesCompanion.insert(
            id: id,
            name: name,
            address: address,
            formattedAddress: formattedAddress,
            latitude: latitude,
            longitude: longitude,
            rating: rating,
            phone: phone,
            website: website,
            types: types,
            isOpen: isOpen,
            openingHours: openingHours,
            priceLevel: priceLevel,
            cachedAt: cachedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PlacesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlacesTable,
    PlaceEntity,
    $$PlacesTableFilterComposer,
    $$PlacesTableOrderingComposer,
    $$PlacesTableAnnotationComposer,
    $$PlacesTableCreateCompanionBuilder,
    $$PlacesTableUpdateCompanionBuilder,
    (PlaceEntity, BaseReferences<_$AppDatabase, $PlacesTable, PlaceEntity>),
    PlaceEntity,
    PrefetchHooks Function()>;
typedef $$WaterloggingsTableCreateCompanionBuilder = WaterloggingsCompanion
    Function({
  Value<int> id,
  required int routeId,
  Value<String?> routeName,
  required double latitude,
  required double longitude,
  required int orderIndex,
  Value<String> lineColor,
  Value<double> lineWidth,
  Value<String?> description,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$WaterloggingsTableUpdateCompanionBuilder = WaterloggingsCompanion
    Function({
  Value<int> id,
  Value<int> routeId,
  Value<String?> routeName,
  Value<double> latitude,
  Value<double> longitude,
  Value<int> orderIndex,
  Value<String> lineColor,
  Value<double> lineWidth,
  Value<String?> description,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$WaterloggingsTableFilterComposer
    extends Composer<_$AppDatabase, $WaterloggingsTable> {
  $$WaterloggingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get routeId => $composableBuilder(
      column: $table.routeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get routeName => $composableBuilder(
      column: $table.routeName, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lineColor => $composableBuilder(
      column: $table.lineColor, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lineWidth => $composableBuilder(
      column: $table.lineWidth, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$WaterloggingsTableOrderingComposer
    extends Composer<_$AppDatabase, $WaterloggingsTable> {
  $$WaterloggingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get routeId => $composableBuilder(
      column: $table.routeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get routeName => $composableBuilder(
      column: $table.routeName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lineColor => $composableBuilder(
      column: $table.lineColor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lineWidth => $composableBuilder(
      column: $table.lineWidth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$WaterloggingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WaterloggingsTable> {
  $$WaterloggingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get routeId =>
      $composableBuilder(column: $table.routeId, builder: (column) => column);

  GeneratedColumn<String> get routeName =>
      $composableBuilder(column: $table.routeName, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => column);

  GeneratedColumn<String> get lineColor =>
      $composableBuilder(column: $table.lineColor, builder: (column) => column);

  GeneratedColumn<double> get lineWidth =>
      $composableBuilder(column: $table.lineWidth, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$WaterloggingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WaterloggingsTable,
    WaterloggingEntity,
    $$WaterloggingsTableFilterComposer,
    $$WaterloggingsTableOrderingComposer,
    $$WaterloggingsTableAnnotationComposer,
    $$WaterloggingsTableCreateCompanionBuilder,
    $$WaterloggingsTableUpdateCompanionBuilder,
    (
      WaterloggingEntity,
      BaseReferences<_$AppDatabase, $WaterloggingsTable, WaterloggingEntity>
    ),
    WaterloggingEntity,
    PrefetchHooks Function()> {
  $$WaterloggingsTableTableManager(_$AppDatabase db, $WaterloggingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WaterloggingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WaterloggingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WaterloggingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> routeId = const Value.absent(),
            Value<String?> routeName = const Value.absent(),
            Value<double> latitude = const Value.absent(),
            Value<double> longitude = const Value.absent(),
            Value<int> orderIndex = const Value.absent(),
            Value<String> lineColor = const Value.absent(),
            Value<double> lineWidth = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              WaterloggingsCompanion(
            id: id,
            routeId: routeId,
            routeName: routeName,
            latitude: latitude,
            longitude: longitude,
            orderIndex: orderIndex,
            lineColor: lineColor,
            lineWidth: lineWidth,
            description: description,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int routeId,
            Value<String?> routeName = const Value.absent(),
            required double latitude,
            required double longitude,
            required int orderIndex,
            Value<String> lineColor = const Value.absent(),
            Value<double> lineWidth = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              WaterloggingsCompanion.insert(
            id: id,
            routeId: routeId,
            routeName: routeName,
            latitude: latitude,
            longitude: longitude,
            orderIndex: orderIndex,
            lineColor: lineColor,
            lineWidth: lineWidth,
            description: description,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WaterloggingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WaterloggingsTable,
    WaterloggingEntity,
    $$WaterloggingsTableFilterComposer,
    $$WaterloggingsTableOrderingComposer,
    $$WaterloggingsTableAnnotationComposer,
    $$WaterloggingsTableCreateCompanionBuilder,
    $$WaterloggingsTableUpdateCompanionBuilder,
    (
      WaterloggingEntity,
      BaseReferences<_$AppDatabase, $WaterloggingsTable, WaterloggingEntity>
    ),
    WaterloggingEntity,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$NotificationsTableTableManager get notifications =>
      $$NotificationsTableTableManager(_db, _db.notifications);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$PlacesTableTableManager get places =>
      $$PlacesTableTableManager(_db, _db.places);
  $$WaterloggingsTableTableManager get waterloggings =>
      $$WaterloggingsTableTableManager(_db, _db.waterloggings);
}
