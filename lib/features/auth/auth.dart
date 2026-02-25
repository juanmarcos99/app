export 'package:app/app_routes.dart';
export 'package:app/features/auth/auth_injection.dart';

//data
export 'package:app/features/auth/data/datasources/user_local_data_source.dart';
export 'package:app/features/auth/data/datasources/patient_local_data_sources.dart';
export 'package:app/features/auth/data/datasources/remember_local_datasource.dart';
export 'package:app/features/auth/data/repositories_impl/user_repository_impl.dart';
export 'package:app/features/auth/data/repositories_impl/remember_repository_impl.dart';
export 'package:app/features/auth/data/models/user_model.dart';
export 'package:app/features/auth/data/models/patient_model.dart';

//domain
export 'package:app/features/auth/domain/entities/user.dart';
export 'package:app/features/auth/domain/entities/patient.dart';
export 'package:app/features/auth/domain/repositories/user_repository.dart';
export 'package:app/features/auth/domain/repositories/patient_repository.dart';
export 'package:app/features/auth/domain/repositories/remember_repository.dart';
export 'package:app/features/auth/domain/use_cases/register_user.dart';
export 'package:app/features/auth/domain/use_cases/register_patient.dart';
export 'package:app/features/auth/domain/use_cases/login_user.dart';
export 'package:app/features/auth/domain/use_cases/change_password.dart';
export 'package:app/features/auth/domain/use_cases/remember/clear_remembered_users.dart';
export 'package:app/features/auth/domain/use_cases/remember/save_user.dart';
export 'package:app/features/auth/domain/use_cases/remember/delete_user.dart';
export 'package:app/features/auth/domain/use_cases/remember/get_password.dart';
export 'package:app/features/auth/domain/use_cases/remember/get_remembered_users.dart';
export 'package:app/features/auth/domain/use_cases/remember/save_password.dart';

//ui
export 'package:app/features/auth/ui/bloc/auth_bloc.dart';
export 'package:app/features/auth/ui/bloc/auth_event.dart';
export 'package:app/features/auth/ui/bloc/auth_state.dart';
export 'package:app/features/auth/ui/pages/registro/register_screen.dart';
export 'package:app/features/auth/ui/pages/login/login_screen.dart';
export 'package:app/features/auth/ui/pages/change_password/change_password_screen.dart';
export 'package:app/features/auth/ui/pages/widgets/custom_text_field.dart';
export 'package:app/features/auth/ui/pages/widgets/button.dart';
export 'package:app/features/auth/ui/pages/login/widgets/letter_nav_buttom.dart';
