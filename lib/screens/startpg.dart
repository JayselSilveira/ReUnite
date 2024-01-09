import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,//setting height of appBar
        centerTitle: true,
        title:  Column(
            children: const <Widget>[
              Text('Welcome', style: TextStyle(fontSize: 28),),
            ]
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: SizedBox(
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/missing1.png'),
                            fit: BoxFit.fill
                        )
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const
                    [
                       Expanded(
                          child: Text('REUNITE ',
                            style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,)
                      )
                    ],
                  ),

                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                    const[

                      Expanded(
                          child: Text('We hope our app will help families find their '
                              'lost or missing children by providing their information. ',
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,)
                      )
                    ],
                  ),

                  const SizedBox(height: 20,),
                  ElevatedButton(
                      onPressed: (){
                        Navigator.pushNamed(context, "/login");
                      },
                      child: const SizedBox(
                          width: 150,
                          child: Text('Log In',textAlign: TextAlign.center,))
                  ),

                  const SizedBox(height: 20,),
                  ElevatedButton(
                      onPressed: (){
                        Navigator.pushNamed(context, "/signup");
                      },
                      child: const SizedBox(
                          width: 150,
                          child: Text('Sign Up',textAlign: TextAlign.center,)),

                  ),

                  const SizedBox(height: 20,),
                  ElevatedButton(
                      onPressed: (){
                        Navigator.pushNamed(context, "/homepg");
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.black26), //setting elevated button color
                      ),
                      child: const SizedBox(
                          width: 150,
                          child: Text('Skip',textAlign: TextAlign.center,)),
                  ),

                ],
              ),
            ),

          ),
        ),
      ),
    );
  }
}
