import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/layout/news_layout/cubit/cubit.dart';
import 'package:news_app/layout/news_layout/cubit/states.dart';
import 'package:news_app/shared/components/components.dart';

bool getData = false;

class SportsScreen extends StatelessWidget {
  const SportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!getData) {
      NewsCubit.get(context).getNewsData(url: 'v2/top-headlines', query: {
        'country': 'eg',
        'category': 'sports',
        'apiKey': '1503b1a3548f4f55beab94b261156813',
      });
      getData = true;
    }
    return BlocConsumer<NewsCubit, NewsAppStates>(
      listener: (context, status) {},
      builder: (contex, state) {
        var cubit = NewsCubit.get(context);

        if (state is NewsGetDataLoadingState || state is NewsInitialState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is NewsGetDataErrorState) {
          getData = false;

          return Center(child: Text(cubit.getDataError.toString()));
        } else if (cubit.getDataError == null) {
          return newsItem(context: context, data: cubit.sportsData);
        } else {
          getData = false;
          return Center(child: Text(cubit.getDataError.toString()));
        }
      },
    );
  }
}
