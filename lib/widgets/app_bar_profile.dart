import 'package:flutter/material.dart';
class AppBarProfile extends StatelessWidget {
  const AppBarProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed:()=>Navigator.pop(context), icon: Icon(Icons.chevron_left,size:26,)),
                SizedBox(width: 10,),
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/avatar.jpg') as ImageProvider,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("BoyBoy",style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold,),),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Just now",style: TextStyle(fontSize: 12, color: Colors.grey),),
                          SizedBox(width: 5,),
                          Icon(Icons.public,size: 16,),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            Row(
              children: [
                Icon(Icons.more_horiz,size: 16,),
              ],
            )
          ],
        ),
      ),
    );;
  }
}
