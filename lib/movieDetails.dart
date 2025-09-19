import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './models/movieDetailModel.dart';
import './models/movieModel.dart';
import './models/movieCreditsModel.dart';
import './models/cast_crew.dart';
import 'package:intl/intl.dart';
import './models/tmdb.dart';

class MovieDetail extends StatefulWidget {
  final Results movie;

  const MovieDetail({required this.movie, Key? key}) : super(key: key);

  @override
  _MovieDetails createState() => _MovieDetails();
}

class _MovieDetails extends State<MovieDetail> {
  late final String movieDetailUrl;
  late final String movieCreditsUrl;
  MovieDetailModel? movieDetails;
  MovieCredits? movieCredits;
  final List<CastCrew> castCrew = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    movieDetailUrl =
        "${Tmdb.baseUrl}${widget.movie.id}?api_key=${Tmdb.apiKey}&language=es";
    movieCreditsUrl =
        "${Tmdb.baseUrl}${widget.movie.id}/credits?api_key=${Tmdb.apiKey}&language=es";
    _fetchMovieDetails();
    _fetchMovieCredits();
  }

  void _fetchMovieDetails() async {
    var response = await http.get(Uri.parse(movieDetailUrl));
    var decodedJson = jsonDecode(response.body);
    setState(() {
      movieDetails = MovieDetailModel.fromJson(decodedJson);
    });
  }

  void _fetchMovieCredits() async {
    setState(() {
      isLoading = true;
    });
    var response = await http.get(Uri.parse(movieCreditsUrl));
    var decodedJson = jsonDecode(response.body);
    movieCredits = MovieCredits.fromJson(decodedJson);
    movieCredits!.cast.forEach((c) => castCrew.add(CastCrew(
        id: c.castId,
        name: c.name,
        subName: c.character,
        imagePath: c.profilePath,
        personType: "Actors")));
    movieCredits!.crew.forEach((c) => castCrew.add(CastCrew(
        id: c.id,
        name: c.name,
        subName: c.job,
        imagePath: c.profilePath,
        personType: "Crew")));
    setState(() {
      isLoading = false;
    });
  }

  String _getMovieDuration(int? runtime) {
    if (runtime == null) return 'No data';
    double movieHours = runtime / 60;
    int movieMinutes = ((movieHours - movieHours.floor()) * 60).round();
    return "${movieHours.floor()}h ${movieMinutes}min";
  }

  Widget _buildCastCrewContent(String personType) => Container(
        height: 115.0,
        padding: const EdgeInsets.only(
          top: 8.0,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: Text(personType,
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[400])),
            ),
            Flexible(
                child: ListView(
              scrollDirection: Axis.horizontal,
              children: isLoading
                  ? <Widget>[const Center(child: CircularProgressIndicator())]
                  : castCrew
                      .where((f) => f.personType == personType)
                      .map((c) => Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Container(
                            width: 65.0,
                            child: Column(
                              children: <Widget>[
                                CircleAvatar(
                                    radius: 28.0,
                                    backgroundImage: c.imagePath != null
                                        ? NetworkImage(
                                            "${Tmdb.baseImagesUrl}w154${c.imagePath}",
                                          )
                                        : const AssetImage('assets/nobody.jpg')
                                            as ImageProvider),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    c.name,
                                    style: const TextStyle(
                                        fontSize: 8.0,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  c.subName,
                                  style: const TextStyle(fontSize: 8.0),
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          )))
                      .toList(),
            ))
          ],
        ));

  @override
  Widget build(BuildContext context) {
    final moviePoster = Container(
        height: 350.0,
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Center(
            child: Card(
                elevation: 15.0,
                child: Hero(
                  tag: widget.movie.heroTag ?? '',
                  child: Image.network(
                    "${Tmdb.baseImagesUrl}w342${widget.movie.posterPath}",
                    fit: BoxFit.cover,
                  ),
                ))));

    final movieTitle = Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
      child: Center(
          child: Text(
        widget.movie.title,
        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        overflow: TextOverflow.ellipsis,
      )),
    );

    final movieTickets = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          movieDetails != null ? _getMovieDuration(movieDetails!.runtime) : '',
          style: const TextStyle(fontSize: 11.0),
        ),
        Container(
          height: 20.0,
          width: 1.0,
          color: Colors.white70,
        ),
        Text(
          "Release Date: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.movie.releaseDate))}",
          style: const TextStyle(fontSize: 11.0),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            elevation: 15.0,
            backgroundColor: Colors.red[700],
          ),
          child: const Text('Tickets'),
          onPressed: () {},
        )
      ],
    );

    final genresList = Container(
        height: 25.0,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: movieDetails == null
                ? []
                : movieDetails!.genres
                    .map((g) => Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: FilterChip(
                            backgroundColor: Colors.grey[600],
                            labelStyle: const TextStyle(fontSize: 10.0),
                            label: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(g.name),
                            ),
                            onSelected: (b) {},
                          ),
                        ))
                    .toList(),
          ),
        ));

    final middleContent = Container(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Divider(),
            genresList,
            const Divider(),
            Text(
              'SINOPSIS',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey[300]),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              widget.movie.overview,
              style: TextStyle(color: Colors.grey[300], fontSize: 11.0),
            ),
            const SizedBox(
              height: 10.0,
            )
          ],
        ));

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          'Movies App',
          style: TextStyle(
              color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: <Widget>[
          moviePoster,
          movieTitle,
          movieTickets,
          middleContent,
          _buildCastCrewContent("Actors"),
          _buildCastCrewContent("Crew")
        ],
      ),
    );
  }
}
