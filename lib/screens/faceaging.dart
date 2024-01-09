import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class FaceAging extends StatefulWidget {
  const FaceAging({Key? key}) : super(key: key);

  @override
  State<FaceAging> createState() => _FaceAgingState();
}

class _FaceAgingState extends State<FaceAging> {
  late InAppWebViewController inAppWebViewController;
  double _progress = 0;

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: ()async{

        var isLastPage = await inAppWebViewController.canGoBack();

        if(isLastPage){
          inAppWebViewController.goBack();
          return false;
        }

        return true;
      },
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
            toolbarHeight: 90,//setting height of appBar
            centerTitle: true,
            title:  Column(
            children: const <Widget>[
            Text('Perform Face Aging', style: TextStyle(fontSize: 28),
            ),
            ]
            ),
            ),
        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(
                  url: Uri.parse('https://82d0-20-204-230-226.ngrok-free.app/')
              ),
              onWebViewCreated: (InAppWebViewController controller){
                inAppWebViewController = controller;
              },
              onProgressChanged: (InAppWebViewController controller, int progress){
                setState(() {
                  _progress = progress / 100 ;
                });
              },
            ),
            _progress < 1
            ? Container(
              child: LinearProgressIndicator(
                value: _progress,
              ),
            )
            :SizedBox()
          ],
        )
        ),
      ),
    );
  }
}
