import 'package:freezed_annotation/freezed_annotation.dart';

import '../utils/utils.dart';

part 'category_state.freezed.dart';

@freezed
class CategoryState with _$CategoryState {
  const factory CategoryState.initial() = _Initial;
  const factory CategoryState.loading() = CategoryLoadingState;
  const factory CategoryState.load({required CategoryModel category}) = CategoryLoadedState;

}
