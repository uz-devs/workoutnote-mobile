import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/business_logic/ConfigProvider.dart';
import 'package:workoutnote/utils/Strings.dart';
import 'package:workoutnote/utils/Utils.dart';

class OneRepMaxCalWebView extends StatefulWidget {
  final fullUrl;

  OneRepMaxCalWebView(this.fullUrl);

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
        body: SafeArea(
            child: Column(children: <Widget>[
      Expanded(
        child: Stack(
          children: [
            InAppWebView(
              key: webViewKey,
              initialUrlRequest: URLRequest(url: Uri.parse(widget.fullUrl)),
              initialOptions: options,
              // pullToRefreshController: pullToRefreshController,
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onDownloadStart: (controller, url) async {
                //TODO  implement download functionality later
                // final taskId = await FlutterDownloader.enqueue(
                //   url: url.toString(),
                //   savedDir: (await getExternalStorageDirectory())!.path,
                //   showNotification: true, // show download progress in status bar (for Android)
                //   openFileFromNotification: true, // click on notification to open downloaded file (for Android)
                // );
              },
              onLoadStart: (controller, url) {
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              androidOnPermissionRequest: (controller, origin, resources) async {
                return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
              },

              onLoadStop: (controller, url) async {
                pullToRefreshController.endRefreshing();
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onLoadError: (controller, url, code, message) {
                pullToRefreshController.endRefreshing();
              },
              onProgressChanged: (controller, progress) {
                if (progress == 100) {
                  pullToRefreshController.endRefreshing();
                }
                setState(() {
                  this.progress = progress / 100;
                  urlController.text = this.url;
                });
              },
              onUpdateVisitedHistory: (controller, url, androidIsReload) {
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onConsoleMessage: (controller, consoleMessage) {
                print(consoleMessage);
              },
            ),
            progress < 1.0 ? LinearProgressIndicator(value: progress) : Container(),
          ],
        ),
      ),
    ])));
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons

    Widget continueButton = Center(
      child: TextButton(
        child: Text('${quit[configProvider.activeLanguage()]}'),
        onPressed: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('${noInternetTitle[configProvider.activeLanguage()]}'),
      content: Text('${connectInternetMsg[configProvider.activeLanguage()]}'),
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
