class User {
  final String name;
  final String firstName;
  final String lastName;
  final String email;

  User({this.name, this.firstName, this.lastName, this.email});

  factory User.fromJson(Map<String, dynamic> json) => User(
      name: json['name'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email']);
}
