import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/constants/constants.dart';
import 'package:pylons_wallet/utils/screen_size_utils.dart';

class CollectionScreen extends StatelessWidget {
  CollectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Default Cookbooks", style: Theme.of(context).textTheme.bodyText1!.copyWith(
            color: Colors.grey,
          ),),
          const VerticalSpace(6),
          Row(
            children: [
              _CardWidget(text: "Art", icon: "art", onTap: (){},),
              const Spacer(),
              _CardWidget(text: "Tickets", icon: "tickets", onTap: (){},),
              const Spacer(),
              _CardWidget(text: "Transfer", icon: "transfer", onTap: (){},),

            ],
          ),
          const VerticalSpace(20),
          Text("Your Pylons App",style: Theme.of(context).textTheme.bodyText1!.copyWith(
            color: Colors.grey,
          ),),
          const VerticalSpace(6),
          Row(
            children: [
              _CardWidget(text: "Easel", icon: "pylons", onTap: (){},),
              const HorizontalSpace(10),
              _CardWidget(text: "Avatar", icon: "pylons", onTap: (){},),

            ],
          ),
          const VerticalSpace(20),
          Expanded(
            child: StaggeredGridView.countBuilder(
                crossAxisCount: 3,
                shrinkWrap: true,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                itemCount: 15,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: const BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      child: InkWell(
                        child: CachedNetworkImage(imageUrl: _getImage(index), fit: BoxFit.cover),
                        onTap: () {},
                      ),),);
                },
                staggeredTileBuilder: (index) {
                  return StaggeredTile.count((index == 1 || index == 6) ? 2 : 1, (index == 1 || index == 6) ? 2 : 1);
                }),
          )
        ],
      ),
    );
  }

  String _getImage(int index) {
    switch (index % 4) {
      case 1:
        return kImage1;

      case 2:
        return kImage2;

      case 3:
        return kImage3;

      default:
        return kImage;
    }
  }
}


class _CardWidget extends StatelessWidget {
  const _CardWidget({Key? key,
  required this.text, required this.icon, required this.onTap,}) : super(key: key);
  final String text;
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final screenSize = ScreenSizeUtil(context);
    return Column(
      children: [
        Container(
          width: screenSize.width(percent: 0.3),
          height: screenSize.width(percent: 0.3),
          padding: const EdgeInsets.all(30),
          decoration: const BoxDecoration(
            color: Color(0xFFC4C4C4),
          ),
          child: Image.asset("assets/icons/$icon.png",
          fit: BoxFit.contain,
            width: 10,
            height: 70,
          ),
        ),
        const VerticalSpace(6),
        Text(text, style: Theme.of(context).textTheme.bodyText1!.copyWith(
          fontSize: 16,
        ),)
      ],
    );
  }
}

