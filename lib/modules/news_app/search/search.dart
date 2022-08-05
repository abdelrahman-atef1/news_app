import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/layout/news_layout/cubit/cubit.dart';
import 'package:news_app/layout/news_layout/cubit/states.dart';
import 'package:news_app/shared/components/components.dart';
import 'package:news_app/shared/cubit/cubit.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var appCubit = AppCubit.get(context);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: defaultTextFormField(
              textController: searchController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Search can\'t be empty';
                }
                return null;
              },
              onFieldSubmitted: (value) {
                NewsCubit.get(context).getSearchData(query: {
                  'q': searchController.text,
                  'apiKey': '1503b1a3548f4f55beab94b261156813',
                }, url: 'v2/everything');
              },
              labelText: 'Search',
              prefixIcon: Icons.search,
              isDarkMode: appCubit.isDarkMode,
              textDirection: TextDirection.rtl,
            ),
          ),
          BlocConsumer<NewsCubit, NewsAppStates>(
            listener: (context, status) {},
            builder: (contex, state) {
              var cubit = NewsCubit.get(context);
              if (cubit.searchData.isEmpty) {
                return state is NewsGetSearchDataLoadingState
                    ? const Center(child: CircularProgressIndicator())
                    : Container();
              } else {
                return Expanded(
                    child: newsItem(context: context, data: cubit.searchData));
              }
              // if (state is NewsGetSearchDataLoadingState ||
              //     state is NewsInitialState) {
              //   return const Center(child: CircularProgressIndicator());
              // } else if (state is NewsGetSearchDataErrorState) {
              //   return Center(child: Text(cubit.getDataError.toString()));
              // } else if (cubit.getDataError == null) {
              //   return newsItem(context: context, data: cubit.searchData);
              // } else {
              //   return Center(child: Text(cubit.getDataError.toString()));
              // }
            },
          ),
        ],
      ),
    );
  }
}
