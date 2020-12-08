part of 'pages.dart';

class TopUpPage extends StatefulWidget {
  final PageEvent pageEvent;

  TopUpPage(this.pageEvent);

  @override
  _TopUpPageState createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  var amountController = MoneyMaskedTextController(
      thousandSeparator: ".", decimalSeparator: "", precision: 0);
  var selectedAmount = 0;

  @override
  Widget build(BuildContext context) {
    var cardWidth =
        (MediaQuery
            .of(context)
            .size
            .width - 2 * defaultMargin - 40) / 3;

    context
        .bloc<ThemeBloc>()
        .add(ChangeTheme(ThemeData().copyWith(primaryColor: mainColor)));

    return WillPopScope(
      onWillPop: () async {
        context.bloc<PageBloc>().add(widget.pageEvent);
        return;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text("Top Up Balance", style: blackTextFont),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              context.bloc<PageBloc>().add(widget.pageEvent);
            },
          ),
        ),
        body: Stack(
          children: [
            Container(
              padding:
              EdgeInsets.symmetric(horizontal: defaultMargin, vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          if (value == "")
                            selectedAmount = 0;
                          else
                            selectedAmount =
                                int.parse(value.replaceAll(".", "")) ?? 0;
                        });
                      },
                      style: whiteNumberFont.copyWith(color: Colors.black),
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          helperText: "Min. top up Rp10.000",
                          helperStyle: blackTextFont,
                          labelText: "Amount",
                          prefixText: "Rp ",
                          prefixStyle: blackTextFont),
                    ),
                    SizedBox(height: 20),
                    Text("Choose your own",
                        style: blackTextFont.copyWith(fontSize: 14)),
                    SizedBox(height: 14),
                    Wrap(
                      spacing: 20,
                      runSpacing: 14,
                      children: [
                        makeAmountCard(amount: 10000, width: cardWidth),
                        makeAmountCard(amount: 25000, width: cardWidth),
                        makeAmountCard(amount: 50000, width: cardWidth),
                        makeAmountCard(amount: 100000, width: cardWidth),
                        makeAmountCard(amount: 200000, width: cardWidth),
                        makeAmountCard(amount: 500000, width: cardWidth),
                        makeAmountCard(amount: 1000000, width: cardWidth),
                        makeAmountCard(amount: 2000000, width: cardWidth),
                      ],
                    ),
                    SizedBox(height: 100)
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildButtonTopUp(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonTopUp(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (_, userState) =>
          Container(
            margin: EdgeInsets.only(bottom: 30),
            height: 45,
            width: MediaQuery
                .of(context)
                .size
                .width - 2 * defaultMargin,
            child: RaisedButton(
              onPressed: (selectedAmount >= 10000)
                  ? () {
                showAlertDialog(context, userState);
              }
                  : null,
              color: accentColor2,
              disabledColor: accentColor3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  RichText(
                    text: TextSpan(
                      text: "Top Up: ",
                      style: whiteNumberFont.copyWith(
                          fontWeight: FontWeight.w300,
                          color: (selectedAmount >= 10000)
                              ? accentColor1
                              : Color(0xFFE4E4E4)),
                      children: [
                        TextSpan(
                          text: NumberFormat.currency(
                              locale: "id_ID", symbol: "Rp", decimalDigits: 2)
                              .format(selectedAmount),
                          style: whiteNumberFont.copyWith(
                              fontWeight: FontWeight.w600,
                              color: (selectedAmount >= 10000)
                                  ? accentColor1
                                  : Color(0xFFE4E4E4)),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  FaIcon(FontAwesomeIcons.cartPlus,
                      size: 20,
                      color: (selectedAmount >= 10000)
                          ? accentColor1
                          : Color(0xFFE4E4E4)),
                ],
              ),
            ),
          ),
    );
  }

  void showAlertDialog(BuildContext context, userState) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel", style: purpleTextFont.copyWith(fontWeight: FontWeight.w300)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget continueButton = FlatButton(
        child: Text("Top Up", style: purpleTextFont.copyWith(fontWeight: FontWeight.w600)),
        onPressed: () {
          Navigator.of(context).pop();
          var now = DateTime.now();
          var user = (userState as UserLoaded).user;
          context.bloc<PageBloc>().add(GoToSuccessPage(
              null,
              AppTransaction(
                userId: user.id,
                title: "Top Up Wallet",
                amount: selectedAmount,
                subtitle:
                "${now.fullDayName}, ${now.day} ${now.monthName} ${now.year}",
                time: now,
              )));
        });

    String amount = NumberFormat.currency(
        locale: "id_ID",
        decimalDigits: 0,
        symbol: "Rp"
    ).format(selectedAmount);

    AlertDialog alert = AlertDialog(
      title: Text("Confirmation Top Up", style: blackTextFont.copyWith(color: accentColor1, fontSize: 18)),
      content: Text("Would you like to top up your wallet $amount", style: greyTextFont.copyWith(fontSize: 14)),
      actions: [
        cancelButton,
        continueButton
      ],
    );

    showDialog<void>(
        context: context,
        builder: (context) => alert
    );
  }

  Widget makeAmountCard({int amount, double width}) =>
      AmountCard(
        amount: amount,
        width: width,
        isSelected: selectedAmount == amount,
        onTap: () {
          setState(() {
            if (selectedAmount != amount) {
              selectedAmount = amount;
            } else {
              selectedAmount = 0;
            }
            amountController.text = NumberFormat.currency(
                locale: "id_ID", decimalDigits: 0, symbol: "")
                .format(selectedAmount);
          });
        },
      );
}
