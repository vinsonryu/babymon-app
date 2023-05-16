import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class humidity extends StatefulWidget {
  humidity({super.key});
  @override
  State<humidity> createState() => _humidityState();
}


class _humidityState extends State<humidity> {
  FirebaseDatabase database = FirebaseDatabase.instance;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final DefaultCacheManager _cacheManager = DefaultCacheManager();
  String messageTitle = "Empty";
  String notificationAlert = "alert";
  late int humidityVal = 0;
  late int tempVal = 0;
  late String wetVal = "false";
  late String cryVal = "false";
  late String imageUrl = "";
  late String imgUrl = "https://firebasestorage.googleapis.com/v0/b/babymon-1ac0c.appspot.com/o/images%2Fimage.png?alt=media";

  void getTemp() async {
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('temperature');
        starCountRef.onValue.listen((DatabaseEvent event) {
          setState(() {
          tempVal = int.parse(event.snapshot.value.toString());            
          });
      print(tempVal);
});
  }
  void getHumidity() async {
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('humidity');
        starCountRef.onValue.listen((DatabaseEvent event) {
          setState(() {
          humidityVal = int.parse(event.snapshot.value.toString());            
          });
      print(humidityVal);
});
  }
  void getwet() async {
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('isWet');
        starCountRef.onValue.listen((DatabaseEvent event) {
          setState(() {
          wetVal = event.snapshot.value.toString();
          });
      print(wetVal);
});
  }
  void getcry() async {
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('isCrying');
        starCountRef.onValue.listen((DatabaseEvent event) {
          setState(() {
          cryVal = event.snapshot.value.toString();
          });
      print(cryVal);
});
  }
  void getimg() async {
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('image_url');
        starCountRef.onValue.listen((DatabaseEvent event) {
          setState(() {
          imgUrl = event.snapshot.value.toString();
          });
      print(imgUrl);
});
  // Remove the existing image from cache
  await _cacheManager.removeFile("$imgUrl");

  // Fetch the new image from the URL and update the cache
  await _cacheManager.getSingleFile("$imgUrl");
  
  }
  @override
  void initState() {
    getHumidity();
    getTemp();
    getcry();
    getwet();
    getimg();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 249, 255),
      appBar: AppBar(title: Text("Babymonitor")),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [Center(child:Column(children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
              color: Color.fromARGB(255, 64, 124, 255)
            ),
            width: screenWidth * 0.7,
            height: screenHeight * 0.06,
            padding: const EdgeInsets.only(left: 60,right: 50),
            margin: const EdgeInsets.only(top: 40),
            child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Text(tempVal.toString(),
                    style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
                    Spacer(),
                    Text(humidityVal.toString(),
                    style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),)
                    ],
            ),
            ),
            Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
              color: Color.fromARGB(255, 64, 124, 255)
            ),
            width: screenWidth * 0.7,
            height: screenHeight * 0.06,
            padding: const EdgeInsets.only(left: 30,right: 30),
            child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Text("temperature",
                    style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
                    Spacer(),
                    const Text("humidity",
                    style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),)
                    ],
            ),
            ),
            Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 64, 124, 255)
            ),
            width: screenWidth * 0.7,
            height: screenHeight * 0.13,
            padding: const EdgeInsets.only(left: 30,right: 30,top: 20,bottom: 20),
            margin: const EdgeInsets.only(top: 30),
            child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Text("baby is crying: $cryVal",
                    style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
                    Spacer(),
                    Text("baby is wet $wetVal",
                    style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),)
                    ],
            ),
            ),
            Container(
              decoration: const BoxDecoration(
              color: Color.fromARGB(255, 64, 124, 255)
            ),
            width: screenWidth * 0.9,
            height: screenHeight * 0.1,
            padding: const EdgeInsets.only(left: 30,right: 30,top: 20,bottom: 0),
            margin: const EdgeInsets.only(top: 30),
            child: Text("Footage from babyMon",
                    style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
            ),
            Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 64, 124, 255)
            ),
            width: screenWidth * 0.9,
            height: screenHeight * 0.27,
            padding: const EdgeInsets.only(left: 30,right: 30,top: 0,bottom: 20),
            child: CachedNetworkImage(
                    imageUrl: imgUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                            ),
                      ),
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
            ),
          ]
          ))],
      ),
    );
  }
}
