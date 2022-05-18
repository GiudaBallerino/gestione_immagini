part of 'gallery_bloc.dart';

abstract class GalleryEvent extends Equatable {
  const GalleryEvent();

  @override
  List<Object> get props => [];
}

class GallerySubscriptionRequested extends GalleryEvent {
  const GallerySubscriptionRequested();
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

class GalleryFilterChanged extends GalleryEvent {
  const GalleryFilterChanged(this.filter);

  final GalleryFilter filter;

  @override
  List<Object> get props => [filter];
}