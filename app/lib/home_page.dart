import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: use_key_in_widget_constructors
class CheckConnection extends StatefulWidget{
  @override
  State createState() {
    return _CheckConnection();
  }
}

class _CheckConnection extends State{
  late WebViewController controller;
  StreamSubscription? internetconnection;
  bool isoffline = false;
  //set variable for Connectivity subscription listiner
  
  @override
  void initState() {
    internetconnection = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
        // whenevery connection status is changed.
        if(result == ConnectivityResult.none){
             //there is no any connection
             setState(() {
                 isoffline = true;
             }); 
        }else if(result == ConnectivityResult.mobile){
             //connection is mobile data network
             setState(() {
                isoffline = false;
             });
        }else if(result == ConnectivityResult.wifi){
            //connection is from wifi
            setState(() {
               isoffline = false;
            });
        }
    }); // using this listiner, you can get the medium of connection as well.

    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    internetconnection!.cancel();
    //cancel internent connection subscription after you are done
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await controller.canGoBack()) {
          controller.goBack();
          // stay in app
          return false;
        }
        // exit app
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
          body: SafeArea( 
               child: Column(children: [
                    
                    Container( 
                       child: errmsg("No Internet Connection Available", isoffline),
                       //to show internet connection message on isoffline = true.
                    ),
    
                    Expanded(
                      child: WebView(
                        initialUrl: "https://haraj-express.com/",
                        javascriptMode: JavascriptMode.unrestricted,
                        onWebViewCreated: (WebViewController webViewController){
                          controller = webViewController;
                        },
                      ),
                    ),
                    
    
               ],)
          )
      ),
    );
  }

  Widget errmsg(String text,bool show){
  //error message widget.
      if(show == true){
        //if error is true then show error message box
        return Container(
            padding: const EdgeInsets.all(10.00),
            margin: const EdgeInsets.only(bottom: 3.00),
            color: Colors.red,
            child: Row(children: [

                Container(
                    margin: const EdgeInsets.only(right:6.00),
                    child: const Icon(Icons.info, color: Colors.white),
                ), // icon for error message
                
                Text(text, style: const TextStyle(color: Colors.white)),
                //show error message text
            ]),
        );
      }else{
         return Container();
         //if error is false, return empty container.
      }
  }
}