import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/layout/news_layout/cubit/states.dart';
import 'package:news_app/modules/news_app/business/business.dart';
import 'package:news_app/modules/news_app/science/science.dart';
import 'package:news_app/modules/news_app/sports/sports.dart';
import '../../../shared/network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsAppStates> {
  NewsCubit() : super(NewsInitialState());
  static NewsCubit get(context) => BlocProvider.of(context);
  int selectedIndex = 0;
  Map businessData = {};
  Map sportsData = {};
  Map scienceData = {};
  Map searchData = {};
  var getDataError;

  List screens = const [
    BusinessScreen(),
    SportsScreen(),
    ScienceScreen(),
  ];
  void setIndex(int newIndex) {
    selectedIndex = newIndex;
    emit(NewsNavBarChangeState());
  }

  void getNewsData({required String url, required Map<String, dynamic> query}) {
    emit(NewsGetDataLoadingState());

    DioHelper.getData(url: url, query: query).then((value) {
      if (value == null) {
        getDataError = 'Error while getting data.';
        emit(NewsGetDataErrorState());
        print(getDataError);
      } else if (query['category'] == 'business') {
        businessData = value.data;
        getDataError = null;

        emit(NewsGetDataState());
      } else if (query['category'] == 'sports') {
        sportsData = value.data;
        getDataError = null;

        emit(NewsGetDataState());
      } else if (query['category'] == 'science') {
        scienceData = value.data;
        getDataError = null;

        emit(NewsGetDataState());
      }
    }).onError((error, stackTrace) {
      if (error == null) {
        getDataError =
            'Error occured while getting data please try again later.';
        emit(NewsGetDataErrorState());
      } else {
        print(getDataError.toString());
        emit(NewsGetDataErrorState());
      }
    });
  }

  void getSearchData(
      {required String url, required Map<String, dynamic> query}) {
    emit(NewsGetSearchDataLoadingState());

    DioHelper.getData(url: url, query: query).then((value) {
      if (value == null) {
        getDataError = 'Error while getting Search data.';
        emit(NewsGetSearchDataErrorState());
        print(getDataError);
      } else {
        searchData = value.data;
        getDataError = null;
        emit(NewsGetSearchDataState());
      }
    }).onError((error, stackTrace) {
      if (error == null) {
        getDataError =
            'Error occured while getting data please try again later.';
        emit(NewsGetSearchDataErrorState());
      } else {
        print(getDataError.toString());
        emit(NewsGetSearchDataErrorState());
      }
    });
  }

  var isLoading = true;
  void setWebViewLoadingState(String finish) {
    finish == 'finish' ? isLoading = false : isLoading = true;
    emit(NewsWebViewLoadingState());
  }
}
