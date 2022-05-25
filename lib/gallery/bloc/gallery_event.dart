part of 'gallery_bloc.dart';

abstract class GalleryEvent extends Equatable {
  const GalleryEvent();

  @override
  List<Object> get props => [];
}

class GalleryImgsSubscriptionRequested extends GalleryEvent {
  const GalleryImgsSubscriptionRequested();
}

class GalleryTagsSubscriptionRequested extends GalleryEvent {
  const GalleryTagsSubscriptionRequested();
}

class GalleryImgDeleted extends GalleryEvent {
  const GalleryImgDeleted(this.img);

  final Img img;

  @override
  List<Object> get props => [img];
}

class GalleryUndoDeletionRequested extends GalleryEvent {
  const GalleryUndoDeletionRequested();
}

class GalleryUpdateActualIndex extends GalleryEvent {
  const GalleryUpdateActualIndex(this.index);

  final int index;

  @override
  List<Object> get props => [index];
}

class GalleryUpdateCurrentlyDraggedIndex extends GalleryEvent {
  const GalleryUpdateCurrentlyDraggedIndex(this.index);

  final int index;

  @override
  List<Object> get props => [index];
}

class GalleryUpdatePoints extends GalleryEvent {
  const GalleryUpdatePoints(this.points);

  final List<Offset> points;

  @override
  List<Object> get props => [points];
}

class GalleryUpdatePoint extends GalleryEvent {
  const GalleryUpdatePoint(this.points, this.index, this.point);

  final List<Offset> points;
  final int index;
  final Offset point;

  @override
  List<Object> get props => [points];
}

class GalleryImgSelectionStart extends GalleryEvent {
  const GalleryImgSelectionStart();
}

class GalleryImgSelectionEnd extends GalleryEvent {
  const GalleryImgSelectionEnd();
}

class GalleryTagSelectionStart extends GalleryEvent {
  const GalleryTagSelectionStart();
}

class GalleryTagSelectionEnd extends GalleryEvent {
  const GalleryTagSelectionEnd();
}

class GallerySelectionSubmitted extends GalleryEvent {
  const GallerySelectionSubmitted(this.path, this.selection);

  final String path;
  final Selection selection;
}
