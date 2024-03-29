import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagramc/core/server/auth_methods.dart';
import 'package:instagramc/core/server/firestore_methods.dart';
import 'package:instagramc/core/utils/design_utils.dart';
import 'package:instagramc/core/widgets/core_flat_button.dart';
import 'package:instagramc/screen/login_screen.dart';
import 'package:instagramc/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  bool _isButtonLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  followButtonFunction({required bool userWillBeFollowed}) async {
    setState(() {
      _isButtonLoading = true;
    });
    if(userWillBeFollowed){
      await FireStoreMethods()
          .followUser(
        FirebaseAuth.instance
            .currentUser!.uid,
        userData['uid'],
      );
      var user = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      setState(() {
        followers = user.data()!['followers'].length;
        isFollowing = true;
        _isButtonLoading = false;
      });
    }else{
      await FireStoreMethods()
          .followUser(
        FirebaseAuth.instance
            .currentUser!.uid,
        userData['uid'],
      );
      var user = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      setState(() {
        followers = user.data()!['followers'].length;
        isFollowing = false;
        _isButtonLoading = false;
      });
    }

  }
 signOutFunction(BuildContext context) async {
   await AuthMethods().signOut();
   if (context.mounted) {
     Navigator.of(context)
         .pushReplacement(
       MaterialPageRoute(
         builder: (context) =>
         const LoginScreen(),
       ),
     );
   }
 }
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
      child: CircularProgressIndicator(),
    )
        : Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: mobileBackgroundColor,
        title: Text(
          userData['userName'],
        ),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                        userData['userImageURL'],
                      ),
                      radius: 40,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              buildStatColumn(postLen, "posts"),
                              buildStatColumn(followers, "followers"),
                              buildStatColumn(following, "following"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              FirebaseAuth.instance.currentUser!.uid ==
                                  widget.uid
                                  ? CoreFlatButton(
                                width: 250,
                                height: 35,
                                text: "Sign Out",
                                isGradientBg: true,
                                onPressed: () => signOutFunction(context),
                                isLoading: _isButtonLoading,
                              )
                                  : isFollowing
                                  ? CoreFlatButton(
                                text: "Unfollow",
                                width: 250,
                                height: 35,
                                isGradientBg: true,
                                onPressed: () => followButtonFunction(userWillBeFollowed: false),
                                isLoading: _isButtonLoading,
                              )
                                  : CoreFlatButton(
                                text: "Follow",
                                width: 250,
                                height: 35,
                                isGradientBg: true,
                                onPressed: () => followButtonFunction(userWillBeFollowed: true),
                                isLoading: _isButtonLoading,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(
                    top: 15,
                  ),
                  child: Text(
                    userData['userName'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(
                    top: 1,
                  ),
                  child: Text(
                    userData['userBio'],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('posts')
                .where('uid', isEqualTo: widget.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                itemCount: (snapshot.data! as dynamic).docs.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 1.5,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  DocumentSnapshot snap =
                  (snapshot.data! as dynamic).docs[index];

                  return SizedBox(
                    child: Image(
                      image: NetworkImage(snap['postUrl']),
                      fit: BoxFit.cover,
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}