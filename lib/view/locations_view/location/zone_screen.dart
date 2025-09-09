import 'package:flutter/material.dart';

class ZoneScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Container(
        color: Colors.grey[200],
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Ensure all children stretch to full height
          children: [
            // Form Section
            Expanded(
              flex: 1, // More space for form
              child: Container(
                padding: EdgeInsets.all(15),
                color: Colors.white,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'NAME',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        // ),
                      ),
                    ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'SHORT NAME',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: 'TYPE',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      items: [
                        DropdownMenuItem(child: Text('MAJOR'), value: 'MAJOR'),
                        DropdownMenuItem(child: Text('INTERIOR'), value: 'INTERIOR'),
                      ],
                      onChanged: (value) {},
                    ),
                    SizedBox(height: 15),
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: 'CATEGORY',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      items: [
                        DropdownMenuItem(child: Text('MAJOR'), value: 'MAJOR'),
                        DropdownMenuItem(child: Text('INTERIOR'), value: 'INTERIOR'),
                      ],
                      onChanged: (value) {},
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('CLEAR'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.red[700],
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('SAVE'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.green[700],
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Map Placeholder
            Expanded(
              flex: 3, // More space for map
              child: Container(
                color: Colors.green[100],
                child: Center(
                  child: Text(
                    'Map Placeholder',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}