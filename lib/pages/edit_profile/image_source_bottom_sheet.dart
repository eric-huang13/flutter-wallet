import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/utils/image_picker.dart';
import 'package:pylons_wallet/utils/screen_size_utils.dart';

class ImageSourceBottomSheet extends StatelessWidget {
  const ImageSourceBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Column(
          children: [
            const VerticalSpace(40),
            _MenuButtonWidget(
              onTap: () {
                pickImageFromCamera(500, 500, 85, context).then((file) {
                  Navigator.pop(context);
                });
              },
              title: "Take Photo",
            ),
            const Divider(),
            _MenuButtonWidget(
              title: "Choose from ${Platform.isAndroid ? "Gallery" : "Photos"}",
              onTap: () {
                pickImageFromGallery(500, 500, 85, context).then((file) {
                  Navigator.pop(context);
                });
              },
            ),
            const Divider(),
            _MenuButtonWidget(
              title: "Choose from NFT Collection",
              onTap: () {},
            ),
            const Divider(),
            _MenuButtonWidget(
              title: "Remove Profile Photo",
              onTap: () {},
              textColor: const Color(0xffE53C3C),
            ),
            const VerticalSpace(30),
          ],
        ),
      ],
    );
  }


}

class _MenuButtonWidget extends StatelessWidget {
  const _MenuButtonWidget({Key? key, required this.title, required this.onTap, this.textColor = Colors.black}) : super(key: key);

  final String title;
  final VoidCallback onTap;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSizeUtil(context);
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: screenSize.width(),
        height: 40,
        child: Align(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: textColor, fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
