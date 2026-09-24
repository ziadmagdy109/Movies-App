import 'package:movies_app/core/gen/assets.gen.dart';

class UserProfile {
  const UserProfile({
    required this.name,
    required this.phone,
    required this.avatarKey,
  });

  final String name;
  final String phone;
  final String avatarKey;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      avatarKey: json['avatar'] as String? ?? UserAvatars.defaultKey,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'avatar': avatarKey,
    };
  }

  AssetGenImage get avatar => UserAvatars.imageFromKeyOrPath(avatarKey);
}

class UserAvatars {
  UserAvatars._();

  static const String defaultKey = 'gamer1';

  static const List<String> keys = [
    'gamer1',
    'gamer11',
    'gamer12',
    'gamer13',
    'gamer14',
    'gamer15',
    'gamer16',
    'gamer17',
    'gamer18',
  ];

  static final Map<String, AssetGenImage> _registry = <String, AssetGenImage>{
    'gamer1': Assets.images.gamer1,
    'gamer11': Assets.images.gamer11,
    'gamer12': Assets.images.gamer12,
    'gamer13': Assets.images.gamer13,
    'gamer14': Assets.images.gamer14,
    'gamer15': Assets.images.gamer15,
    'gamer16': Assets.images.gamer16,
    'gamer17': Assets.images.gamer17,
    'gamer18': Assets.images.gamer18,
  };

  static List<AssetGenImage> get avatars => _registry.values.toList();

  /// Resolves a stored avatar value (a FlutterGen key like `gamer17`, a full
  /// FlutterGen path written by older versions, or `null`) to an image.
  /// Unknown/missing values fall back to [defaultKey] so old users never crash.
  static AssetGenImage imageFromKeyOrPath(String? keyOrPath) {
    if (keyOrPath == null || keyOrPath.isEmpty) {
      return _registry[defaultKey]!;
    }
    final AssetGenImage? byKey = _registry[keyOrPath];
    if (byKey != null) return byKey;
    for (final AssetGenImage image in _registry.values) {
      if (image.path == keyOrPath) return image;
    }
    return _registry[defaultKey]!;
  }

  /// Produces a stable identifier for an image, usable in Firestore.
  static String keyFromImage(AssetGenImage image) {
    for (final MapEntry<String, AssetGenImage> entry in _registry.entries) {
      if (entry.value.path == image.path) return entry.key;
    }
    return defaultKey;
  }
}