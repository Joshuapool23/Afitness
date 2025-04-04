import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  static var instance;

  
  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    _database = await openDatabase(
      join(await getDatabasesPath(), 'shopc_database.db'),
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE cart(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            product_name TEXT, 
            price REAL, 
            quantity INTEGER
          )
        ''');

        db.execute('''
          CREATE TABLE orders(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            product_name TEXT, 
            price REAL, 
            quantity INTEGER,
            date TEXT
          )
        ''');
      },
      version: 1,
    );

    return _database!;
  }

  // Get all cart items
  static Future<List<Map<String, dynamic>>> getCartItems() async {
    final db = await getDatabase();
    return await db.query('cart');
  }

  // Move cart items to orders
  static Future<void> moveCartToOrders() async {
    final db = await getDatabase();
    List<Map<String, dynamic>> cartItems = await getCartItems();

    for (var item in cartItems) {
      await db.insert('orders', {
        'product_name': item['product_name'],
        'price': item['price'],
        'quantity': item['quantity'],
        'date': DateTime.now().toString(),
      });
    }

    // Clear the cart after moving items
    await db.delete('cart');
  }
}
