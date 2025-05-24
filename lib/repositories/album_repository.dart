import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_lab_assignment_3/core/networking/api_service.dart';
import 'package:flutter_lab_assignment_3/data/models/album_model.dart';

class AlbumRepository {
  final ApiService apiService;
  static const String _albumsCacheKey = 'cached_albums';
  static const String _photosCacheKeyPrefix = 'cached_photos_';

  AlbumRepository(this.apiService);

  Future<List<Album>> getAlbums() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedAlbums = prefs.getString(_albumsCacheKey);

    if (cachedAlbums != null) {
      final List<dynamic> jsonList = jsonDecode(cachedAlbums);
      return jsonList.map((json) => Album.fromJson(json)).toList();
    }

    final response = await apiService.getAlbums();
    final albums = response.map((json) => Album.fromJson(json)).toList();
    await prefs.setString(_albumsCacheKey, jsonEncode(response));
    return albums;
  }

  Future<List<Photo>> getPhotosByAlbum(int albumId) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = '$_photosCacheKeyPrefix$albumId';
    final cachedPhotos = prefs.getString(cacheKey);

    if (cachedPhotos != null) {
      final List<dynamic> jsonList = jsonDecode(cachedPhotos);
      return jsonList.map((json) => Photo.fromJson(json)).toList();
    }

    final response = await apiService.getPhotosByAlbum(albumId);
    final photos = response.map((json) => Photo.fromJson(json)).toList();
    await prefs.setString(cacheKey, jsonEncode(response));
    return photos;
  }
}