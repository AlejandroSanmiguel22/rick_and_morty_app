part of 'search_locations_cubit.dart';

abstract class SearchLocationsState extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchLocationsInitial extends SearchLocationsState {}

class SearchLocationsLoading extends SearchLocationsState {}

class SearchLocationsLoaded extends SearchLocationsState {
  final List<LocationEntity> locations;
  SearchLocationsLoaded(this.locations);

  @override
  List<Object> get props => [locations];
}

class SearchLocationsEmpty extends SearchLocationsState {}

class SearchLocationsError extends SearchLocationsState {
  final String message;
  SearchLocationsError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchLocationsSuggested extends SearchLocationsState {
  final List<LocationEntity> suggestions;
  SearchLocationsSuggested(this.suggestions);

  @override
  List<Object> get props => [suggestions];
}
