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

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

  class _OnboardingPageState extends State<OnboardingPage> {
  final controller = OnboardingItems();
  final pageController = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomSheet: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 35),
        child: isLastPage
            ? getStarted()
            : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                onPressed: () => pageController.jumpToPage(controller.items.length - 1),
                child: Text("Atla", style: TextStyle(fontSize: 20))
            ),
            Flexible(
              child: SmoothPageIndicator(
                controller: pageController,
                count: controller.items.length,
                onDotClicked: (index) => pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeIn
                ),
                effect: const WormEffect(
                  dotHeight: 12,
                  dotWidth: 12,
                  activeDotColor: buttonColor,
                ),
              ),
            ),
            TextButton(
                onPressed: () => pageController.nextPage(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeIn
                ),
                child: Text("İleri", style: TextStyle(fontSize: 20))
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: PageView.builder(
            onPageChanged: (index) => setState(() => isLastPage = controller.items.length - 1 == index),
            itemCount: controller.items.length,
            controller: pageController,
            itemBuilder: (context, index) {
              double imageContainerHeight = index == 0 ? 550: 300;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: imageContainerHeight,
                    width: double.infinity,
                    child: Image.asset(
                      controller.items[index].image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    controller.items[index].title,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.blue[900],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    controller.items[index].description,
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            },
          ),
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
        height: 60,
        child: TextButton(
          onPressed: () async {


            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>LoginPage()));
          },
          child: Text("Uygulamaya Giriş Yap!",
            style:TextStyle(color:textColor),),)
    );
  }
  }


class OnboardingItems {
  List<OnboardingInfo> items = [
    OnboardingInfo(title: "", description: '', image: "assets/images/ekoPal_giris.jpg"),
    OnboardingInfo(title: "Aklına Takılan soruların mı var?",
        description: "EkoPal sayesinde aklındaki soruları kolayca sorabilir, "
            "anında tecrübeli kişiler tarafından yanıtlar alabilir, "
            "seninle aynı soruları olan insanlarla birlik oluşturabilirsin",
        image: "assets/images/onboard_bir.jpg"),
    OnboardingInfo(title: "Neye ihtiyacın var?",
        description: "Dersin için kitaba mı ihtiyacın var? Staj yapmak için bir yer mi arıyorsun? Projende birlikte çalışabileceğin takım arkadaşları mı arıyorsun?"
            " EkoPal sayesinde aradığın her şey tek bir yerde. Kolayca çalışmak için projeler, stajlar bulabilir, aradığın kitaba rahatlıkla ulaşabilirsin.",
        image: "assets/images/onboard_iki.gif"),
    OnboardingInfo(title: "Üniversiten ile bağlantı kur",
        description: "Üniversitende neler olduğunu kaçırmamak ve daha fazlası için EkoPal'a kayıt yap!",
        image: "assets/images/onboard_üc.gif"),
  ];
}

class OnboardingInfo {
  final String title;
  final String description;
  final String image;

  OnboardingInfo({
    required this.title,
    required this.description,
    required this.image
  });
}
