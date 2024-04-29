import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential authResult = await _auth.signInWithCredential(credential);
      final User? user = authResult.user;

      // Create a Firestore document for the user if it doesn't exist
      await _createOrUpdateUserDocument(user);

      return user;
    } catch (e) {
      print("Error signing in with Google: $e");
      rethrow;
    }
  }

  Future<void> _createOrUpdateUserDocument(User? user) async {
    if (user != null) {
      final DocumentSnapshot userDoc =
      await usersCollection.doc(user.uid).get();

      if (!userDoc.exists) {
        // User document doesn't exist, create a new one
        await usersCollection.doc(user.email).set({
          // 'id': user.uid,
          'name': user.displayName,
          'email': user.email,
          'imageUrl':"",
          'password':"",
          'cart_count': "00",
          'order_count': "00",
          'wishlist_count': "00",
          // Add other user data as needed
        });
      } else {
        // User document already exists, update it if needed
        await usersCollection.doc(user.email).update({
          'name': user.displayName,
          'email': user.email,
          // Update other user data as needed
        });
      }
    }
  }
}