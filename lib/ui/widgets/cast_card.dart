part of 'widgets.dart';

class CastCard extends StatelessWidget {
  final Credit cast;

  CastCard(this.cast);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ShowImage("$imageBaseURL/w500/${cast.profilePath}"),
            ));
      },
      child: Container(
          height: 120,
          width: 70,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 80,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: (cast.profilePath != null)
                          ? NetworkImage(
                              "$imageBaseURL/w500/${cast.profilePath}")
                          : AssetImage("assets/user_pic.png"),
                      fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 6),
              Text(
                (cast.name != null) ? cast.name : "",
                textAlign: TextAlign.center,
                style: blackTextFont.copyWith(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Text(
                (cast.character != null) ? "(${cast.character})" : "(-)",
                textAlign: TextAlign.center,
                style: greyTextFont.copyWith(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          )),
    );
  }
}
