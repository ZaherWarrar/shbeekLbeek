import 'package:app/core/constant/app_images.dart';
import 'package:flutter/material.dart';

final Set<String> _scheduledShopImages = {};

bool isUnavailableShopImage(String? url) {
  final imageUrl = url?.trim() ?? '';
  if (imageUrl.isEmpty) return true;
  return imageUrl.toLowerCase().endsWith('/default.png');
}

void precacheShopImage(BuildContext context, String? url) {
  final imageUrl = url?.trim() ?? '';
  if (isUnavailableShopImage(imageUrl)) return;
  if (!_scheduledShopImages.add(imageUrl)) return;
  precacheImage(
    NetworkImage(imageUrl),
    context,
    onError: (_, _) {
      _scheduledShopImages.remove(imageUrl);
    },
  );
}

class ShopNetworkImage extends StatelessWidget {
  const ShopNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final imageUrl = url?.trim() ?? '';
    final fallback = Image.asset(
      Assets.imagesLogo,
      width: width,
      height: height,
      fit: fit,
    );
    if (isUnavailableShopImage(imageUrl)) return fallback;

    return SizedBox(
      width: width,
      height: height,
      child: Image.network(
        imageUrl,
        fit: fit,
        errorBuilder: (_, _, _) => fallback,
      ),
    );
  }
}
