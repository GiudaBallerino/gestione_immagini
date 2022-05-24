part of 'gallery_bloc.dart';

enum GalleryStatus { initial, loading, success, failure }

class GalleryState extends Equatable {
  const GalleryState({
    this.status = GalleryStatus.initial,
    this.images = const [],
    this.tags = const [],
    this.actualIndex = 0,
    this.currentlyDraggedIndex = -1,
    this.points= const [Offset(500,500),Offset(600,500), Offset(600,600),Offset(500,600)],
    this.lastDeletedImg,
    this.selecting = false,
  });

  final GalleryStatus status;

  final List<Img> images;
  final List<Tag> tags;

  final bool selecting;
  final int actualIndex;
  final int currentlyDraggedIndex;
  final List<Offset> points;

  final Img? lastDeletedImg;

  GalleryState copyWith({
    GalleryStatus Function()? status,
    List<Img> Function()? images,
    List<Tag> Function()? tags,
    int Function()? actualIndex,
    int Function()? currentlyDraggedIndex,
    List<Offset> Function()? points,
    Img? Function()? lastDeletedImg,
    bool Function()? selecting,
  }) {
    return GalleryState(
      status: status != null ? status() : this.status,
      images: images != null ? images() : this.images,
      tags: tags != null ? tags() : this.tags,
      points: points != null ? points() : this.points,
      actualIndex: actualIndex != null ? actualIndex() : this.actualIndex,
      currentlyDraggedIndex: currentlyDraggedIndex != null
          ? currentlyDraggedIndex()
          : this.currentlyDraggedIndex,
      lastDeletedImg:
          lastDeletedImg != null ? lastDeletedImg() : this.lastDeletedImg,
      selecting: selecting != null ? selecting() : this.selecting,
    );
  }

  @override
  List<Object?> get props => [
        status,
        images,
        tags,
        actualIndex,
        currentlyDraggedIndex,
        points,
        lastDeletedImg,
        selecting,
      ];
}
