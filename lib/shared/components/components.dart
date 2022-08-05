import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart' as intl;
import 'package:news_app/modules/news_app/web_view/web_view.dart';

import 'package:news_app/shared/styles/colors.dart';
import '../../shared/cubit/cubit.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 3.0,
  required void Function()? function,
  required String text,
}) =>
    Container(
      width: width,
      height: 50.0,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
    );
Widget defaultTextFormField(
    {required TextEditingController textController,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    void Function(String)? onFieldSubmitted,
    void Function(String)? onChanged,
    required String? Function(String?)? validator,
    required String labelText,
    required IconData prefixIcon,
    Widget? suffixIcon,
    void Function()? onTap,
    bool isDarkMode = false,
    TextDirection textDirection = TextDirection.ltr}) {
  return TextFormField(
    controller: textController,
    keyboardType: keyboardType,
    obscureText: isPassword,
    onFieldSubmitted: onFieldSubmitted,
    onChanged: onChanged,
    validator: validator,
    onTap: onTap,
    textDirection: textDirection,
    decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(
          prefixIcon,
        ),
        suffixIcon: suffixIcon,
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 2.0),
        )),
  );
}

Widget listItemBuilder(
  BuildContext context,
  Map model,
) {
  var cubit = AppCubit.get(context);
  return Dismissible(
    key: Key(model['id'].toString()),
    child: Padding(
      padding: const EdgeInsetsDirectional.only(start: 10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              child: Text(model['time']),
              backgroundColor: Colors.blue,
              radius: 40,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Text(
                  model['title'],
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  model['date'],
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.check_box),
            onPressed: () {
              cubit.updateData(id: model['id'], db: cubit.db, status: 'done');
              cubit.getData();
            },
          ),
          IconButton(
            icon: const Icon(Icons.archive),
            onPressed: () {
              cubit.updateData(
                  id: model['id'], db: cubit.db, status: 'archived');
              cubit.getData();
            },
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
    ),
    onDismissed: (direction) {
      cubit.deleteData(id: model['id']);
    },
  );
}

Widget taskList({required List list}) {
  return list.isNotEmpty
      ? ListView.separated(
          itemBuilder: (context, index) {
            if (list != []) {
              return listItemBuilder(context, list[index]);
            } else {
              return const CircularProgressIndicator();
            }
          },
          separatorBuilder: (context, index) {
            var brightness = MediaQuery.of(context).platformBrightness;
            bool isDarkMode = brightness == Brightness.dark;
            return Padding(
              padding: const EdgeInsetsDirectional.only(start: 20),
              child: Divider(
                  color: isDarkMode == true ? Colors.white : Colors.black),
            );
          },
          itemCount: list.length,
        )
      : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.menu,
                size: 100,
                color: Colors.grey,
              ),
              Text(
                'No Tasks Yet, Please Add Some Tasks.',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              )
            ],
          ),
        );
}

Widget newsItem({required BuildContext context, required Map data}) {
  var cubit = AppCubit.get(context);
  TextStyle mainTextStyle = Theme.of(context).textTheme.titleMedium!;
  TextStyle secondaryTextStyle = Theme.of(context).textTheme.bodyMedium!;
  return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        var article = data['articles'][index];
        DateTime date =
            intl.DateFormat("y-MM-dd'T'H:m:s'Z'").parse(article['publishedAt']);
        return InkWell(
          onTap: () => navigatTo(context, WebViewScreen(url: article['url'])),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 120,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(10),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image(
                    image: NetworkImage(article['urlToImage'] ??
                        'https://bitsofco.de/content/images/2018/12/Screenshot-2018-12-16-at-21.06.29.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text('${article['title']}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: mainTextStyle),
                      ),
                      Text(
                          article['description'] == null
                              ? ''
                              : '${article['description']}...',
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: secondaryTextStyle),
                      SizedBox(
                        width: double.infinity,
                        child: Text(intl.DateFormat.yMMMd().format(date),
                            textAlign: TextAlign.end,
                            style: secondaryTextStyle),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(
            color: cubit.isDarkMode ? Colors.white : Colors.black,
          ),
      itemCount: data['articles'].length);
}

void navigatTo(BuildContext context, Widget widget, {bool replace = false}) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => widget),
    (Route<dynamic> route) => !replace,
  );
}

enum toastState { success, error, warning }
Color color = mainColor;
Color setColor(toastState state) {
  switch (state) {
    case toastState.success:
      {
        return Colors.green;
      }
    case toastState.error:
      {
        return Colors.red;
      }
    case toastState.warning:
      {
        return Colors.amber;
      }
    default:
      {
        return Colors.green;
      }
  }
}

void showToast({required String message, required toastState state}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: setColor(state),
      textColor: Colors.white,
      fontSize: 16.0);
}

Widget waitingNetworkImage(
    {double? width, double? height, required String url, BoxFit? fit}) {
  return CachedNetworkImage(
    placeholder: (context, str) {
      return ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
                  colors: [Colors.white, Colors.grey.withOpacity(0.4)])
              .createShader(bounds),
          child: Container(
            color: Colors.white,
            width: width,
            height: height,
          ));
    },
    fit: fit,
    width: width,
    height: height,
    imageUrl: url,
  );
}

Widget errorScreen(Function()? retryFunction) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Image(
            width: 200,
            height: 200,
            image: AssetImage(
              'assets/images/internet-error.png',
            )),
        const Text('Please check your internet connection and try again.'),
        IconButton(onPressed: retryFunction, icon: const Icon(Icons.refresh))
      ],
    ),
  );
}
