part of 'gallery_bloc.dart';

enum GalleryStatus { initial, loading, success, failure }

class GalleryState extends Equatable {
  const GalleryState({
    this.status = GalleryStatus.initial,
    this.images = const [],
    this.filter = GalleryFilter.all,
    this.lastDeletedImg,
  });

  final GalleryStatus status;
  final List<Img> images;
  final GalleryFilter filter;
  final Img? lastDeletedImg;

  Iterable<Img> get filteredImgs => filter.applyAll(images);

  GalleryState copyWith({
    GalleryStatus Function()? status,
    List<Img> Function()? images,
    GalleryFilter Function()? filter,
    Img? Function()? lastDeletedImg,
  }) {
    return GalleryState(
      status: status != null ? status() : this.status,
      images: images != null ? images() : this.images,
      filter: filter != null ? filter() : this.filter,
      lastDeletedImg:
          lastDeletedImg != null ? lastDeletedImg() : this.lastDeletedImg,
    );
  }

  @override
  List<Object?> get props => [
        status,
        images,
        filter,
        lastDeletedImg,
      ];
}
