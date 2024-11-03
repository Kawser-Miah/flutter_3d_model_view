import 'package:flutter_bloc/flutter_bloc.dart';

import 'category_event.dart';
import 'category_state.dart';
export 'category_event.dart';
export 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(const CategoryState.initial()) {
    on<Started>((event, emit) async{
      emit(CategoryLoadingState());
      await Future.delayed(Duration(milliseconds: 100), () {
        emit(CategoryLoadedState(category: event.category));
      });
    });
  }
}
