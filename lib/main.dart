import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lab_assignment_3/state/album_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lab_assignment_3/core/networking/api_service.dart';
import 'package:flutter_lab_assignment_3/repositories/album_repository.dart';
import 'package:flutter_lab_assignment_3/presentation/screens/album_list_screen.dart';
import 'package:flutter_lab_assignment_3/presentation/screens/album_detail_screen.dart';
import 'dart:ui' as ui;

void main() {
  ui.channelBuffers.setListener('flutter/lifecycle', (data, callback) {});
  ui.channelBuffers.drain('flutter/lifecycle', (data, callback) async {});

  final apiService = ApiService();
  final albumRepository = AlbumRepository(apiService);
  final albumBloc = AlbumBloc(albumRepository);

  runApp(MyApp(
    apiService: apiService,
    albumRepository: albumRepository,
    albumBloc: albumBloc,
  ));
}

class MyApp extends StatelessWidget {
  final ApiService apiService;
  final AlbumRepository albumRepository;
  final AlbumBloc albumBloc;

  MyApp({
    super.key,
    required this.apiService,
    required this.albumRepository,
    required this.albumBloc,
  });

  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: 'album_list',
        builder: (context, state) => const AlbumListScreen(),
      ),
      GoRoute(
        path: '/album/:id',
        name: 'album_detail',
        builder: (context, state) {
          final albumId = int.parse(state.pathParameters['id']!);
          final albumTitle = state.extra as String?;
          return AlbumDetailScreen(albumId: albumId, albumTitle: albumTitle ?? '');
        },
      ),
    ],
    debugLogDiagnostics: true,
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: albumBloc,
      child: MaterialApp.router(
        title: 'Album App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          fontFamily: 'Roboto',
          cardTheme: CardTheme(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          textTheme: TextTheme(
            titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            bodyLarge: TextStyle(fontSize: 14),
            bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        routerConfig: _router,
      ),
    );
  }
}