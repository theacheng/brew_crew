import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:brew_crew/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on FirebaseUser
  CustomUser _userFromFirebaseUser(User user) {
    return user != null ? CustomUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<CustomUser> get user {
    return _auth
        .authStateChanges()
        //.map((User user) => _userFromFirebaseUser(user));  // this is same to below
        .map(_userFromFirebaseUser);
  }

  // sign in anon
  Future signinAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: email,
      );
      User user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      print('registering error!');
      return null;
    }
  }

  // register with email & password
  Future registerWithEmailAndPasswrod(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: email,
      );
      User user = result.user;

      // create a new document for user with uid
      await DatabaseService(uid: user.uid).updateUserData(
        '0',
        'new crew memeber',
        100,
      );

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      print('registering error!');
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      print('signing out error');
      return null;
    }
  }
}
