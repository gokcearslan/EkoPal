import 'package:ekopal/colors.dart';
import 'package:ekopal/login_page.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EKOPAL',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OnboardingPage(),
    );
  }
}

class  OnboardingPage extends StatefulWidget {
  const OnboardingPage ({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {

  final controller =OnboardingItems();
  final pageController=PageController();
  bool isLastPage=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      bottomSheet: Container(
        color:backgroundColor,
        padding:EdgeInsets.symmetric(horizontal:100 ,vertical: 60),
        child: isLastPage? getStarted(): Row(
        children: [
          TextButton(
              onPressed: ()=>pageController.jumpToPage(controller.items.length-1),
              child: Text("Atla",
              style: TextStyle(fontSize: 20),)),

          SmoothPageIndicator(
            controller:pageController,
            count:controller.items.length,
            onDotClicked:(index)=>pageController.animateToPage(index,
            duration:const Duration(milliseconds:600),curve: Curves.easeIn),
            effect:const WormEffect(
                    dotHeight:12,
                    dotWidth:12,
                    activeDotColor:buttonColor,
                ),
          ),


          TextButton(onPressed:()=>pageController.nextPage(
              duration:const Duration(milliseconds:600),
              curve: Curves.easeIn),
              child: Text("İleri",
                style: TextStyle(fontSize: 20),)),
        ],
      ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: PageView.builder(
          onPageChanged: (index)=>setState(()=>isLastPage=controller.items.length-1==index),
          itemCount: controller.items.length,
          controller: pageController,
          itemBuilder: (context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  child: Image.network(
                    controller.items[index].image,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(controller.items[index].title,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(controller.items[index].description,
                  style: const TextStyle(
                    fontSize: 16,
                    color:textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

            );
          },
        ),
      ),
    );
  }

 Widget getStarted(){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color:buttonColor,
      ),
      width:MediaQuery.of(context).size.width*3,
      height: 55,
      child: TextButton(
        onPressed: () async {


          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>LoginPage()));
        },
        child: Text("Uygulamaya Giriş Yap!",
              style:TextStyle(color:textColor),),)
   );


 }


}


class OnboardingItems{
  List<OnboardingInfo> items= [
    OnboardingInfo(title: "Aklına Takılan soruların mı var?",
        description: "EkoPal sayesinde aklındaki soruları kolayca sorabilir, "
            "anında tecrübeli kişiler tarafından yanıtlar alabilir, "
            "seninle aynı soruları olan insanlarla birlik oluşturabilirsin",
        image: "https://i.pinimg.com/564x/59/09/05/5909051abd57ab7d03eb72883f723c12.jpg"),

    OnboardingInfo(title: "Neye ihtiyacın var?",
        description: "Dersin için kitaba mı ihtiyacın var? Staj yapmak için bir yer mi arıyorsun? Projende birlikte çalışabileceğin takım arkadaşları mı arıyorsun?"
            " EkoPal sayesinde aradığın her şey tek bir yerde. Kolayca çalışmak için projeler, stajlar bulabilir, aradığın kitaba rahatlıkla ulaşabilirsin.",
        image: "https://i.pinimg.com/originals/cd/54/d0/cd54d03bcd65a36fae7c0788ddc622d8.gif"),

    OnboardingInfo(title: "Üniversiten ile bağlantı kur",
        description: "Üniversitende neler olduğunu kaçırmamak ve daha fazlası için EkoPal'a kayıt yap!",
        image: "https://i.pinimg.com/originals/5a/f9/83/5af98367e525a094d8590cb4ef051825.gif"),

  ];
}

class OnboardingInfo{
  final String title;
  final String description;
  final String image;

  OnboardingInfo(
      {
        required this.title,
        required this.description,
        required this.image
      }
      );
}
