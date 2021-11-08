import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);
}


class RecipeNotFoundFailure extends Failure{
  const RecipeNotFoundFailure(String message) : super(message);
  @override
  List<Object?> get props => [message];
}


class NoInternetFailure extends Failure{
  const NoInternetFailure(String message) : super(message);
  @override
  List<Object?> get props => [message];
}