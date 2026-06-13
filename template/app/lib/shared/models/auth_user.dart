import 'package:equatable/equatable.dart';

/// The authenticated user as the application sees it. Keeps backend types
/// (e.g. supabase's `User`) behind the repository boundary.
class SharedModel_AuthUser extends Equatable {
  const SharedModel_AuthUser({required this.id, required this.email});

  final String id;
  final String? email;

  @override
  List<Object?> get props => [id, email];
}
