import 'dart:io';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pylons_wallet/constants/constants.dart';

Future<File?> pickImageFromCamera(double maxHeight, double maxWidth, int imageQuality, BuildContext context) async {
  try {
    final _picker = ImagePicker();
    final _image = await _picker.pickImage(source: ImageSource.camera, imageQuality: imageQuality, maxHeight: maxHeight, maxWidth: maxWidth);

    if (_image != null) {
      return cropImage(_image.path);
    }
  } on PlatformException catch(e) {
    return _handleException(e, context);
  }
  return null;
}

Future<File?> pickImageFromGallery(double maxHeight, double maxWidth, int imageQuality, BuildContext context) async {
  try {
    final _picker = ImagePicker();
    final _image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: imageQuality,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
    );
    if (_image != null) {
      return cropImage(_image.path);
    }
  } on PlatformException catch(e) {
    return _handleException(e, context);
  }
  return null;
}

Future<File?> cropImage(String path) async {
  return ImageCropper.cropImage(
      sourcePath: path,
      aspectRatioPresets: [CropAspectRatioPreset.square, CropAspectRatioPreset.ratio3x2, CropAspectRatioPreset.original, CropAspectRatioPreset.ratio4x3, CropAspectRatioPreset.ratio16x9],
      androidUiSettings:
      const AndroidUiSettings(toolbarTitle: 'Pylons', toolbarColor: kBlue, toolbarWidgetColor: Colors.white, initAspectRatio: CropAspectRatioPreset.original, lockAspectRatio: false),
      iosUiSettings: const IOSUiSettings(
        minimumAspectRatio: 1.0,
      ));
}

void showError(String error, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('image_picker_error'.tr()),
        content:
        Text(error.tr()),
        actions: <Widget>[
          TextButton(
            child: Text("close".tr()),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void requestPermissions(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('image_picker_permissions'.tr()),
        content:
        Text('image_picker_permissions_detail'.tr()),
          actions: <Widget>[
            TextButton(
              child: Text('deny_permissions'.tr()),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('open_app_settings'.tr()),
              onPressed: () => openAppSettings(),
            ),
          ],
      );
    },
  );
}

Future<File?> _handleException (PlatformException e, BuildContext context) async {
  switch (e.code) {
    case 'already_active':
      // we screwed up! this only happens if our code is doing something wrong
      showError('image_picker_wallet_err', context);
      break;
    case 'cameraPermission':
      // if it's just a permissions thing, get the permissions
      break;
    case 'cameraNotSupported':
    case 'cameraNotReadable':
    case 'cameraOverconstrained':
    case 'cameraMissingMetadata':
    case 'orientationNotSupported':
    case 'torchModeNotSupported':
    case 'zoomLevelNotSupported':
    case 'zoomLevelInvalid':
    case 'cameraNotStarted':
    case 'cameraUnknown':
      // camera is not usable - if we get any of these, there's nothing we can really do about it, so fall through
      // (eventually, we'll want an error popup, but this behavior will only happen on devices w/ no or broken/misconfigured
      // cameras, which isn't a major point of concern)
      showError('image_picker_camera_err', context);
      break;
    case 'OtherOperatingSystem':
      // imagepicker just isn't gonna work here and this isn't a shipping platform, so just crash gracelessly
      showError('image_picker_not_supported_err', context);
      throw e;
    default:
      showError('image_picker_misc_err', context);
  }
  return null;
}