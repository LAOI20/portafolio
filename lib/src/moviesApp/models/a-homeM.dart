
class MovieInfo {
  String title;
  String year;
  String runTime;
  String genre;
  String director;
  String actors;
  String plot;
  String rating;

  MovieInfo(
    this.title,
    this.year,
    this.runTime,
    this.genre,
    this.director,
    this.actors,
    this.plot,
    this.rating
  );

  MovieInfo.fromData(
    String titlee,String yearr,String runtimee,
    String genree,String directorr,String actorss,
    String plott,String ratingg
  ){
    title = titlee;
    year = yearr;
    runTime = runtimee;
    genre = genree;
    director = directorr;
    actors = actorss;
    plot = plott;
    rating = ratingg;
  }

}