import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class SizeConfig {
  static double? _width;
  static double? _height;
  static double? _textScaleFactor;
  static double? _heightScaleFactor;
  static bool? _isTablet;
  static bool? _isMobile;
  static MediaQueryData? _mediaQuery;

  SizeConfig._();

  static void init([ui.SingletonFlutterWindow? window]) {
    final lWindow = window ?? ui.window;
    final pixelRatio = lWindow.devicePixelRatio;
    _width = lWindow.physicalSize.width / pixelRatio;
    _height = lWindow.physicalSize.height / pixelRatio;

    /// Because the layout is being created w.r.t 360 logical px wide device
    /// Need this to generify width for all screens in mobile
    double referenceWidth = 360.0;

    /// Because the layout is being created w.r.t the height of 640 logical px device
    /// Need this to generify height for all screens in mobile
    double referenceHeight = 640.0;

    /// if we are on tablet, then need different reference width
    if (_width! < 650) {
      _isMobile = true;
      _isTablet = false;
    } else {
      _isTablet = true;
      _isMobile = false;

      referenceWidth = 1280.0;
      referenceHeight = 720.0;
    }
    final textScaleFactor = (_width! / referenceWidth);
    if (_isTablet!) {
      _textScaleFactor = textScaleFactor;
    } else {
      _textScaleFactor = textScaleFactor;
    }
    _heightScaleFactor = _height! / referenceHeight;
  }

  static get width {
    if (_width == null) {
      throw Exception("Must call SizeConfig.init() before fetching data from this config");
    }
    return _width;
  }

  static get height {
    if (_height == null) {
      throw Exception("Must call SizeConfig.init() before fetching data from this config");
    }
    return _height;
  }

  static double get textScaleFactor {
    if (_textScaleFactor == null) {
      throw Exception("Must call SizeConfig.init() before fetching data from this config");
    }
    return _textScaleFactor!;
  }

  static get heightScaleFactor {
    if (_heightScaleFactor == null) {
      throw Exception("Must call SizeConfig.init() before fetching data from this config");
    }
    return _heightScaleFactor!;
  }

  static get widthScaleFactor => textScaleFactor;

  static get isTablet {
    if (_isTablet == null) {
      throw Exception("Must call SizeConfig.init() before fetching data from this config");
    }
    return _isTablet;
  }

  static get isMobile {
    if (_isMobile == null) {
      throw Exception("Must call SizeConfig.init() before fetching data from this config");
    }
    return _isMobile;
  }

  static MediaQueryData getMediaQuery(BuildContext context) {
    return _mediaQuery = MediaQuery.of(context).copyWith(textScaleFactor: textScaleFactor);
  }

  static double get statusBarHeight {
    if (_mediaQuery == null) {
      throw Exception("Must call SizeConfig.init() before fetching data from this config");
    }
    return _mediaQuery!.viewPadding.top;
  }
}

extension SizeExtension on num {
  double get w => (this * SizeConfig.textScaleFactor).toDouble();
  double get h => (this * SizeConfig.heightScaleFactor).toDouble();
}