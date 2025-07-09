import 'package:flutter/material.dart';
class Appbarwidget extends StatelessWidget {
  const Appbarwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("FollowYourHeart",style: TextStyle(color: Colors.blueAccent,fontSize: 20,fontWeight: FontWeight.bold),),
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.message,size: 15,),
                    onPressed: () {
                      print("message icon pressed");
                    },
                  ),
                ),
                SizedBox(width: 10,),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.search,size: 15,),
                    onPressed: () {
                      print("search icon pressed");
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
