import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:news_app/shared/cubit/states.dart';
import 'package:news_app/shared/network/local/cache_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  int selectedIndex = 0;
  Database? db;
  List<Map>? newTasksList;
  List<Map>? doneTasksList;
  List<Map>? archivedTasksList;
  bool isDarkMode = CacheHelper.getData(key: 'isDarkMode') ?? false;
  var bottomSheetOpen = false;
  void changeIndex(int newIndex) {
    selectedIndex = newIndex;
    emit(BottomNavBarChangeState());
  }

  void setBottomSheetState(bool open) {
    bottomSheetOpen = open;
    emit(SetBottomSheetState());
  }

  void createDataBase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) async {
        print('Database Created');
        await db
            .execute(
                'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT,status TEXT)')
            .then((value) {
          print('Table Created');

          emit(CreateDataBaseState());
        }).catchError((error) {
          print('Error while creating Table: ${error.toString()}');
        });
      },
      onOpen: (data) {
        print('Database Opened');
        db = data;
        getData();
      },
    ).catchError(
      (error) {
        print('Error while creating Databse: ${error.toString()}');
      },
    ).then((value) {
      db = value;
    });
  }

  insertData({
    required String title,
    required String date,
    required String time,
  }) async {
    await db?.transaction(
      (txn) => txn
          .rawInsert(
              'INSERT INTO Tasks(title,date,time,status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print(
            'Data inserted succesfully\nTitle: $title \nDate: $date\nTime: $time');
        emit(InsertToDataBaseState());
        getData();
      }).catchError(
        (error) => print('Error while inserting data: ${error.toString()}'),
      ),
    );
  }

  void getData() {
    newTasksList = [];
    doneTasksList = [];
    archivedTasksList = [];
    emit(GetFromDataBaseLoadingState());
    db!.rawQuery('SELECT * FROM Tasks').then((List value) {
      for (var element in value) {
        if (element['status'] == 'new') {
          newTasksList?.add(element);
        } else if (element['status'] == 'done') {
          doneTasksList?.add(element);
        } else {
          archivedTasksList?.add(element);
        }
      }
      print(value);
      emit(GetFromDataBaseState());
    });
  }

  void updateData({required int id, required db, required String status}) {
    db.rawUpdate('UPDATE Tasks SET status = ? WHERE id = ?', [status, id]);
    emit(UpdateDataBaseState());
  }

  void deleteData({required id}) {
    db!.rawDelete('DELETE FROM Tasks WHERE id = ?', [id]);
    getData();
    emit(DeleteFromDataBaseState());
  }

  void changeBrightnessMode() {
    isDarkMode = !isDarkMode;
    CacheHelper.setData(key: 'isDarkMode', value: isDarkMode);
    emit(AppChangeBrightnessModeState());
  }
}
