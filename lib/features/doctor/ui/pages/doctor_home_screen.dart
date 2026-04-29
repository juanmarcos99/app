import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/auth/auth.dart';
import 'package:app/core/core.dart';
import '../bloc/doctor_bloc.dart';
import '../widgets/doctor_bottom_nav_bar.dart';
import 'scanner_page.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Disparamos la carga de pacientes al iniciar
    context.read<DoctorBloc>().add(LoadLinkedPatients());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _currentIndex == 1 ? null : _buildAppBar(context, theme, cs),
      body: _buildBody(),

      bottomNavigationBar: DoctorBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ThemeData theme,
    ColorScheme cs,
  ) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return AppBar(
      elevation: 0,
      backgroundColor: theme.scaffoldBackgroundColor,
      centerTitle: false,
      title: Text(
        "Pacientes",
        style: theme.textTheme.titleMedium?.copyWith(
          color: cs.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: cs.onSurface),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            String initial = 'D';
            if (state is UserLoggedIn) {
              initial = state.user.name.isNotEmpty
                  ? state.user.name[0].toUpperCase()
                  : 'D';
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.success,
                child: Text(
                  initial,
                  style: TextStyle(
                    color: cs.copyWith(onPrimary: AppColors.white).onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_currentIndex == 1) {
      return ScannerPage(
        onScanSuccess: () {
          setState(() {
            _currentIndex = 0;
            context.read<DoctorBloc>().add(LoadLinkedPatients());
          });
        },
      );
    }

    if (_currentIndex == 2) {
      return const Center(
        child: Text(
          'Sección Perfil en construcción',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<DoctorBloc, DoctorState>(
              builder: (context, state) {
                if (state is DoctorLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is DoctorError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  );
                }

                if (state is DoctorLoaded) {
                  if (state.patients.isEmpty) {
                    return const Center(
                      child: Text(
                        'No hay pacientes vinculados.\nEscanea un código QR para empezar.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: state.patients.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final patient = state.patients[index];
                      return _buildPatientCard(context, patient);
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard(BuildContext context, dynamic patient) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.surfaceContainerHighest, width: 1.0),
      ),
      child: Row(
        children: [
          // Avatar o Icono del Paciente
          CircleAvatar(
            backgroundColor: cs.primary.withOpacity(0.1),
            child: Icon(Icons.person, color: cs.primary, size: 20),
          ),
          const SizedBox(width: 16),
          // Nombre del Paciente
          Expanded(
            child: Text(
              '${patient.name} ${patient.lastName}',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          // Botón Ver
          FilledButton.tonal(
            onPressed: () {
              // Lógica para ver seguimiento
            },
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Ver', style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
  }
}
