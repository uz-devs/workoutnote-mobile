import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:workoutnote/utils/utils.dart';


class PrivacyPolicy extends StatefulWidget {
   PrivacyPolicy({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {

  final GlobalKey _globalKey = GlobalKey();
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform:  InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      )
  );



  @override
  Widget build(BuildContext context) {
    return Container(
      child:
      SafeArea(
        child: InAppWebView(
            key: _globalKey,
            initialUrlRequest: URLRequest(url: Uri.parse(privacyPolicyUrl)),
           initialOptions: options,
          onWebViewCreated: (controller) {
            webViewController = controller;
          },

        ),
      ),

    );
  }
}
