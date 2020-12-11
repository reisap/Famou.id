part of 'pages.dart';

class MovieDetailPage extends StatelessWidget {
  final Movie movie;
  final bool isNowPlaying;
  final PageEvent pageEvent;

  MovieDetailPage(this.movie, this.isNowPlaying, this.pageEvent);

  @override
  Widget build(BuildContext context) {
    MovieDetail detail;
    List<Credit> credits;

    return WillPopScope(
      onWillPop: () async {
        context.bloc<PageBloc>().add(pageEvent);
        return;
      },
      child: Scaffold(
          body: Stack(
        children: [
          Container(color: accentColor1),
          SafeArea(
            child: Container(
              color: Colors.white,
              child: FutureBuilder(
                future: MovieService.getDetailMovie(movie),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    detail = snapshot.data;
                    return FutureBuilder(
                      future: MovieService.getCredits(movie.id),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          credits = snapshot.data;
                          return ListView(
                            children: [
                              Column(
                                children: [
                                  backdropMovie(context, detail),
                                  movieInformation(detail),
                                  castAndCrew(credits),
                                  overviewMovie(detail),
                                  SizedBox(height: 30),
                                  Container(
                                    height: 45,
                                    width: double.infinity,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: defaultMargin * 2),
                                    child: (isNowPlaying)
                                        ? RaisedButton(
                                            onPressed: () {
                                              context.bloc<PageBloc>().add(
                                                  GoToSelectSchedulePage(
                                                      detail, pageEvent));
                                            },
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            color: mainColor,
                                            child: Text("Booked Movie",
                                                style: whiteTextFont.copyWith(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          )
                                        : Center(
                                            child: Text(
                                              "Available at: ${detail.releaseDate}",
                                              style: blackTextFont,
                                            ),
                                          ),
                                  ),
                                  SizedBox(height: 50)
                                ],
                              )
                            ],
                          );
                        } else {
                          return Container(
                              color: Colors.white,
                              child: SpinKitDoubleBounce(
                                  color: mainColor, size: 50));
                        }
                      },
                    );
                  } else {
                    return Container(
                        color: Colors.white,
                        child: SpinKitDoubleBounce(color: mainColor, size: 50));
                  }
                },
              ),
            ),
          )
        ],
      )),
    );
  }

  Column overviewMovie(MovieDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleText("Overview"),
        Container(
          margin: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Text(
            detail.overview,
            softWrap: true,
            style: greyTextFont.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Column castAndCrew(List<Credit> credits) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleText("Cast & Crew"),
        SizedBox(
          height: 120,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: credits.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => Container(
              margin: EdgeInsets.fromLTRB((index == 0) ? defaultMargin : 0, 0,
                  (index == credits.length - 1) ? 10 : defaultMargin, 0),
              child: CastCard(credits[index]),
            ),
          ),
        ),
      ],
    );
  }

  Padding movieInformation(MovieDetail detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultMargin),
      child: Column(
        children: [
          SizedBox(height: 16),
          Text(
            detail.title,
            textAlign: TextAlign.center,
            style: blackTextFont.copyWith(
                fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Text(detail.genreAndLanguage,
              textAlign: TextAlign.center,
              style: greyTextFont.copyWith(
                fontSize: 12,
              )),
          SizedBox(height: 6),
          RatingStar(
            voteAverage: detail.voteAverage,
            isWhite: false,
            isCenter: true,
            starSize: 16,
          ),
        ],
      ),
    );
  }

  Container backdropMovie(BuildContext context, MovieDetail detail) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage("$imageBaseURL/w780/${detail.backdropPath}"),
            fit: BoxFit.cover),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  context.bloc<PageBloc>().add(pageEvent);
                },
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.white, Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container titleText(String title) {
    return Container(
      margin: EdgeInsets.fromLTRB(defaultMargin, 30, defaultMargin, 12),
      child: Text(title,
          style: blackTextFont.copyWith(
              fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }
}
