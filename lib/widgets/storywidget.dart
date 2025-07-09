import 'package:flutter/material.dart';
import 'package:st_01/models/lists.dart';
class Storywidget extends StatelessWidget {
 Storywidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.55, // fixed height for white background
      color: Colors.white, // white background
      padding: EdgeInsets.symmetric(vertical: 15), // optional padding
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: fakeapi.length+1,
        itemBuilder: (context, index) {
          if (index == 0) {
            double containerWidth = MediaQuery.of(context).size.width * 0.25;
            double containerHeight = MediaQuery.of(context).size.width * 0.55;

            return  Container(
              margin: EdgeInsets.only(right: 10, left: 10),
              width: containerWidth,
              height: containerHeight,
              child: GestureDetector(
                onTap: (){
                  print("post your story");
                },
                child: Column(
                  children: [
                    // Top 70% with image and overlay
                    Expanded(
                      flex: 7,
                      child: Stack(
                        clipBehavior: Clip.none, // ✅ This is important!
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              myProfileImageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          // Icon over bottom center (partly outside image)
                          Positioned(
                            bottom: -13, // half outside the image
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Icon(Icons.add_circle, color: Colors.blue, size: 26,),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bottom 30% with text
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Text(
                          "Add Story",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          else{
            final item = fakeapi[index-1];
            return Container(
              height: MediaQuery.of(context).size.width * 0.10,
              margin: EdgeInsets.only(right: 10, left: index == 0 ? 10 : 0), // spacing between cards
              width: MediaQuery.of(context).size.width * 0.25,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      item['cover'] ?? 'https://via.placeholder.com/150',
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage(
                          item['image'] ?? 'https://via.placeholder.com/50',
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: Text(
                        item['description'] ?? '',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(blurRadius: 2, color: Colors.black)],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
