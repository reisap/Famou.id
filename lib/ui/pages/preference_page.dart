part of 'pages.dart';

class PreferencePage extends StatefulWidget {
  final RegistrationData registrationData;
  final List<String> genres = [
    "Action",
    "Adventure",
    "Animation",
    "Comedy",
    "Crime",
    "Documentary",
    "Drama",
    "Family",
    "Fantasy",
    "History",
    "Horror",
    "Music",
    "Mystery",
    "Romance",
    "Science Fiction",
    "TV Movie",
    "Thriller",
    "War"
  ];
  final List<String> language = ["Indonesian", "English", "Japanese", "Korean"];

  PreferencePage(this.registrationData);
  @override
  _PreferencePageState createState() => _PreferencePageState();
}

class _PreferencePageState extends State<PreferencePage> {
  List<String> selectedGenres = [];
  String selectedLanguage = "Indonesian";
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.registrationData.password = "";
        context
            .bloc<PageBloc>()
            .add(GoToRegistrationPage(widget.registrationData));
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Favorite Genres & Region", style: blackTextFont),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              widget.registrationData.password = "";
              context
                  .bloc<PageBloc>()
                  .add(GoToRegistrationPage(widget.registrationData));
            },
          ),
          actions: [
            (selectedGenres.length >= 4)
                ? FlatButton(
                    onPressed: () {
                      widget.registrationData.selectedGenres = selectedGenres;
                      widget.registrationData.selectedLanguage =
                          selectedLanguage;

                      context.bloc<PageBloc>().add(
                          GoToAccountConfirmationPage(widget.registrationData));
                    },
                    child: Text("Next",
                        style: purpleTextFont.copyWith(
                            fontSize: 16, fontWeight: FontWeight.bold)))
                : SizedBox()
          ],
          backgroundColor: Colors.white,
          toolbarHeight: 76,
        ),
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(defaultMargin, 0, defaultMargin, 30),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Select Your\nFavorite Genre",
                      style: blackTextFont.copyWith(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  Text("(Select min. 4 Genres,\nmax. 8 Genres)",
                      textAlign: TextAlign.end,
                      style: greyTextFont.copyWith(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: generateGenreWidgets(context),
              ),
              SizedBox(
                height: 24,
              ),
              Text("Your Recommended\nMovie\'s Region",
                  style: blackTextFont.copyWith(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(
                height: 16,
              ),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: generateLanguageWidgets(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> generateGenreWidgets(BuildContext context) {
    double width =
        (MediaQuery.of(context).size.width - 2 * defaultMargin - 24) / 2;

    return widget.genres
        .map((e) => SelectableBox(
              e,
              width: width,
              isSelected: selectedGenres.contains(e),
              onTap: () {
                onSelectedGenre(e);
              },
            ))
        .toList();
  }

  List<Widget> generateLanguageWidgets(BuildContext context) {
    double width =
        (MediaQuery.of(context).size.width - 2 * defaultMargin - 24) / 2;

    return widget.language
        .map((e) => SelectableBox(e,
                width: width, isSelected: selectedLanguage == e, onTap: () {
              setState(() {
                selectedLanguage = e;
              });
            }))
        .toList();
  }

  void onSelectedGenre(String genre) {
    if (selectedGenres.contains(genre)) {
      setState(() {
        selectedGenres.remove(genre);
      });
    } else {
      if (selectedGenres.length < 8) {
        setState(() {
          selectedGenres.add(genre);
        });
      }
    }
  }
}
