import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

class CachedMemoryImage extends ImageProvider<CachedMemoryImage> {
  final Uint8List? imageData;
  final String key; // Unique key for caching

  // In-memory cache for decoded images
  static final Map<String, ui.Image> _imageCache = {};

  CachedMemoryImage(this.imageData, this.key);

  @override
  Future<CachedMemoryImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture(this);
  }
  @override
  ImageStreamCompleter loadBuffer(CachedMemoryImage key, DecoderBufferCallback decode) {
    if (imageData == null) {
      throw ArgumentError("Image data cannot be null");
    }

    // Check if the image is already cached
    if (_imageCache.containsKey(key.key)) {
      return OneFrameImageStreamCompleter(
        Future.value(ImageInfo(image: _imageCache[key.key]!)),
      );
    }

    // Decode the image and cache it
    return OneFrameImageStreamCompleter(
      _decodeAndCacheImage(key),
    );
  }


  Future<ImageInfo> _decodeAndCacheImage(CachedMemoryImage key) async {
    final codec = await ui.instantiateImageCodec(imageData!);
    final frame = await codec.getNextFrame();
    _imageCache[key.key] = frame.image; // Cache the decoded image
    return ImageInfo(image: frame.image);
  }
}
