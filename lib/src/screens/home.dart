import 'package:flutter/material.dart';
import 'widgets/cat.dart';
import 'dart:math';
//Made by Alexis Gabriel Sanchez Cárcamo
// 05/08/19

///This app contains a cat inside a box, bout elements have an animation.
///On the center of the screen you see a cat hiding inside a box.
///The flaps of the box are shaking because the cat is doing something inside.
///When you tap the box the little cat goes out and the flaps stop shaking.
///
/// App Components Explanation
/// To use an Animation you need:
///Animation, AnimationController,Tween and AnimatedBuilder objects.
///Animation:
///Records the current 'value' of the property being animated
///Records the status of the animation (currently runing, stopped, etc)
///p/e: status:'stopped' yPosition: 110px

///AnimationController:
///Starts, stops, restarts the animation
///Records the duration of the animation
///p/e: duration:1 second, start(),stop()
///the Animation Controller needs an instance of TickerProvider
///so we mix our State class with TickerProviderStateMixin
///Tickers can be used by any object that wants to be
///notified whenever a frame triggers
///when you animate something the TickerProvider tells the animation to update
///his position.
///
///Tween:
///Describes the range that the value being animated spans
///p/e: start with a value of 0px, end with a value of 200px
///
///AnimatedBuilder:
///Takes an animation and a builder
class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  Animation<double> catAnimation;
  AnimationController catController;
  Animation<double> boxAnimation;
  AnimationController boxController;

  @override
  void initState() {
    super.initState();

    catController = AnimationController(
      duration: Duration(milliseconds: 200),
      // the class is mixed with a TickerProvider
      vsync: this,
    );
    catAnimation = Tween(begin: -35.0, end: -80.0)
        //the curve parameter inside CurveAnimation
        // dictates how fast or slow goes the animation
        .animate(CurvedAnimation(parent: catController, curve: Curves.easeIn));

    boxController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350));

    boxAnimation = Tween(begin: pi * 0.6, end: pi * 0.65).animate(
        CurvedAnimation(parent: boxController, curve: Curves.easeInOut));

    boxAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        boxController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        boxController.forward();
      }
    });
    boxController.forward();
  }

  onTap() {
    boxController.stop();
    if (catController.status == AnimationStatus.completed) {
      // makes the animation start and restart
      boxController.forward();
      catController.reverse();
    } else if (catController.status == AnimationStatus.dismissed) {
      catController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation!'),
      ),
      body: GestureDetector(
        child: Center(
          //Stack its a widget that allows you to put widgets over other widgets
          // if you don't declare a widget to be positioned then its non-positioned by default
          // you have to use Positioned widget as parent of the widget you wan to specifically gave a position on the stack
          child: Stack(overflow: Overflow.visible, children: <Widget>[
            buildAnimation(),
            buildBox(),
            buildLeftFlap(),
            buildRightFlap()
          ]),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget buildAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      builder: (context, child) {
        return Positioned(
          // position shrinks the image to fit or be positioned the way you want
          // it need a child and the values of the constraints
          child: child,
          top: catAnimation.value,
          right: 0.0,
          left: 0.0,
        );
      },
      child: Cat(),
    );
  }

  Widget buildBox() {
    return Container(
      height: 200.0,
      width: 200.0,
      color: Colors.brown,
    );
  }

  Widget buildLeftFlap() {

    return Positioned(
      top: 1.95,
      left: 4.0,
      child: AnimatedBuilder(
        animation: boxAnimation,
        child: Container(
          height: 10.0,
          width: 125.0,
          color: Colors.brown,
        ),
        builder: (context, child) {
          //Transform.rotate is a class that allows you to rotate a widget
          // to n digress
          return Transform.rotate(
            angle: boxAnimation.value,
            child: child,
            alignment: Alignment.topLeft,
          );
        },
      ),
    );
  }

  Widget buildRightFlap() {
    return Positioned(
      top: 1.95,
      right: 4.0,
      child: AnimatedBuilder(
        animation: boxAnimation,
        child: Container(
          height: 10.0,
          width: 125.0,
          color: Colors.brown,
        ),
        builder: (context, child) {
          return Transform.rotate(
            angle: -boxAnimation.value,
            child: child,
            alignment: Alignment.topRight,
          );
        },
      ),
    );
  }
}
