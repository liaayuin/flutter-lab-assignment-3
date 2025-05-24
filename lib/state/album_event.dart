abstract class AlbumEvent {}

class FetchAlbums extends AlbumEvent {}

class FetchAlbumDetails extends AlbumEvent {
  final int albumId;
  FetchAlbumDetails(this.albumId);
}