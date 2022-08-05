import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/layout/news_layout/cubit/cubit.dart';
import 'package:news_app/layout/news_layout/cubit/states.dart';
import 'package:news_app/modules/news_app/search/search.dart';

import 'package:news_app/shared/components/components.dart';
import 'package:news_app/shared/cubit/cubit.dart';

class NewsLayout extends StatelessWidget {
  const NewsLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit, NewsAppStates>(
      listener: ((context, state) {}),
      builder: ((context, state) {
        var newsCubit = NewsCubit.get(context);
        var appCubit = AppCubit.get(context);

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('News App'),
              actions: [
                IconButton(
                    onPressed: () {
                      navigatTo(context, SearchScreen());
                    },
                    icon: const Icon(Icons.search)),
                IconButton(
                    onPressed: () {
                      appCubit.changeBrightnessMode();
                    },
                    icon: const Icon(Icons.brightness_4)),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.business),
                  label: 'Business',
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.sports), label: 'Sports'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.science), label: 'Science'),
              ],
              onTap: (index) {
                newsCubit.setIndex(index);
              },
              currentIndex: newsCubit.selectedIndex,
            ),
            body: newsCubit.screens[newsCubit.selectedIndex],
          ),
        );
      }),
    );
  }
}
