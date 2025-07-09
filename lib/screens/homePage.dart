import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:st_01/widgets/appbarwidget.dart';
import '../controller/user.dart';
import '../models/lists.dart';
import '../widgets/storywidget.dart';
class Homepage extends StatelessWidget {
   Homepage({super.key});

  final UserController userController = Get.put(UserController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
        color: Colors.grey.shade200,
        ),
        child: Column(
          children: [
            Appbarwidget(),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width*0.19,
                      decoration: BoxDecoration(
                       color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                    backgroundImage: AssetImage("assets/images/avatar.jpg"),
                                    backgroundColor: Colors.transparent,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("what's on your mind?",style: TextStyle(fontSize: 16,color: Colors.grey),),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      userController.logout();
                                    },
                                    icon: Icon(Icons.photo,color: Colors.green,),
                                  ),
                                )
                              ],
                            ),
                          )


                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Storywidget(),
                    SizedBox(height: 10),
                    ListView.builder(
                        padding: EdgeInsets.all(0),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: fakeapi.length,
                        itemBuilder: (context,index){
                      return
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height*0.4,
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: AssetImage('assets/images/avatar.jpg'),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text("Im rtih",style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold,),),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text("2h ago"),
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
                            Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height*0.25,
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                            ),
                            child: Image.asset("assets/images/vegetable.png",fit:BoxFit.cover,width:double.infinity,),

                            ),
                          ],
                        ),
                      );
                    })
                  ],
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}
