import 'package:api_app/view/productListPage.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.green,Colors.purple
          ],
        )
        ),
        child: Center(
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock,
                size: 150, // Adjust size according to your needs
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  color: Color.fromARGB(150, 238, 237, 237),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(22.0),
                        child: TextField(
                          key: const Key('emailTextField'), // Provide a key
                          keyboardType: TextInputType.emailAddress,
                          controller: TextEditingController(),
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black), // Set border color
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                        ),
                      ),
        
                      Padding(
                        padding: const EdgeInsets.only(left: 22, right: 22),
                        child: TextField(
                          key: Key('passwordTextField'), // Provide a key
                          obscureText: true,
                          controller: TextEditingController(),
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: const TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black), // Set border color
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: 30,
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(22.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder:  (context) =>  ProductListPage(),));
                          },
                          child: Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.06,
                            alignment: Alignment.center,
                            child: const Text(
                              'Login',
                              style: TextStyle(fontSize: 22, color: Colors.white),
                            ),
                            
                          ),
                        ),
                        
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
