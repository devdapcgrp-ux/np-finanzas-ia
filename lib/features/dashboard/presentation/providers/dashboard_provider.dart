import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final dashboardDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final supabase = Supabase.instance.client;

  final familia = await supabase.from('familias').select().single();
  final usuarios = await supabase.from('usuarios').select();
  final cuentas = await supabase.from('cuentas').select();
  final tarjetas = await supabase.from('tarjetas').select();
  final categorias = await supabase.from('categorias').select();

  return {
    'familia': familia,
    'usuarios': usuarios,
    'cuentas': cuentas,
    'tarjetas': tarjetas,
    'categorias': categorias,
  };
});