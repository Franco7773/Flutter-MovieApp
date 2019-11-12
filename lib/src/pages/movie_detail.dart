import 'package:flutter/material.dart';
import 'package:movie_app/src/models/actors_model.dart';
import 'package:movie_app/src/models/movie_model.dart';
import 'package:movie_app/src/providers/movies_provider.dart';

class MovieDetail extends StatelessWidget {

  final Movie movie;

  MovieDetail( this.movie );
  
  @override
  Widget build( BuildContext context ) {

    final Movie movie = ModalRoute.of( context ).settings.arguments;
    
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _createAppBar( movie ),
          SliverList(
            delegate: SliverChildListDelegate([
                SizedBox( height: 11.0 ),
                _posterTitle( context, movie ),
                _description( movie ),
                _description( movie ),
                _description( movie ),
                _description( movie ),
                _createCasting( movie )
            ]),
          )
        ],
      )
    );
  }

  Widget _createAppBar( Movie movie ) {

    return SliverAppBar(
      elevation: 2.7,
      backgroundColor: Colors.green,
      expandedHeight: 230.5,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text( movie.title, style: TextStyle( color: Colors.white, fontSize: 16.0 )),
        background: FadeInImage(
          image: NetworkImage( movie.getBackgroundImg() ),
          placeholder: AssetImage( 'assets/img/loading.gif' ),
          fadeInDuration: Duration( milliseconds: 150 ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitle( BuildContext context, Movie movie ) {
    return Container(
      padding: EdgeInsets.symmetric( horizontal: 23.0 ),
      child: Row(
        children: <Widget>[
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular( 17.5 ),
              child: Image( image: NetworkImage( movie.getPosterImg() ), height: 150.0,)
            ),
          ),
          SizedBox( width: 23.0 ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text( movie.title, style: Theme.of( context ).textTheme.title, overflow: TextOverflow.ellipsis ),
                Text( movie.originalTitle, style: Theme.of( context ).textTheme.subhead, overflow: TextOverflow.ellipsis ),
                Row(
                  children: <Widget>[
                    Icon( Icons.star_border ),
                    Text( movie.voteAverage.toString(), style: Theme.of( context ).textTheme.subhead )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _description( Movie movie ) {
    return Container(
      padding: EdgeInsets.symmetric( horizontal: 11.5, vertical: 23.0 ),
      child: Text( movie.overview, textAlign: TextAlign.justify, ),
    );
  }

  Widget _createCasting( Movie movie ) {

    final movProvider = new MoviesProvider();

    return FutureBuilder(
      future: movProvider.getCast( movie.id.toString() ),
      builder: ( BuildContext context, AsyncSnapshot<List> snapshot ) {
        if ( snapshot.hasData ) {
          return _createActorsPageView( snapshot.data );
        } else {
          return Center(
            child: CircularProgressIndicator()
          );
        }
      }
    );
  }

  Widget _createActorsPageView( List<Actor> actors ) {

    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1
        ),
        itemCount: actors.length,
        itemBuilder: ( context, i ) => _actorCard( actors[i] ),
      ),
    );
  }

  Widget _actorCard( Actor actor ) {
    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(17.3),
            child: FadeInImage(
              image: NetworkImage( actor.getPhoto() ),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          Text( actor.name, overflow: TextOverflow.ellipsis, )
        ],
      ),
    );
  }
}
