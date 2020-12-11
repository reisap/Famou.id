part of 'models.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String profilePicture;
  final List<String> selectedGenres;
  final String selectedLanguage;
  final int balance;

  User(this.id, this.email,
      {this.name,
      this.profilePicture,
      this.selectedGenres,
      this.selectedLanguage,
      this.balance});

  // * For Updating User
  User copyWith({String name, String profileImage, int balance}) => User(
        this.id,
        this.email,
        name: name ?? this.name,
        profilePicture: profileImage ?? this.profilePicture,
        balance: balance ?? this.balance,
        selectedGenres: selectedGenres,
        selectedLanguage: selectedLanguage,
      );

  @override
  List<Object> get props => [
        id,
        email,
        name,
        profilePicture,
        selectedGenres,
        selectedLanguage,
        balance
      ];
}
