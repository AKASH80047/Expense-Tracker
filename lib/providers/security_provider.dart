import 'package:flutter_riverpod/flutter_riverpod.dart';

class SecuritySettings {
  final bool pinLock;
  final bool biometricAuth;
  final bool encryptedLocalData;
  final bool cloudBackup;
  final bool autoBackup;

  const SecuritySettings({
    this.pinLock = true,
    this.biometricAuth = true,
    this.encryptedLocalData = true,
    this.cloudBackup = true,
    this.autoBackup = false,
  });

  SecuritySettings copyWith({
    bool? pinLock,
    bool? biometricAuth,
    bool? encryptedLocalData,
    bool? cloudBackup,
    bool? autoBackup,
  }) {
    return SecuritySettings(
      pinLock: pinLock ?? this.pinLock,
      biometricAuth: biometricAuth ?? this.biometricAuth,
      encryptedLocalData: encryptedLocalData ?? this.encryptedLocalData,
      cloudBackup: cloudBackup ?? this.cloudBackup,
      autoBackup: autoBackup ?? this.autoBackup,
    );
  }
}

final securitySettingsProvider = NotifierProvider<SecuritySettingsNotifier, SecuritySettings>(() {
  return SecuritySettingsNotifier();
});

class SecuritySettingsNotifier extends Notifier<SecuritySettings> {
  @override
  SecuritySettings build() {
    return const SecuritySettings();
  }

  void togglePinLock(bool value) => state = state.copyWith(pinLock: value);
  void toggleBiometricAuth(bool value) => state = state.copyWith(biometricAuth: value);
  void toggleEncryptedData(bool value) => state = state.copyWith(encryptedLocalData: value);
  void toggleCloudBackup(bool value) => state = state.copyWith(cloudBackup: value);
  void toggleAutoBackup(bool value) => state = state.copyWith(autoBackup: value);
}
