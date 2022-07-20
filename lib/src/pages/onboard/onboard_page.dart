import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:reciclon_client/src/pages/onboard/onboard_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dots_indicator/dots_indicator.dart';

class OnboardPage extends StatefulWidget {
  const OnboardPage({Key? key}) : super(key: key);

  @override
  State<OnboardPage> createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage> {
  final _controller = OnboardController();

  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _controller.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            LiquidSwipe(
              liquidController: _controller.dotController,
              pages: [
                _Page1Swiper(
                    item: _controller.items[0], controlador: _controller),
                _Page2Swiper(
                    item: _controller.items[1], controlador: _controller),
                _Page3Swiper(
                  item: _controller.items[2],
                  controlador: _controller,
                ),
              ],
              fullTransitionValue: 400.0,
              enableLoop: true,
              slideIconWidget: Icon(
                CupertinoIcons.back,
                color: Colors.white,
              ),
              positionSlideIcon: 0.8,
              waveType: WaveType.liquidReveal,
              onPageChangeCallback: (int page) {
                // print(page);
                _controller.currentPage = page;
                refresh();
              },
              currentUpdateTypeCallback: (updateType) => {},
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.06,
              right: MediaQuery.of(context).size.width * 0.42,
              child: DotsIndicator(
                dotsCount: _controller.items.length,
                position: _controller.currentPage / 1,
                decorator: DotsDecorator(
                  size: Size.square(9.0),
                  color: Colors.white38,
                  activeColor: Colors.white,
                  activeSize: Size(25.0, 9.0),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Page1Swiper extends StatelessWidget {
  const _Page1Swiper({
    Key? key,
    required this.item,
    required this.controlador,
  }) : super(key: key);
  final OnboardItem item;
  final OnboardController controlador;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffD65DB1),
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  Expanded(
                    child: SvgPicture.asset(
                      item.imagen,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  Text(
                    item.titulo,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    item.descripcion,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoButton(
                  child: Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => controlador.goToNextOnboardPage(),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(30.0),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Page2Swiper extends StatelessWidget {
  const _Page2Swiper({
    Key? key,
    required this.item,
    required this.controlador,
  }) : super(key: key);
  final OnboardItem item;
  final OnboardController controlador;
  @override
  Widget build(BuildContext context) {
    // print(controller.dotController.currentPage);
    return Container(
      color: Color(0xff845EC2),
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  Expanded(
                      child: SvgPicture.asset(
                    item.imagen,
                    fit: BoxFit.scaleDown,
                  )),
                  Text(
                    item.titulo,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    item.descripcion,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoButton(
                  child: Text(
                    'back',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => controlador.goBackOnboardPage(),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                CupertinoButton(
                  child: Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => controlador.goToNextOnboardPage(),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(30.0),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Page3Swiper extends StatelessWidget {
  const _Page3Swiper({
    Key? key,
    required this.item,
    required this.controlador,
  }) : super(key: key);
  final OnboardItem item;
  final OnboardController controlador;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff0081CF),
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  Expanded(
                    child: SvgPicture.asset(
                      item.imagen,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  Text(
                    item.titulo,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    item.descripcion,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: Text(
                    'back',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => controlador.goBackOnboardPage(),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                CupertinoButton(
                  child: Text(
                    'Exit',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => controlador.goToLoginScreen(),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(30.0),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
