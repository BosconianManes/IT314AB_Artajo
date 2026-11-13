import 'package:postgres/postgres.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DbConnection {
  static Connection? _connection;

  static Future<Connection> get connection async {
    if (_connection == null || !_connection!.isOpen) {
      print("🔄 Attempting to connect to Neon Database...");
      try {
        _connection = await Connection.open(
          Endpoint(
            host: dotenv.env['DB_HOST']!,
            database: dotenv.env['DB_NAME']!,
            username: dotenv.env['DB_USER']!,
            password: dotenv.env['DB_PASSWORD']!,
          ),
          settings: const ConnectionSettings(sslMode: SslMode.require),
        );
        print("✅ Connected inside DbConnection class!");
      } catch (e) {
        print("❌ ERROR inside DbConnection: $e");
        rethrow; // Pass the error up
      }
    }
    return _connection!;
  }

  static Future<bool> testConnection() async {
    try {
      final conn = await connection;
      print("🔍 Running test query SELECT 1...");
      await conn.execute('SELECT 1');
      print("✅ Test query successful!");
      return true;
    } catch (e) {
      print("❌ Test query failed: $e");
      return false;
    }
  }
}
