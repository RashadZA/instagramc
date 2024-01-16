part of 'design_utils.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];

const double defaultPadding = 10;
const double defaultPadding1 = 15;

const double defaultButtonPressedOpacity = 0.6;

const double defaultBorderRadius = 10;

const double defaultIconButtonAllPadding = 0.0;

const double defaultIconButtonWidth = 140.0;
const double defaultIconButtonHeight = 140.0;

const double flatButtonHeight = 56;
