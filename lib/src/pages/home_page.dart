import 'package:flutter/material.dart';
import 'package:movie_app/src/search/search_delegate.dart';

import 'package:movie_app/src/widgets/card_swiper_widget.dart';
import 'package:movie_app/src/providers/movies_provider.dart';
import 'package:movie_app/src/widgets/horizon_swiper.dart';

class HomePage extends StatelessWidget {

  final moviesProvider = MoviesProvider();
  
  @override
  Widget build(BuildContext context) {

    moviesProvider.getPopulares();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Películas en cartelera'),
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: Icon( Icons.search ),
            onPressed: () {
              showSearch( context: context, delegate: DataSearch(), query: '' );
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swiperTarjetas(),
            _footer( context )
          ],
        ),
      ),
    );
  }

  Widget _swiperTarjetas() {

    return FutureBuilder(
      future: moviesProvider.getEnCines(),
      // initialData: InitialData,
      builder: ( BuildContext context, AsyncSnapshot<List> snapshot ) {

        if ( snapshot.hasData ) {

          return CardSwiper( movies: snapshot.data );
        } else {

          return Container(
            height: 375.0,
            child: Center(
              child: CircularProgressIndicator()
            ),
          );
        }
        
      },
    );
  }

  Widget _footer( BuildContext context ) {

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only( left: 23.5 ),
            child: Text('Populares:', style: Theme.of( context ).textTheme.subhead )
          ),
          SizedBox(height: 7.0 ),

          StreamBuilder(
            stream: moviesProvider.popularesStream,
            // initialData: [],
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              
              if ( snapshot.hasData ) {

                return MovieHorizontal(
                  movies: snapshot.data,
                  nextPage: moviesProvider.getPopulares,
                );
              } else {

                return Center( child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}
