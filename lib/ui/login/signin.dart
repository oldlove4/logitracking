import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:logitracking/aws/aws-cognito/my_cognito_user_pool.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _Signin4PageState createState() => _Signin4PageState();
}

class _Signin4PageState extends State<LoginPage> {
  bool _obscureText = true;
  IconData _iconVisible = Icons.visibility_off;
  final _formKey = GlobalKey<FormState>();

  final Color _underlineColor = const Color(0xFFCCCCCC);
  final Color _mainColor = const Color(0xFF0181cc);
  final Color _color1 = const Color(0xFF515151);
  final Color _color2 = const Color(0xff777777);
  final Color _color3 = const Color(0xFFaaaaaa);

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
      if (_obscureText == true) {
        _iconVisible = Icons.visibility_off;
      } else {
        _iconVisible = Icons.visibility;
      }
    });
  }
  String? _emailValid (val){
    if (val == null || val.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  Future<void> _submit() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const Center(child: CupertinoActivityIndicator(),);
        });
    print('111111111111111111111111111');
    final prefs = await SharedPreferences.getInstance();
    final pool = MyCognitoUserPool(prefs);


    final user = await pool.getUser();

    print(user);


   final session = await pool.authenticateUser(username: "manager", password: "123456");
   print(session?.getAccessToken().getJwtToken());
    print('333333333333333333333333333');

    String? token = session?.getAccessToken().getJwtToken();
    Navigator.pop(context);
    if(token != null) {
      // Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Home()), (Route<dynamic> route) => false);

      // Fluttertoast.showToast(
      //     msg: token, toastLength: Toast.LENGTH_SHORT);
    }



  }


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(30, 120, 30, 30),
          children: <Widget>[
            Center(
                child: Image.asset('assets/images/powered_by.png',
                    color: _mainColor, height: 30)),
            const SizedBox(
              height: 80,
            ),
            Text('Sign In',
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold, color: _mainColor)),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: _color1),
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: _mainColor, width: 2.0)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: _underlineColor),
                ),
                labelText: 'Email',
                labelStyle: TextStyle(color: _color2),
              ),
              // The validator receives the text that the user has entered.
              validator: _emailValid,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              obscureText: _obscureText,
              style: TextStyle(color: _color1),
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: _mainColor, width: 2.0)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: _underlineColor),
                ),
                labelText: 'Password',
                labelStyle: TextStyle(color: _color2),
                suffixIcon: IconButton(
                    icon: Icon(_iconVisible, color: Colors.grey[400], size: 20),
                    onPressed: () {
                      _toggleObscureText();
                    }),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Fluttertoast.showToast(
                        msg: 'Click forgot password',
                        toastLength: Toast.LENGTH_SHORT);
                    FocusScope.of(context).unfocus();
                  },
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(color: _mainColor, fontSize: 13),
                  ),
                )),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) => _mainColor,
                  ),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0),
                  )),
                ),
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // Fluttertoast.showToast(
                    //     msg: 'Click login', toastLength: Toast.LENGTH_SHORT);
                    _submit();
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'LOGIN',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                )),
            const SizedBox(
              height: 40,
            ),
            Center(
              child: Text(
                'Or sign in with',
                style: TextStyle(fontSize: 13, color: _color3),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Fluttertoast.showToast(
                          msg: 'Signin with google',
                          toastLength: Toast.LENGTH_SHORT);
                    },
                    child: const Image(
                      image: AssetImage("assets/images/google.png"),
                      width: 40,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Fluttertoast.showToast(
                          msg: 'Signin with facebook',
                          toastLength: Toast.LENGTH_SHORT);
                    },
                    child: const Image(
                      image: AssetImage("assets/images/facebook.png"),
                      width: 40,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Fluttertoast.showToast(
                          msg: 'Signin with twitter',
                          toastLength: Toast.LENGTH_SHORT);
                    },
                    child: const Image(
                      image: AssetImage("assets/images/twitter.png"),
                      width: 40,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  Fluttertoast.showToast(
                      msg: 'Click signup', toastLength: Toast.LENGTH_SHORT);
                  FocusScope.of(context).unfocus();
                },
                child: Wrap(
                  children: [
                    Text(
                      'No account yet? ',
                      style: TextStyle(fontSize: 13, color: _color3),
                    ),
                    Text(
                      'Create one',
                      style: TextStyle(fontSize: 13, color: _mainColor),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
