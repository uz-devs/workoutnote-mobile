import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:workoutnote/business_logic/ConfigProvider.dart';
import 'package:workoutnote/utils/Strings.dart';
import 'package:workoutnote/utils/Utils.dart';

class OneRepMaxCalWebView extends StatefulWidget {
  final pageTitle;
  final fullUrl;

  OneRepMaxCalWebView(this.pageTitle, this.fullUrl);

  @override
  _OneRepMaxCalWebViewState createState() => new _OneRepMaxCalWebViewState();
}

class _OneRepMaxCalWebViewState extends State<OneRepMaxCalWebView> {
  final GlobalKey webViewKey = GlobalKey();
  var configProvider = ConfigProvider();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useOnDownloadStart: true,
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  String url = '';
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      configProvider = Provider.of<ConfigProvider>(context, listen: false);

      isInternetConnected().then((value) {
        if (!value) {
          showAlertDialog(context);
        }
      });
    });

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: Color.fromRGBO(102, 51, 204, 1)), onPressed: () => Navigator.of(context).pop()), backgroundColor: Colors.white, title: Text(widget.pageTitle, style: TextStyle(color: Colors.black))),
        body: SafeArea(
          child: Column(children: <Widget>[
            Expanded(
              child: Stack(children: [
                InAppWebView(
                  key: webViewKey,
                  initialUrlRequest: URLRequest(url: Uri.parse(widget.fullUrl)),
                  initialOptions: options,
                  // pullToRefreshController: pullToRefreshController,
                  onWebViewCreated: (controller) => webViewController = controller,
                  onDownloadStart: (controller, url) async {
                    var myImage = url.toString().split(',')[1];
                    final encodedStr = myImage;
                    Uint8List bytes = base64.decode(encodedStr);
                    print(bytes);
                    var dir = Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationSupportDirectory();
                    if (dir != null) {
                      File file = File('${dir.path}/myWorkoutnoteCard.png');
                      if (file.existsSync()) file.deleteSync();
                      file.writeAsBytes(bytes).then((value) => ShareExtend.share(file.path, 'My workoutnote card'));
                    }
                  },
                  androidOnPermissionRequest: (controller, origin, resources) async {
                    return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
                  },
                ),
                progress < 1.0 ? LinearProgressIndicator(value: progress) : Container()
              ]),
            )
          ]),
        ));
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons

    Widget continueButton = Center(
      child: TextButton(
        child: Text('${quit[configProvider.activeLanguage()]}', style: TextStyle(color: Color.fromRGBO(102, 51, 204, 1))),
        onPressed: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
      title: Text(
        '${noInternetTitle[configProvider.activeLanguage()]}',
      ),
      content: Text(
        '${connectInternetMsg[configProvider.activeLanguage()]}',
      ),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
