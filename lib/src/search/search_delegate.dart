import 'package:flutter/material.dart';
import 'package:movie_app/src/models/movie_model.dart';
import 'package:movie_app/src/providers/movies_provider.dart';

class DataSearch extends SearchDelegate {

  String selection = '';
  final movieProvider = new MoviesProvider();

  final movies = [
    'Spiderman',
    'Aquaman',
    'Batman',
    'Shazam',
    'Ironman',
  ];

  final recentMovies = [
    'Spiderman',
    'Capitan America'
  ];

  @override
  List<Widget> buildActions( BuildContext context ) {
    // Las acciones de nuestro AppBar
    return [
      IconButton(
        icon: Icon( Icons.clear ),
        onPressed: () {
          query = '';
        }
      )
    ];
  }

  @override
  Widget buildLeading(  BuildContext context  ) {
    // Icono a la izquierda del AppBar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close( context, null );
        },
      );

  }

  @override
  Widget buildResults( BuildContext context ) { return null; }
  // @override
  // Widget buildResults( BuildContext context ) {
  //   // Crea los resultados que vamos a mostrar
  //   return Center(
  //     child: Container(
  //       height: 100.0,
  //       width: 100.0,
  //       color: Colors.greenAccent,
  //       child: Text( selection ),
  //     ),
  //   );
  // }

  @override
  Widget buildSuggestions( BuildContext context ) {
    // Son las sugerencias que aparecen cuando la persona escribe
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: movieProvider.movieSearch( query ),
      builder: ( BuildContext context, AsyncSnapshot<List<Movie>> snapshot ) {
        if (snapshot.hasData) {

          final movies = snapshot.data;
          
          return ListView(
            children: movies.map( (movie) {
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage( movie.getPosterImg() ),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text( movie.title ),
                subtitle: Text( movie.originalTitle ),
                onTap: () {
                  close( context, null );
                  movie.uniqueId = '';
                  Navigator.pushNamed( context, 'detail', arguments: movie );
                },
              );
            }).toList()
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  // @override
  // Widget buildSuggestions( BuildContext context ) {
  //   // Son las sugerencias que aparecen cuando la persona escribe
  //   final listaSugerida = ( query.isEmpty )
  //                         ? recentMovies
  //                         : movies.where( (m) => m.toLowerCase().startsWith( query.toLowerCase()))
  //                         .toList();
    
  //   return ListView.builder(
  //     itemCount: listaSugerida.length,
  //     itemBuilder: ( context, i ) {
  //       return ListTile(
  //         leading: Icon( Icons.movie ),
  //         title: Text( listaSugerida[i] ),
  //         onTap: () {
  //           selection = listaSugerida[i];
  //           showResults( context );
  //         },
  //       );
  //     },
  //   );
  // }
  
}