import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My First Flutter Application',
      home: Scaffold(
        backgroundColor: Colors.lightBlue[50],
        appBar: AppBar(
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: Text(
            'My First Flutter Application',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.blue, width: 2),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.asset(
                            'assets/profile.jpg',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Armanes Christopher G. Artajo',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'BSIT 3',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Hobby: Playing Online Games',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.orange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Age: 20',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.purple,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 30),
                            Text(
                              'Birthdate: Nov 16, 2005',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.purple,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Text(
                          'My First Flutter Application',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'August 11, 2026',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.blue,
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                ),
                SizedBox(height: 15),
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.orange, width: 2),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Favorites',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Favorite Game: Mobile Legends',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Favorite Food: Tortang Talong',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Favorite Movie:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'None',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.purple,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}