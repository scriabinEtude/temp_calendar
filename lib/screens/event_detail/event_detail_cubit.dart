import 'package:calendar01/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calendar01/screens/event_detail/event_detail_state.dart';

class EventDetailCubit extends Cubit<EventDetailState> {
  EventDetailCubit()
      : super(EventDetailState(
            isLoading: true,
            reservationTime: DateTime.now(),
            name: '쿠키',
            requestType: RequestType.healthScreenings,
            breeds: '아비시니안',
            age: 8,
            sex: 1,
            doesNeutering: true,
            weight: 5.5,
            guardian: '김다희',
            phone: '010-2004-3942',
            description: '잇몸이 빨갛고 좀 부어보이는데 스케일링 언제쯤 하면 좋을지 치아 어금니랑 꼼꼼히 봐주세요.',
            veterinarian: '김석현',
            reservationNumber: 21070123,
            createdAt: DateTime.now()));

  Future<void> loadInitialData() async {
    final stableState = state;
    try {
      emit(state.copyWith(isLoading: true));

      // TODO your code here

      emit(state.copyWith(isLoading: false));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
      emit(stableState.copyWith(isLoading: false));
    }
  }
}
