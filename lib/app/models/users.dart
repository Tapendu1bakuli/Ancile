class User {
  final String firstName;
  final String lastName;
  final int age;
  final String email;
  final String phone;
  final String picture;

  User({
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.email,
    required this.phone,
    required this.picture,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['name']['first'],
      lastName: json['name']['last'],
      age: json['dob']['age'],
      email: json['email'],
      phone: json['phone'],
      picture: json['picture']['large'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'email': email,
      'phone': phone,
      'picture': picture,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      firstName: map['firstName'],
      lastName: map['lastName'],
      age: map['age'],
      email: map['email'],
      phone: map['phone'],
      picture: map['picture'],
    );
  }
}
