
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:phone_auth/screens/HomeScreen.dart';

class GoogleLoginPage extends StatefulWidget {
  const GoogleLoginPage({super.key});

  @override
  State<GoogleLoginPage> createState() => _GoogleLoginPageState();
}

class _GoogleLoginPageState extends State<GoogleLoginPage> {

  // Firebase Authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // GoogleSignIn instance
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // Function to sign in with Google
  Future<UserCredential?> signInWithGoogle() async{
    try{
      // Trigger the Google Sign-in flow
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      // If user selects an account
      if(googleSignInAccount != null){
        // Get the GoogleSignInAuthentication object
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        // Create a credential from the access token and ID token
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken
        );
        // Sign in to Firebase with the credential
        return await _auth.signInWithCredential(credential);
      }else{
        return null;
      }
    }on FirebaseAuthException catch(ex){

      // Show Dialog and return null if an error occurs
      showDialog(context: context, builder: (context) => AlertDialog(
        title: const Text('Alert!'), content: Text(ex.toString()),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Ok'))],),);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Sign In'), centerTitle: true,),
      body: Center(
        child: MaterialButton(onPressed: () async {

          final UserCredential? userCredential = await signInWithGoogle();
          if(userCredential?.user != null){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen(),));
          }
        }, color: Colors.blueGrey, child: const Text('Google Sign In', style: TextStyle(color: Colors.white),),),
      ),
    );
  }
}
