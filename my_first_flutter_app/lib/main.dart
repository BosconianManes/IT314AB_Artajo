import 'package:flutter/material.dart';
import 'profile_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {

  // ========================================
  // Profile Card with FALLBACK VALUES
  // All missing data shows "missing"
  // ========================================
  Widget buildProfileCard({
    required String? name,
    required String? course,
    required int? age,
    required String? hobby,
    required String image,
    required String? birthdate,
  }) {
    return Card(
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
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.asset(
                image,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),

            // ========================================
            // NAME - Fallback: "missing"
            // ========================================
            Text(
              name ?? 'missing',  // ← FALLBACK: "missing"
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 8),

            // ========================================
            // COURSE - Fallback: "missing"
            // ========================================
            Text(
              course ?? 'missing',  // ← FALLBACK: "missing"
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 15),

            // ========================================
            // HOBBY - Fallback: "missing"
            // ========================================
            Text(
              'Hobby: ${hobby ?? 'missing'}',  // ← FALLBACK: "missing"
              style: TextStyle(
                fontSize: 18,
                color: Colors.orange,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 15),

            // ========================================
            // AGE and BIRTHDATE - Fallback: "missing"
            // ========================================
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Age: ${age?.toString() ?? 'missing'}',  // ← FALLBACK: "missing"
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.purple,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 20),
                Text(
                  'Birthdate: ${birthdate ?? 'missing'}',  // ← FALLBACK: "missing"
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.purple,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          appTitle,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ========================================
            // PROFILE A - Missing Hobby
            // ========================================
            buildProfileCard(
              name: nameA,
              course: courseA,
              age: ageA,
              hobby: hobbyA,  // ← NULL → Shows "missing"
              image: imageA,
              birthdate: birthdateA,
            ),
            SizedBox(height: 16),

            // ========================================
            // PROFILE B - Missing Course
            // ========================================
            buildProfileCard(
              name: nameB,
              course: courseB,  // ← NULL → Shows "missing"
              age: ageB,
              hobby: hobbyB,
              image: imageB,
              birthdate: birthdateB,
            ),
            SizedBox(height: 16),

            // ========================================
            // PROFILE C - Missing Name
            // ========================================
            buildProfileCard(
              name: nameC,  // ← NULL → Shows "missing"
              course: courseC,
              age: ageC,
              hobby: hobbyC,
              image: imageC,
              birthdate: birthdateC,
            ),
            SizedBox(height: 16),

            // ========================================
            // PROFILE D - Missing Birthdate
            // ========================================
            buildProfileCard(
              name: nameD,
              course: courseD,
              age: ageD,
              hobby: hobbyD,
              image: imageD,
              birthdate: birthdateD,  // ← NULL → Shows "missing"
            ),
            SizedBox(height: 16),

            // ========================================
            // PROFILE E - Complete (for comparison)
            // ========================================
            buildProfileCard(
              name: nameE,
              course: courseE,
              age: ageE,
              hobby: hobbyE,
              image: imageE,
              birthdate: birthdateE,
            ),
          ],
        ),
      ),
    );
  }
}