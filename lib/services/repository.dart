import 'dart:async';
import 'dart:io';

import 'package:beerxp/models/users.dart';
import 'package:beerxp/services/firebase_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Repository {

  final _firebaseProvider = FirebaseProvider();

  Future<void> addDataToDB(FirebaseUser user) => _firebaseProvider.addDataToDB(user);
  
  // Future<FirebaseUser> signIn() => _firebaseProvider.signIn();
  
  Future<bool> authenticateUser(FirebaseUser user) => _firebaseProvider.authenticateUser(user);

  Future<FirebaseUser> getCurrentUser() => _firebaseProvider.getCurrentUser();

  Future<void> signOut() => _firebaseProvider.signOut();

  Future<String> uploadImageToStorage(File imageFile) => _firebaseProvider.uploadImageToStorage(imageFile);

  Future<void> addDrinkinToDB(User currentUser, String imgUrl, String caption, String location) => _firebaseProvider.addDrinkinToDB(currentUser, imgUrl, caption, location);
  
  Future<User> retrieveUserDetails(FirebaseUser user) => _firebaseProvider.retrieveUserDetails(user);

  Future<List<DocumentSnapshot>> retrieveUserDrinkins(String userId) => _firebaseProvider.retrieveUserDrinkins(userId);

  Future<List<DocumentSnapshot>> fetchDrinkinComments(DocumentReference reference) => _firebaseProvider.fetchDrinkinCommentDetails(reference);

  Future<List<DocumentSnapshot>> fetchDrinkinLikes(DocumentReference reference) => _firebaseProvider.fetchDrinkinLikeDetails(reference);

  Future<bool> checkIfUserLikedOrNot(String userId, DocumentReference reference) => _firebaseProvider.checkIfUserLikedOrNot(userId, reference);

   Future<List<DocumentSnapshot>> retrieveDrinkins(FirebaseUser user) => _firebaseProvider.retrieveDrinkins(user);

  Future<List<String>> fetchAllUserNames(FirebaseUser user) => _firebaseProvider.fetchAllUserNames(user);

  Future<String> fetchUidBySearchedName(String displayName) => _firebaseProvider.fetchUidBySearchedName(displayName);

  Future<User> fetchUserDetailsById(String uid) => _firebaseProvider.fetchUserDetailsById(uid);

  Future<void> followUser({String currentUserId, String followingUserId}) => _firebaseProvider.followUser(currentUserId: currentUserId, followingUserId: followingUserId);

  Future<void> unFollowUser({String currentUserId, String followingUserId}) => _firebaseProvider.unFollowUser(currentUserId: currentUserId, followingUserId: followingUserId);

  Future<bool> checkIsFollowing(String displayName, String currentUserId) => _firebaseProvider.checkIsFollowing(displayName, currentUserId);

  Future<List<DocumentSnapshot>> fetchStats({String uid, String label}) => _firebaseProvider.fetchStats(uid: uid, label: label);

  Future<void> updatePhoto(String photoUrl, String uid) => _firebaseProvider.updatePhoto(photoUrl, uid);

  Future<void> updateDetails(String uid, String displayName, String bio, String email, String phone) => _firebaseProvider.updateDetails(uid, displayName, bio, email, phone);

  Future<List<String>> fetchUserNames(FirebaseUser user) => _firebaseProvider.fetchUserNames(user);

  Future<List<User>> fetchAllUsers(FirebaseUser user) => _firebaseProvider.fetchAllUsers(user);

  // void uploadImageMsgToDb(String url, String receiverUid, String senderuid) => _firebaseProvider.uploadImageMsgToDb(url, receiverUid, senderuid);

  // Future<void> addMessageToDb(Message message, String receiverUid) => _firebaseProvider.addMessageToDb(message, receiverUid);

  Future<List<DocumentSnapshot>> fetchFeed(FirebaseUser user) => _firebaseProvider.fetchFeed(user);

  Future<List<String>> fetchFollowingUids(FirebaseUser user) => _firebaseProvider.fetchFollowingUids(user);

}