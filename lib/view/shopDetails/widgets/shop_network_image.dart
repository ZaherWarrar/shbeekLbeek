import 'package:app/core/constant/app_images.dart';
import 'package:flutter/material.dart';

const _shopImagePlaceholder = Color(0xFFF1F1F1);
final Set<String> _scheduledShopImages = {};

bool isUnavailableShopImage(String? url) {
  final imageUrl = url?.trim() ?? '';
  if (imageUrl.isEmpty) return true;
  final path = Uri.tryParse(imageUrl)?.path.toLowerCase() ?? imageUrl.toLowerCase();
  return path.endsWith('/default.png');
}

void precacheShopImage(BuildContext context, String? url, double logicalWidth) {
  final imageUrl = url?.trim() ?? '';
  if (isUnavailableShopImage(imageUrl)) return;
  final cacheWidth = _shopCacheWidth(context, logicalWidth);
  final token = '$imageUrl@$cacheWidth';
  if (!_scheduledShopImages.add(token)) return;
  precacheImage(
    ResizeImage(NetworkImage(imageUrl), width: cacheWidth),
    context,
    onError: (_, _) {
      _scheduledShopImages.remove(token);
    },
  );
}

class ShopNetworkImage extends StatelessWidget {
  const ShopNetworkImage({
    super.key,
    required this.url,
    this.logicalWidth,
    this.fit = BoxFit.cover,
  });

  final String? url;
  final double? logicalWidth;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final imageUrl = url?.trim() ?? '';
    if (isUnavailableShopImage(imageUrl)) {
      return Image.asset(Assets.imagesLogo, fit: fit);
    }

    final width = logicalWidth ?? MediaQuery.sizeOf(context).width;
    return Image.network(
      imageUrl,
      fit: fit,
      cacheWidth: _shopCacheWidth(context, width),
      gaplessPlayback: true,
      filterQuality: FilterQuality.medium,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const ColoredBox(color: _shopImagePlaceholder);
      },
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(Assets.imagesLogo, fit: fit);
      },
    );
  }
}

int _shopCacheWidth(BuildContext context, double logicalWidth) {
  final pixels = logicalWidth * MediaQuery.devicePixelRatioOf(context);
  return pixels.round().clamp(96, 900);
}
