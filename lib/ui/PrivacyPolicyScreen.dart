import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/business_logic/ConfigProvider.dart';
import 'package:workoutnote/utils/Strings.dart';
import 'package:workoutnote/utils/Utils.dart';

class PrivacyPolicy extends StatefulWidget {
  PrivacyPolicy({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  final GlobalKey _globalKey = GlobalKey();
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  @override
  Widget build(BuildContext context) {
    var configProvider = Provider.of<ConfigProvider>(context);
    return Scaffold(
        appBar: AppBar(leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: Color.fromRGBO(102, 51, 204, 1)), onPressed: () => Navigator.of(context).pop()), backgroundColor: Colors.white, title: Text('${privacyPolicy[configProvider.activeLanguage()]}', style: TextStyle(color: Colors.black))),
        body: Container(
          child: SafeArea(
            child: InAppWebView(
              key: _globalKey,
              initialUrlRequest: URLRequest(url: Uri.parse(privacyPolicyUrl)),
              initialOptions: options,
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
            ),
          ),
        ));
  }
}
