import 'package:flutter_lab_assignment_3/data/models/album_model.dart';

abstract class AlbumState {}

class AlbumInitial extends AlbumState {}

class AlbumLoading extends AlbumState {}

class AlbumsLoaded extends AlbumState {
  final List<Album> albums;
  AlbumsLoaded(this.albums);
}

class AlbumDetailsLoaded extends AlbumState {
  final List<Photo> photos;
  AlbumDetailsLoaded(this.photos);
}

class AlbumError extends AlbumState {
  final String message;
  AlbumError(this.message);
}