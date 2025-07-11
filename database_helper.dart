import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Future<Database> _db() async {
    return openDatabase(
      join(await getDatabasesPath(), 'esmuss.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE medicines(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT, expiry TEXT, qr TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<void> insertMedicine(Map<String, dynamic> medicine) async {
    final db = await _db();
    await db.insert('medicines', medicine, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getMedicines() async {
    final db = await _db();
    return db.query('medicines');
  }

  static Future<Map<String, dynamic>?> getMedicineByQr(String qrCode) async {
    final db = await _db();
    final List<Map<String, dynamic>> result =
        await db.query('medicines', where: 'qr = ?', whereArgs: [qrCode]);
    return result.isNotEmpty ? result.first : null;
  }
}
