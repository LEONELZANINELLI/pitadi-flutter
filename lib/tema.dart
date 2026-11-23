import 'package:material_ui/material_ui.dart';

abstract final class CoresApp {
  static const primario = Color(0xFFA34831);
  static const verde = Color(0xFF395746);
  static const fundo = Color(0xFFFBF8F4);
  static const superficie = Colors.white;
  static const texto = Color(0xFF2B302C);
  static const secundario = Color(0xFF626A62);
  static const borda = Color(0xFFE9E4DD);
  static const destaque = Color(0xFFF7E7DA);
}

ThemeData criarTema() {
  final esquema = ColorScheme.fromSeed(
    seedColor: CoresApp.primario,
    primary: CoresApp.primario,
    secondary: CoresApp.verde,
    surface: CoresApp.fundo,
    onSurface: CoresApp.texto,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: esquema,
    scaffoldBackgroundColor: CoresApp.fundo,
    appBarTheme: const AppBarTheme(
      backgroundColor: CoresApp.fundo,
      foregroundColor: CoresApp.texto,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: CoresApp.superficie,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: CoresApp.borda),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      height: 72,
      backgroundColor: CoresApp.superficie,
      indicatorColor: CoresApp.destaque,
    ),
  );
}
