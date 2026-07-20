class BlockedAppModel {
  final int? id;
  final String packageName;
  final String appName;
  final int iconCodePoint;
  final int dailyLimitMinutes;
  final int timeUsedTodaySeconds;
  final String lastResetDate;
  final bool isBlocked;
  final DateTime createdAt;
  final DateTime? updatedAt;

  BlockedAppModel({
    this.id,
    required this.packageName,
    required this.appName,
    required this.iconCodePoint,
    this.dailyLimitMinutes = 60,
    this.timeUsedTodaySeconds = 0,
    String? lastResetDate,
    this.isBlocked = true,
    DateTime? createdAt,
    this.updatedAt,
  })  : lastResetDate = lastResetDate ??
            DateTime.now().toIso8601String().substring(0, 10),
        createdAt = createdAt ?? DateTime.now();

  BlockedAppModel copyWith({
    int? id,
    String? packageName,
    String? appName,
    int? iconCodePoint,
    int? dailyLimitMinutes,
    int? timeUsedTodaySeconds,
    String? lastResetDate,
    bool? isBlocked,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BlockedAppModel(
      id: id ?? this.id,
      packageName: packageName ?? this.packageName,
      appName: appName ?? this.appName,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      dailyLimitMinutes: dailyLimitMinutes ?? this.dailyLimitMinutes,
      timeUsedTodaySeconds:
          timeUsedTodaySeconds ?? this.timeUsedTodaySeconds,
      lastResetDate: lastResetDate ?? this.lastResetDate,
      isBlocked: isBlocked ?? this.isBlocked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'package_name': packageName,
      'app_name': appName,
      'icon_code_point': iconCodePoint,
      'daily_limit_minutes': dailyLimitMinutes,
      'time_used_today_seconds': timeUsedTodaySeconds,
      'last_reset_date': lastResetDate,
      'is_blocked': isBlocked ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory BlockedAppModel.fromMap(Map<String, dynamic> map) {
    return BlockedAppModel(
      id: map['id'] as int?,
      packageName: map['package_name'] as String,
      appName: map['app_name'] as String,
      iconCodePoint: map['icon_code_point'] as int,
      dailyLimitMinutes: map['daily_limit_minutes'] as int,
      timeUsedTodaySeconds: map['time_used_today_seconds'] as int,
      lastResetDate: map['last_reset_date'] as String,
      isBlocked: map['is_blocked'] == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }
}
