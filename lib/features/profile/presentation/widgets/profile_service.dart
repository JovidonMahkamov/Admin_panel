import 'package:admin_panel/features/profile/presentation/widgets/security_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileData {
  final String name;
  final String phone;
  final String? imagePath;

  const ProfileData({
    required this.name,
    required this.phone,
    this.imagePath,
  });

  ProfileData copyWith({String? name, String? phone, String? imagePath}) {
    return ProfileData(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}

class ProfileService {
  Future<ProfileData> load() async {
    final sp = await SharedPreferences.getInstance();
    return ProfileData(
      name: sp.getString(SecurityKeys.profileName) ?? "Olam",
      phone: sp.getString(SecurityKeys.profilePhone) ?? "+998 94 456 12 12",
      imagePath: sp.getString(SecurityKeys.profileImagePath),
    );
  }

  Future<void> save(ProfileData data) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(SecurityKeys.profileName, data.name);
    await sp.setString(SecurityKeys.profilePhone, data.phone);
    if (data.imagePath != null) {
      await sp.setString(SecurityKeys.profileImagePath, data.imagePath!);
    }
  }
}
