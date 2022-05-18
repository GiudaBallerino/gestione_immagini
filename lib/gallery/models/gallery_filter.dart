

import 'package:img_api/img_api.dart';

enum GalleryFilter{all,}

extension GalleryFilterX on GalleryFilter {
  bool apply(Img image) {
    switch (this) {
      case GalleryFilter.all:
        return true;
    }
  }

  Iterable<Img> applyAll(Iterable<Img> images) {
    return images.where(apply);
  }
}