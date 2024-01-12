class UserModel {
  String? uid;
  String? userImageURL;
  String? email;
  String? userName;
  String? userBio;
  bool? signIn;
  List? followers;
  List? following;

  UserModel({
    this.uid,
    this.userImageURL,
    this.email,
    this.userName,
    this.userBio,
    this.signIn,
    this.followers,
    this.following,
  });

  //receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      userImageURL: map['userImageURL'],
      email: map['email'],
      userName: map['userName'],
      userBio: map['userBio'],
      signIn: map['signIn'],
      followers: map['followers'],
      following: map['following'],
    );
  }

  //sending data to server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userImageURL': userImageURL,
      'email': email,
      'userName': userName,
      'userBio': userBio,
      'signIn': signIn,
      'followers': followers,
      'following': following,
    };
  }
}