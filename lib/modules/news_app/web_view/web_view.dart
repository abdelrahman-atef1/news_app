import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/layout/news_layout/cubit/cubit.dart';
import 'package:news_app/layout/news_layout/cubit/states.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  String url;
  WebViewScreen({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsAppStates>(
      listener: (BuildContext context, Object? state) {},
      builder: (BuildContext context, state) {
        var cubit = NewsCubit.get(context);
        return Scaffold(
          appBar: AppBar(),
          body: Stack(
            children: [
              WebView(
                initialUrl: url,
                javascriptMode: JavascriptMode.unrestricted,
                onProgress: (progress) {
                  cubit.setWebViewLoadingState('progress');
                },
                onPageFinished: (finish) {
                  cubit.setWebViewLoadingState('finish');
                },
              ),
              cubit.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(),
            ],
          ),
        );
      },
    );
  }
}
