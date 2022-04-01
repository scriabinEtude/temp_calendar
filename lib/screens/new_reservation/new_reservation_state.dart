class NewReservationState {
	final bool isLoading;
	final String? error;
	  
	const NewReservationState({
		this.isLoading = false,
		this.error,
	});
	  
	NewReservationState copyWith({
		bool? isLoading,
		String? error,
	}) {
		return NewReservationState(
			isLoading: isLoading ?? this.isLoading,
			error: error ?? this.error,
		);
	}
}
