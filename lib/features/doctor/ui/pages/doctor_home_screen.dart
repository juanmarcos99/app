import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/auth/auth.dart';
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
      appBar: _buildAppBar(context, theme, cs),
      body: _buildBody(),
      
      // Botón Flotante para Escaneo de QR
      // Solo se muestra en la pestaña principal (Pacientes)
      floatingActionButton: _currentIndex == 0 
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScannerPage()),
                );
              },
              backgroundColor: cs.primaryContainer,
              child: Icon(
                Icons.qr_code_scanner, 
                color: cs.onPrimaryContainer,
              ),
            )
          : null,

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

  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeData theme, ColorScheme cs) {
    return AppBar(
      elevation: 0,
      backgroundColor: theme.scaffoldBackgroundColor,
      centerTitle: false,
      title: const Text(
        "DOCTOR",
        style: TextStyle(
          fontFamily: 'Manrope',
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
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
                backgroundColor: cs.surfaceContainerHighest,
                child: Text(
                  initial,
                  style: TextStyle(
                    color: cs.onSurface,
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
    // Si no estamos en la pestaña de "Pacientes", mostramos construcción
    if (_currentIndex != 0) {
      return const Center(
        child: Text(
          'Sección en construcción',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          const SizedBox(height: 16),
          _buildSearchBar(),
          const SizedBox(height: 24),
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
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: cs.onSurfaceVariant.withOpacity(0.1),
        ),
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
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
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
            child: const Text('Ver'),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: cs.onSurfaceVariant.withOpacity(0.1),
        ),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Buscar paciente por nombre o ID",
          hintStyle: TextStyle(color: cs.onSurfaceVariant.withOpacity(0.6)),
          prefixIcon: Icon(Icons.search, color: cs.primary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }
}