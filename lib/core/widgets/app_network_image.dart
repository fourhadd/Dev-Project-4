// core/widgets/app_network_image.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppNetworkImage extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const AppNetworkImage({
    super.key,
    required this.url,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final image = Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return _placeholder(
            child: const CircularProgressIndicator(strokeWidth: 2));
      },
      errorBuilder: (context, error, stackTrace) => _placeholder(
          child: const Icon(Icons.broken_image_outlined,
              color: AppColors.textSecondary)),
    );

    if (borderRadius == null) return image;
    return ClipRRect(borderRadius: borderRadius!, child: image);
  }

  Widget _placeholder({required Widget child}) {
    return Container(
      width: width,
      height: height,
      color: AppColors.border,
      alignment: Alignment.center,
      child: child,
    );
  }
}
