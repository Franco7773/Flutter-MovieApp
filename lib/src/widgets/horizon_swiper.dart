import 'package:flutter/material.dart';
import 'package:movie_app/src/models/movie_model.dart';

class MovieHorizontal extends StatelessWidget {

  final List<Movie> movies;
  final Function nextPage;
  
  MovieHorizontal({ @required this.movies, @required this.nextPage });
  
  final _pageController = PageController(
    initialPage: 1,
    viewportFraction: 0.3
  );
  
  @override
  Widget build( BuildContext context ) {

    final _screenSize = MediaQuery.of( context ).size;

    _pageController.addListener( () {

      if ( _pageController.position.pixels >= _pageController.position.maxScrollExtent - 200 ) {
        nextPage();
      }
    });
    
    return Container(
      height: _screenSize.height * 0.3,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        // children: _tarjetas( context )
        itemCount: movies.length,
        itemBuilder: ( BuildContext context, int i ) {
          return _tarjeta( context, movies[i] );
        },
      ),
    );
  }

  Widget _tarjeta( BuildContext context, Movie movie ) {

    movie.uniqueId = '${ movie.id }-poster';
    
    final tarjeta = Container(
      margin: EdgeInsets.only( right: 15.0 ),
      child: Column(
        children: <Widget>[
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular( 17.5 ),
              child: FadeInImage(
                image: NetworkImage( movie.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 170.0,
              ),
            ),
          ),
          SizedBox( height: 5.0 ),
          Text( movie.title, overflow: TextOverflow.ellipsis, style: Theme.of( context ).textTheme.caption )
        ],
      ),
    );

    return GestureDetector(
      child: tarjeta,
      onTap: () {
        Navigator.pushNamed( context, 'detail', arguments: movie );
      }
    );
  }

  // List<Widget> _tarjetas( BuildContext context ) {

  //   return movies.map( (movie) {

  //     return Container(
  //       margin: EdgeInsets.only( right: 15.0 ),
  //       child: Column(
  //         children: <Widget>[
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular( 17.5 ),
  //             child: FadeInImage(
  //               image: NetworkImage( movie.getPosterImg()),
  //               placeholder: AssetImage('assets/img/no-image.jpg'),
  //               fit: BoxFit.cover,
  //               height: 170.0,
  //             ),
  //           ),
  //           SizedBox( height: 5.0 ),
  //           Text( movie.title, overflow: TextOverflow.ellipsis, style: Theme.of( context ).textTheme.caption )
  //         ],
  //       ),
  //     );
  //   }).toList();
  // }
}
