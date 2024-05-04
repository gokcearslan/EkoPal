import 'package:ekopal/colors.dart';
import 'package:flutter/material.dart';

//Son sayfaya Giriş butonu eklenecek
//indicator eklenecek
//login öncesine koyulacak



class  OnboardingPage extends StatefulWidget {
  const OnboardingPage ({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {

  final controller =OnboardingItems();
  final pageController=PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      bottomSheet: Row(
        children: [
          TextButton(
              onPressed: ()=>pageController.jumpToPage(controller.items.length-1),
              child: Text("Atla")),
          //INDICATOR EKLENECEK -g
         /*
          SmootingPageIndicator(
            controller:pageController,
            caount:controller.items.length,
            onDotCliked:(index)=>pageController.animateToPage(index,
                   duration:const Duration(milliseconds:600),
            effect:const WormEffect(
                    dotHeight:12,
                    dotWidth:12,
                    activeDotColor:buttonColor,
                ),
          ),
          */

          TextButton(onPressed:()=>pageController.nextPage(
              duration:const Duration(milliseconds:600),
              curve: Curves.easeIn),
              child: Text("İleri"))
        ],
      ),

      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: PageView.builder(
          itemCount: controller.items.length,
          controller: pageController,
          itemBuilder: (context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(controller.items[index].image),
                Text(controller.items[index].title,
                  style: TextStyle(
                    fontSize: 24, // Set font size
                    color: Colors.blue[900], // Set text color
                    fontWeight: FontWeight.bold, // Set font weight
                  ),
                ),
                SizedBox(height: 20),
                Text(controller.items[index].description,
                  style: const TextStyle(
                    fontSize: 16, // Set font size
                    color:textColor, // Set text color
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




}


class OnboardingItems{
  List<OnboardingInfo> items= [
    OnboardingInfo(title: "Aklına Takılan soruların mı var?",
        description: "EkoPal sayesinde aklındaki soruları kolayca sorabilir, "
            "anında tecrübeli kişiler tarafından yanıtlar alabilir, seninle aynı soruları olan insanlarla birlik oluşturabilirsin",
        image: "https://i.pinimg.com/564x/59/09/05/5909051abd57ab7d03eb72883f723c12.jpg"),

    OnboardingInfo(title: "Neye ihtiyacın var?",
        description: "EkoPal sayesinde arağın her şey tek bir yerde. Kolayca çalışmak için projeler, stajlar bulabilir, aradğın kitaba rahatlıkla ulaşabilirsin.",
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
