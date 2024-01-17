import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagramc/core/utils/design_utils.dart';
import 'package:instagramc/widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor:
        width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
        appBar: width > webScreenSize
            ? null
            : AppBar(
          backgroundColor: mobileBackgroundColor,
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: SvgPicture.asset(
            AppLogos.instagram,
            colorFilter:
            const ColorFilter.mode(primaryColor, BlendMode.srcIn),
          ),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').orderBy("datePublished", descending: true).snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return  Center(child: SizedBox(height: MediaQuery.of(context).size.height * 0.3,width: MediaQuery.of(context).size.width *0.5,).defaultLoader(),);
            }else if(!snapshot.hasData) {
            return  Center(child: SizedBox(height: MediaQuery.of(context).size.height * 0.3,width: MediaQuery.of(context).size.width *0.5,).defaultLoader(),);
            }else{
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (ctx, index) => Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: width > webScreenSize ? 15 : 0,
                    vertical: width > webScreenSize ? 15 : 0,
                  ),
                  child: PostCard(
                    snap: snapshot.data!.docs[index].data(),
                  ),
                ),
              );
            }

          },
        ),
      ),
    );
  }
}