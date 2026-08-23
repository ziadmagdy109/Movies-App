// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/routelogo.png
  AssetGenImage get routelogo =>
      const AssetGenImage('assets/icons/routelogo.png');

  /// File path: assets/icons/splashicon.png
  AssetGenImage get splashicon =>
      const AssetGenImage('assets/icons/splashicon.png');

  /// List of all assets
  List<AssetGenImage> get values => [routelogo, splashicon];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/badboys.png
  AssetGenImage get badboys => const AssetGenImage('assets/images/badboys.png');

  /// File path: assets/images/groupmoviesposter.png
  AssetGenImage get groupmoviesposter =>
      const AssetGenImage('assets/images/groupmoviesposter.png');

  /// File path: assets/images/marvelimage.png
  AssetGenImage get marvelimage =>
      const AssetGenImage('assets/images/marvelimage.png');

  /// File path: assets/images/oppenheimer.png
  AssetGenImage get oppenheimer =>
      const AssetGenImage('assets/images/oppenheimer.png');

  /// File path: assets/images/ratemovie.png
  AssetGenImage get ratemovie =>
      const AssetGenImage('assets/images/ratemovie.png');

  /// File path: assets/images/startboarding.png
  AssetGenImage get startboarding =>
      const AssetGenImage('assets/images/startboarding.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    badboys,
    groupmoviesposter,
    marvelimage,
    oppenheimer,
    ratemovie,
    startboarding,
  ];
}

abstract final class Assets {
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
