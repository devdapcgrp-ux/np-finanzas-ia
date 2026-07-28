import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:np_finanzas_ia/features/dashboard/presentation/providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardDataProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('N|P Finanzas IA'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: dashboardAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error al cargar datos:\n$error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ),
        data: (data) {
          final familia = data['familia'] as Map<String, dynamic>;
          final usuarios = data['usuarios'] as List<dynamic>;
          final cuentas = data['cuentas'] as List<dynamic>;
          final tarjetas = data['tarjetas'] as List<dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Saludo
                Text(
                  'Hola, ${familia['nombre']}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Moneda: ${familia['moneda']}',
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),

                // Usuarios
                _SectionTitle(title: 'Integrantes', icon: Icons.people),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: usuarios.map((u) {
                    return Chip(
                      avatar: Icon(
                        u['rol'] == 'Administrador' ? Icons.admin_panel_settings : Icons.person,
                        size: 18,
                      ),
                      label: Text('${u['nombre']} (${u['rol']})'),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Cuentas
                _SectionTitle(title: 'Cuentas', icon: Icons.account_balance_wallet),
                const SizedBox(height: 8),
                ...cuentas.map((c) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.account_balance),
                      title: Text(c['nombre']),
                      subtitle: Text(c['tipo']),
                      trailing: Text(
                        '\$${c['saldo_actual']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 24),

                // Tarjetas
                _SectionTitle(title: 'Tarjetas', icon: Icons.credit_card),
                const SizedBox(height: 8),
                ...tarjetas.map((t) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.credit_card),
                      title: Text(t['nombre']),
                      subtitle: Text('Cierre: ${t['cierre']} - Vence: ${t['vencimiento']}'),
                      trailing: Text(
                        'Límite: \$${t['limite']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 32),

                // Botón principal
                Center(
                  child: FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.mic),
                    label: const Text('Hablar para registrar'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Movimientos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card_outlined),
            label: 'Tarjetas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights_outlined),
            label: 'Análisis',
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}