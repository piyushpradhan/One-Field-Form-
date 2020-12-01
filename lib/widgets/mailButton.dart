import 'package:flutter/material.dart';

class MailButton extends StatefulWidget {
  @override
  _MailButtonState createState() => _MailButtonState();
}

class _MailButtonState extends State<MailButton>
    with TickerProviderStateMixin {

  bool isOpened = false;
  bool isEmail = true; 
  bool passwordEntered = false; 
  bool emailEntered = false; 
  AnimationController _controller;
  AnimationController _passwordController; 
  Animation<double> _sizeAnimation;
  Animation<double> _slidingAnimation;
  Animation<double> _widthAnimation; 
  Animation<double> _fadeOutAnimation; 
  Animation<double> _fadeInAnimation; 

  TextEditingController textFieldController = new TextEditingController(); 

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this
    );

    _passwordController = AnimationController(
      duration: Duration(milliseconds: 200), 
      vsync: this
    );

    _fadeOutAnimation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1, end: 0),
          weight: 50,
        ),
      ]
    ).animate(
      CurvedAnimation(
        parent: _passwordController, 
        curve: Curves.easeOut, 
      )
    );

     _fadeInAnimation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0, end: 1),
          weight: 50,
        ),
      ]
    ).animate(
      CurvedAnimation(
        parent: _passwordController, 
        curve: Curves.easeIn, 
      )
    );

    _slidingAnimation = TweenSequence(
        <TweenSequenceItem<double>>[
          TweenSequenceItem<double>(
              tween: Tween<double>(begin: 0, end: 160),
              weight: 100
          ),
        ]
    ).animate(
      CurvedAnimation(
        parent: _controller, 
        curve: Curves.easeOut,
      )
    );

    _widthAnimation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 55, end: 200), 
          weight: 50, 
        ),
      ]
    ).animate(
      CurvedAnimation(
        parent: _controller, 
        curve: Curves.easeOut 
      )
    );

    _controller.addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        setState(() {
          isOpened = true;
        });
      }
      if(status == AnimationStatus.dismissed) {
        setState(() {
          isOpened = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, _) {
        return Stack(
          children: [
            Opacity(
              opacity:_fadeInAnimation.value, 
              child: Center(
                child: Text(
                  'Welcome', 
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 30, 
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: passwordEntered ? _fadeOutAnimation.value : 1,
              child: Center(
                child: Container(
                  padding: EdgeInsets.only(left: 75, right: 20, top: 3),
                  height: 55.0,
                  width: _widthAnimation.value,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1.0), 
                    borderRadius: BorderRadius.circular(55), 
                    color: Colors.black
                  ),
                  child: TextField(
                    autofocus: true,
                    maxLines: 1,
                    controller: textFieldController,
                    style: TextStyle(
                      color: Colors.white
                    ),
                    obscureText: !isEmail,
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      border: InputBorder.none,
                      hintText: isEmail ? "Your email" : "Password", 
                      hintStyle: TextStyle(
                        color: Colors.grey
                      )
                    ),
                    onSubmitted: (value) {
                      if(emailEntered == false) {
                        _controller.reverse(); 
                        setState(() {
                          textFieldController.clear();
                          isEmail = false; 
                          emailEntered = true; 
                        });
                      } else if (emailEntered == true) {
                        setState(() {
                          passwordEntered = true; 
                          _passwordController.forward(); 
                        });
                        _controller.reverse(); 
                      } else if(passwordEntered == true) {
                        _passwordController.forward(); 
                      }
                    },
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: passwordEntered ? _fadeOutAnimation.value : 1, 
              child: Center(
                child: Container(
                  height: 55,
                  width: 55,
                  margin: EdgeInsets.only(right: _slidingAnimation.value),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(
                          color: Colors.white,
                          width: 1.0,
                          style: BorderStyle.solid
                      ),
                      borderRadius: BorderRadius.circular(55)
                  ),
                  child: IconButton(
                    color: Colors.white,
                    icon: isEmail ? Icon(Icons.mail_outline_rounded) : (passwordEntered ? Icon(Icons.arrow_forward_ios) : Icon(Icons.lock_outlined)),
                    iconSize: 55 * 4/7,
                    splashColor: Colors.transparent,
                    onPressed: () {
                      isOpened ? _controller.reverse() : _controller.forward();
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
