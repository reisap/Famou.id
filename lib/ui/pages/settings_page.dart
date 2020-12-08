part of 'pages.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.bloc<PageBloc>().add(GoToMainPage());
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Image.asset("assets/h_logo.png", height: 30),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              context.bloc<PageBloc>().add(GoToMainPage());
            },
          ),
        ),
        body: BlocBuilder<UserBloc, UserState>(builder: (context, userState) {
          if (userState is UserLoaded) {
            var user = userState.user;
            return Container(
              color: Colors.white,
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  Column(
                    children: [
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ShowImage(user.profilePicture),
                            ),
                          );
                        },
                        child: Hero(
                          tag: "image",
                          child: Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: (user.profilePicture != "")
                                    ? NetworkImage(user.profilePicture)
                                    : AssetImage("assets/user_pic.png"),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        user.name,
                        textAlign: TextAlign.center,
                        style: blackTextFont.copyWith(fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        user.email,
                        textAlign: TextAlign.center,
                        style: greyTextFont.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      SizedBox(height: 30),
                      SettingsMenu(FontAwesomeIcons.edit, "Edit Profile", () {
                        context.bloc<PageBloc>().add(GoToProfilePage(user));
                      }),
                      SizedBox(height: 10),
                      SettingsMenu(FontAwesomeIcons.wallet, "My Wallet", () {
                        context.bloc<PageBloc>().add(GoToWalletPage(GoToSettingsPage()));
                      }),
                      SizedBox(height: 10),
                      SettingsMenu(FontAwesomeIcons.laptopCode, "About Developer", () {}),
                      SizedBox(height: 10),
                      SettingsMenu(FontAwesomeIcons.infoCircle, "About Apps", () {}),
                      SizedBox(height: 10),
                      SettingsMenu(FontAwesomeIcons.signOutAlt, "Sign Out", () {
                        context.bloc<UserBloc>().add(SignOut());
                        AuthService.signOut();
                      }),
                      SizedBox(height: 20),
                      Text("Famou.ID", style: greyTextFont.copyWith(
                          fontSize: 14, fontWeight: FontWeight.bold),),
                      SizedBox(height: 8),
                      Text(
                        "\u00A9 Ian Ahmad Fachriza, ${DateTime
                            .now()
                            .year}",
                        style: greyTextFont.copyWith(fontSize: 12,
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return SpinKitFadingCircle(
              color: accentColor2,
              size: 50,
            );
          }
        }),
      ),
    );
  }
}

class SettingsMenu extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onPress;

  SettingsMenu(this.icon, this.title, this.onPress);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: defaultMargin),
      child: FlatButton(
        onPressed: onPress,
        height: 34,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                FaIcon(icon, color: mainColor, size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: blackTextFont.copyWith(fontSize: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2),
            Divider(
              thickness: 1,
              color: accentColor3,
            ),
          ],
        ),
      ),
    );
  }
}
