import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:movie_app/src/models/actors_model.dart';

import 'package:movie_app/src/models/movie_model.dart';

class MoviesProvider {

  String _apikey    = '894bc221a796fafb97c390cea1951cc4';
  String _url       = 'api.themoviedb.org';
  String _language  = 'es-ES';

  int _popularesPage = 0;
  bool _cargando     = false;

  List<Movie> _populares = new List();

  final _popularesStreamController = StreamController<List<Movie>>.broadcast();

  Function( List<Movie> ) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Movie>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController?.close();
  }

  Future<List<Movie>> _procesarRespuesta( Uri uri ) async {

    final resp = await http.get( uri );
    final decodedData = json.decode( resp.body );

    final result = new Movies.fromJsonList( decodedData['results'] );

    return result.movies;
  }

  Future<List<Movie>> getEnCines() async {

    final url = Uri.https( _url, '3/movie/now_playing', {
      'api_key': _apikey,
      'language': _language
    });

    return await _procesarRespuesta( url );
  }

  Future<List<Movie>> getPopulares() async {

    if ( _cargando ) return [];
    _cargando = true;
    
    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key'  : _apikey,
      'language' : _language,
      'page'     : _popularesPage.toString()
    });

    final resp = await _procesarRespuesta( url );

    _populares.addAll( resp );
    popularesSink( _populares );

    _cargando = false;
    return resp;
  }

  Future<List<Actor>> getCast( String movieId ) async {

    final uri = Uri.https( _url, '3/movie/$movieId/credits', {
      'api_key'  : _apikey,
      'language' : _language
    });

    final resp = await http.get( uri );
    final decodedData = json.decode( resp.body );

    final cast = new Cast.fromJsonList( decodedData['cast'] );

    return cast.actors;
  }

  Future<List<Movie>> movieSearch( String query ) async {

    final url = Uri.https( _url, '3/search/movie', {
      'api_key'  : _apikey,
      'language' : _language,
      'query'    : query
    });

    return await _procesarRespuesta( url );
  }
}
