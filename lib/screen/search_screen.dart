import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagramc/core/utils/design_utils.dart';
import 'package:instagramc/screen/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Form(
          child: TextFormField(
            controller: searchController,
            decoration:
            const InputDecoration(labelText: 'Search for a user...'),
            onFieldSubmitted: (String _) {
              setState(() {
                isShowUsers = true;
              });
            },
          ),
        ),
      ),
      body: isShowUsers
          ? FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .where(
          'userName',
          isGreaterThanOrEqualTo: searchController.text,
        )
            .get(),
        builder: (context,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              debugPrint("Snapshot Data 0$index:  ${snapshot.data!.docs[index].data()}");

              return InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      uid: snapshot.data!.docs[index]['uid'],
                    ),
                  ),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      snapshot.data!.docs[index]['userImageURL'],
                    ),
                    radius: 16,
                  ),
                  title: Text(
                    snapshot.data!.docs[index]['userName'],
                  ),
                ),
              );
            },
          );
        },
      )
          : FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('datePublished', descending: true)
            .get(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return MasonryGridView.count(
            crossAxisCount: 3,
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index) => Image.network(
              (snapshot.data! as dynamic).docs[index]['postUrl'],
              fit: BoxFit.cover,
            ),
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }
}