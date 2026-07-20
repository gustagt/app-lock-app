class UserPreferencesModel {
  final String userName;
  final bool focusModeActive;
  final int dailyGoalMinutes;
  final DateTime? updatedAt;

  const UserPreferencesModel({
    this.userName = 'Gustavo',
    this.focusModeActive = true,
    this.dailyGoalMinutes = 180,
    this.updatedAt,
  });

  UserPreferencesModel copyWith({
    String? userName,
    bool? focusModeActive,
    int? dailyGoalMinutes,
    DateTime? updatedAt,
  }) {
    return UserPreferencesModel(
      userName: userName ?? this.userName,
      focusModeActive: focusModeActive ?? this.focusModeActive,
      dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': 1,
      'user_name': userName,
      'focus_mode_active': focusModeActive ? 1 : 0,
      'daily_goal_minutes': dailyGoalMinutes,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory UserPreferencesModel.fromMap(Map<String, dynamic> map) {
    return UserPreferencesModel(
      userName: map['user_name'] as String,
      focusModeActive: map['focus_mode_active'] == 1,
      dailyGoalMinutes: map['daily_goal_minutes'] as int,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }
}
