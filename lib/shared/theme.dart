part of 'shared.dart';

const double defaultMargin = 24;

Color mainColor = Color(0xFF1E009C);
Color accentColor1 = Color(0xFF0F004F);
Color accentColor2 = Color(0xFFFBD460);
Color accentColor3 = Color(0xFFADADAD);

TextStyle blackTextFont = GoogleFonts.raleway()
    .copyWith(color: Colors.black, fontWeight: FontWeight.w500);
TextStyle whiteTextFont = GoogleFonts.raleway()
    .copyWith(color: Colors.white, fontWeight: FontWeight.w500);
TextStyle purpleTextFont = GoogleFonts.raleway()
    .copyWith(color: mainColor, fontWeight: FontWeight.w500);
TextStyle greyTextFont = GoogleFonts.raleway()
    .copyWith(color: accentColor3, fontWeight: FontWeight.w500);

TextStyle whiteNumberFont =
    GoogleFonts.openSans().copyWith(color: Colors.white);
TextStyle greyNumberFont = GoogleFonts.openSans().copyWith(color: accentColor3);
TextStyle yellowNumberFont =
    GoogleFonts.openSans().copyWith(color: accentColor2);