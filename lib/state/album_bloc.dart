import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lab_assignment_3/data/models/album_model.dart';
import 'package:flutter_lab_assignment_3/repositories/album_repository.dart';
import 'album_event.dart';
import 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final AlbumRepository albumRepository;
  bool isOffline = false;
  bool loadedFromCache = false;

  AlbumBloc(this.albumRepository) : super(AlbumInitial()) {
    on<FetchAlbums>(_onFetchAlbums);
    on<FetchAlbumDetails>(_onFetchAlbumDetails);
  }

  Future<void> _onFetchAlbums(FetchAlbums event, Emitter<AlbumState> emit) async {
    emit(AlbumLoading());
    try {
      final albums = await albumRepository.getAlbums();
      isOffline = false;
      loadedFromCache = false;
      emit(AlbumsLoaded(albums));
    } catch (e) {
      isOffline = true;
      final albums = await albumRepository.getAlbums();
      if (albums.isNotEmpty) {
        loadedFromCache = true;
        emit(AlbumsLoaded(albums));
      } else {
        loadedFromCache = false;
        emit(AlbumError('Failed to fetch albums: $e'));
      }
    }
  }

  Future<void> _onFetchAlbumDetails(FetchAlbumDetails event, Emitter<AlbumState> emit) async {
    emit(AlbumLoading());
    try {
      final photos = await albumRepository.getPhotosByAlbum(event.albumId);
      isOffline = false;
      loadedFromCache = false;
      emit(AlbumDetailsLoaded(photos));
    } catch (e) {
      isOffline = true;
      final photos = await albumRepository.getPhotosByAlbum(event.albumId);
      if (photos.isNotEmpty) {
        loadedFromCache = true;
        emit(AlbumDetailsLoaded(photos));
      } else {
        loadedFromCache = false;
        emit(AlbumError('Failed to fetch photos: $e'));
      }
    }
  }
}