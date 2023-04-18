import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'counter_state.dart';

final counterProvider =
    StateNotifierProvider.autoDispose<CounterNotifier, CounterState>(
  (_) => CounterNotifier(),
);

class CounterNotifier extends StateNotifier<CounterState> {
  CounterNotifier() : super(CounterState());

  void increase() => state = state.copyWith(count: state.value + 1);
  void decrease() => state = state.copyWith(count: state.value - 1);
  void read() => state.textList = state.loadListFromStorage() as List<String>;
  void add(String url) => state.textList = state.loadList(url) as List<String>;
}

/*
 CounterState copyWith({int? count}) {
    return CounterState(
      value: count ?? value,//returns the expression on its left when the it's not null
    );
  }
  CounterState read(List<String>? list) {
    return CounterState(
      textList: list ?? textList,
    );
      initializeTextStreamSubscription();
  }

 */