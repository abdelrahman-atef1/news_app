import 'cubit.dart';

abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppChangeBrightnessModeState extends AppStates {}

class BottomNavBarChangeState extends AppStates {}

class CreateDataBaseState extends AppStates {}

class InsertToDataBaseState extends AppStates {}

class GetFromDataBaseState extends AppStates {}

class GetFromDataBaseLoadingState extends AppStates {}

class UpdateDataBaseState extends AppStates {}

class DeleteFromDataBaseState extends AppStates {}

class SetBottomSheetState extends AppStates {}
