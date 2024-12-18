import 'package:animator/View/detail_page.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/space_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  final int count = 9;
  late List<AnimationController> animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController=List.generate(count, (index) => AnimationController(vsync: this,
      duration: Duration(seconds: 30),
      lowerBound: 0,
      upperBound: 1,
    ),);

    for (var controller in animationController) {
      controller.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> cardColors = [
      Color(0xff212121),
      Color(0xff252525),
      Color(0xff2c2c2c),
      Color(0xff2e2e2e),
      Color(0xff393939),
      Color(0xff393939),
      Color(0xff393939),
      Color(0xff393939),
      Color(0xff393939),
    ];

    PlanetProvider planetProvider =
    Provider.of<PlanetProvider>(context, listen: false);
    return Scaffold(
      body: Center(child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(image: NetworkImage('https://images.unsplash.com/photo-1628498188904-036f5e25e93e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8c3RhcnJ5JTIwc2t5fGVufDB8fDB8fHww',),fit: BoxFit.cover,opacity: 0.5)
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15,right: 15,top: 60,bottom: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50,),
              Swiper(
                onTap: (index) {
                  planetProvider.select=index;
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailPage(),));
                },
                onIndexChanged: (value) {
                  setState(() {
                    cardColors[value]=Color(0xff212121);
                  });
                },
                itemBuilder: (BuildContext context, int index) {
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: Card(
                          color: Color(0xff212121),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child:  Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Spacer(),
                                Text('${planetProvider.planetList[index].name}',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 50),),
                                Container(
                                    height: 150,
                                    width: double.infinity,
                                    color: Colors.transparent,
                                    child: Text('${planetProvider.planetList[index].description}',style: TextStyle(color: Colors.white54,fontWeight: FontWeight.w500,fontSize: 15),overflow: TextOverflow.fade)),
                                Text('\n\n                                                More Details',style: TextStyle(color: Colors.yellow,fontWeight: FontWeight.w500,fontSize: 17,),),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        left:50,
                        child: AnimatedBuilder(
                          animation: animationController[index],
                          builder: (context, child) => RotationTransition(
                            turns: animationController[index],
                            child: Container(
                              height: 229,
                              width: 270,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.transparent,
                                  image: DecorationImage(image: AssetImage(planetProvider.planetList[index].image),fit: BoxFit.cover)
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  );
                },
                itemCount: planetProvider.planetList.length,
                itemWidth: 380,
                itemHeight: 550,
                layout: SwiperLayout.TINDER,

              ),

            ],
          ),
        ),
      )),
    );
  }
}
int currentIndex=0;