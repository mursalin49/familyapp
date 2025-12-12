class SettingsModel {
  final MindfulUsageSettings mindfulUsage;
  final NotificationSettings notifications;
  final AppearanceSettings appearance;
  final ProfileSettings profile;
  final PrivacySettings privacy;
  final SecuritySettings security;
  final String? notificationPreference;
  final String? displayName;
  final String? firstname;
  final String? lastname;

  SettingsModel({
    required this.mindfulUsage,
    required this.notifications,
    required this.appearance,
    required this.profile,
    required this.privacy,
    required this.security,
    this.notificationPreference,
    this.displayName,
    this.firstname,
    this.lastname,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    // Handle both response formats:
    // GET response: { "settings": {...}, "notificationPreference": "...", ... }
    // PATCH response: { "mindfulUsage": {...}, "notifications": {...}, ... }
    final settings = json['settings'] as Map<String, dynamic>? ?? json;
    
    return SettingsModel(
      mindfulUsage: MindfulUsageSettings.fromJson(
        settings['mindfulUsage'] as Map<String, dynamic>,
      ),
      notifications: NotificationSettings.fromJson(
        settings['notifications'] as Map<String, dynamic>,
      ),
      appearance: AppearanceSettings.fromJson(
        settings['appearance'] as Map<String, dynamic>,
      ),
      profile: ProfileSettings.fromJson(
        settings['profile'] as Map<String, dynamic>,
      ),
      privacy: PrivacySettings.fromJson(
        settings['privacy'] as Map<String, dynamic>,
      ),
      security: SecuritySettings.fromJson(
        settings['security'] as Map<String, dynamic>,
      ),
      notificationPreference: json['notificationPreference'] as String?,
      displayName: json['displayName'] as String?,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
    );
  }
}

class MindfulUsageSettings {
  final bool enabled;
  final int reminderInterval;
  final int breakDuration;
  final int dailyUsageGoal;

  MindfulUsageSettings({
    required this.enabled,
    required this.reminderInterval,
    required this.breakDuration,
    required this.dailyUsageGoal,
  });

  factory MindfulUsageSettings.fromJson(Map<String, dynamic> json) {
    return MindfulUsageSettings(
      enabled: json['enabled'] as bool? ?? false,
      reminderInterval: json['reminderInterval'] as int? ?? 20,
      breakDuration: json['breakDuration'] as int? ?? 5,
      dailyUsageGoal: json['dailyUsageGoal'] as int? ?? 120,
    );
  }
}

class NotificationSettings {
  final bool pushEnabled;

  NotificationSettings({
    required this.pushEnabled,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      pushEnabled: json['pushEnabled'] as bool? ?? true,
    );
  }
}

class AppearanceSettings {
  final String theme; // "light" or "dark"

  AppearanceSettings({
    required this.theme,
  });

  factory AppearanceSettings.fromJson(Map<String, dynamic> json) {
    return AppearanceSettings(
      theme: json['theme'] as String? ?? 'light',
    );
  }
}

class ProfileSettings {
  final String timeFormat; // "12-hour" or "24-hour"

  ProfileSettings({
    required this.timeFormat,
  });

  factory ProfileSettings.fromJson(Map<String, dynamic> json) {
    return ProfileSettings(
      timeFormat: json['timeFormat'] as String? ?? '12-hour',
    );
  }
}

class PrivacySettings {
  final bool shareActivityStatus;
  final bool locationSharing;
  final bool usageAnalytics;
  final bool marketingCommunications;
  final bool dataBackupToCloud;

  PrivacySettings({
    required this.shareActivityStatus,
    required this.locationSharing,
    required this.usageAnalytics,
    required this.marketingCommunications,
    required this.dataBackupToCloud,
  });

  factory PrivacySettings.fromJson(Map<String, dynamic> json) {
    return PrivacySettings(
      shareActivityStatus: json['shareActivityStatus'] as bool? ?? true,
      locationSharing: json['locationSharing'] as bool? ?? false,
      usageAnalytics: json['usageAnalytics'] as bool? ?? true,
      marketingCommunications: json['marketingCommunications'] as bool? ?? false,
      dataBackupToCloud: json['dataBackupToCloud'] as bool? ?? true,
    );
  }
}

class SecuritySettings {
  final bool twoFactorEnabled;
  final bool loginNotifications;
  final bool autoLockApp;
  final int autoLockTimeout;

  SecuritySettings({
    required this.twoFactorEnabled,
    required this.loginNotifications,
    required this.autoLockApp,
    required this.autoLockTimeout,
  });

  factory SecuritySettings.fromJson(Map<String, dynamic> json) {
    return SecuritySettings(
      twoFactorEnabled: json['twoFactorEnabled'] as bool? ?? false,
      loginNotifications: json['loginNotifications'] as bool? ?? true,
      autoLockApp: json['autoLockApp'] as bool? ?? false,
      autoLockTimeout: json['autoLockTimeout'] as int? ?? 15,
    );
  }
}

