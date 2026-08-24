// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/EG.svg
  SvgGenImage get eg => const SvgGenImage('assets/icons/EG.svg');

  /// File path: assets/icons/LR.svg
  SvgGenImage get lr => const SvgGenImage('assets/icons/LR.svg');

  /// File path: assets/icons/arrow_back.svg
  SvgGenImage get arrowBack => const SvgGenImage('assets/icons/arrow_back.svg');

  /// File path: assets/icons/email.svg
  SvgGenImage get email => const SvgGenImage('assets/icons/email.svg');

  /// File path: assets/icons/icon_google.svg
  SvgGenImage get iconGoogle =>
      const SvgGenImage('assets/icons/icon_google.svg');

  /// File path: assets/icons/name.svg
  SvgGenImage get name => const SvgGenImage('assets/icons/name.svg');

  /// File path: assets/icons/password.svg
  SvgGenImage get password => const SvgGenImage('assets/icons/password.svg');

  /// File path: assets/icons/phone.svg
  SvgGenImage get phone => const SvgGenImage('assets/icons/phone.svg');

  /// File path: assets/icons/routelogo.png
  AssetGenImage get routelogo =>
      const AssetGenImage('assets/icons/routelogo.png');

  /// File path: assets/icons/splashicon.png
  AssetGenImage get splashicon =>
      const AssetGenImage('assets/icons/splashicon.png');

  /// File path: assets/icons/visible.svg
  SvgGenImage get visible => const SvgGenImage('assets/icons/visible.svg');

  /// List of all assets
  List<dynamic> get values => [
    eg,
    lr,
    arrowBack,
    email,
    iconGoogle,
    name,
    password,
    phone,
    routelogo,
    splashicon,
    visible,
  ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/Forgot password-bro 1.png
  AssetGenImage get forgotPasswordBro1 =>
      const AssetGenImage('assets/images/Forgot password-bro 1.png');

  /// File path: assets/images/badboys.png
  AssetGenImage get badboys => const AssetGenImage('assets/images/badboys.png');

  /// File path: assets/images/gamer (1)-1.png
  AssetGenImage get gamer11 =>
      const AssetGenImage('assets/images/gamer (1)-1.png');

  /// File path: assets/images/gamer (1)-2.png
  AssetGenImage get gamer12 =>
      const AssetGenImage('assets/images/gamer (1)-2.png');

  /// File path: assets/images/gamer (1).png
  AssetGenImage get gamer1 =>
      const AssetGenImage('assets/images/gamer (1).png');

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
    forgotPasswordBro1,
    badboys,
    gamer11,
    gamer12,
    gamer1,
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

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    _svg.ColorMapper? colorMapper,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
        colorMapper: colorMapper,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter:
          colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
