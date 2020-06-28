import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class BuildCachedImage extends StatelessWidget {
  const BuildCachedImage({
    Key key,
    @required this.imgUrl,
    @required this.fit,
    @required this.isHome,
  }) : super(key: key);

  final String imgUrl;
  final BoxFit fit;
  final bool isHome;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CachedNetworkImage(
        imageUrl: imgUrl,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: fit,
            ),
            borderRadius: (isHome)
                ? BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  )
                : BorderRadius.circular(0),
          ),
        ),
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(
          MaterialIcons.error_outline,
          color: Colors.orange[200],
        ),
      ),
    );
  }
}
