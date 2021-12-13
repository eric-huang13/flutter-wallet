import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);
}

class RecipeNotFoundFailure extends Failure {
  const RecipeNotFoundFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class CookBookNotFoundFailure extends Failure {
  const CookBookNotFoundFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class NoInternetFailure extends Failure {
  const NoInternetFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class WalletCreationFailure extends Failure {
  const WalletCreationFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class WalletCreationFailure extends Failure {
  const WalletCreationFailure(String message) : super(message);
  @override
  List<Object?> get props => [message];
}

class ExecutionNotFoundFailure extends Failure {
  const ExecutionNotFoundFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class FaucetServerFailure extends Failure {
  const FaucetServerFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class ItemNotFoundFailure extends Failure {
  const ItemNotFoundFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class TradeNotFoundFailure extends Failure {
  const TradeNotFoundFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class UsernameAddressFoundFailure extends Failure {
  const UsernameAddressFoundFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}

class InvalidInputFailure extends Failure {
  const InvalidInputFailure(String message) : super(message);

  @override
  List<Object?> get props => [message];
}
