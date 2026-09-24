import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  Database? _database;

  // Getter per ottenere il database sempre pronto
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await inizializzaDB();
    return _database!;
  }

  // Creazione del database e della tabella
  Future<Database> inizializzaDB() async {
    String percorsoCartella = await getDatabasesPath();
    String camminoCompleto = join(percorsoCartella, 'spesa.db');

    return await openDatabase(
      camminoCompleto,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE listaSpesa (
            idAlimento INTEGER PRIMARY KEY AUTOINCREMENT, 
            nomeAlimento TEXT, 
            statoAlimento INTEGER
          )
        ''');
      },
    );
  }

  // INSERIMENTO: Aggiunge un prodotto (di base con stato 0 = da comprare)
  Future<void> inserisciProdotto(String nome) async {
    final db = await database;
    Map<String, dynamic> riga = {
      'nomeAlimento': nome,
      'statoAlimento': 0, 
    };
    await db.insert('listaSpesa', riga);
  }

  // LETTURA: Ritorna la lista di mappe con tutte le colonne (ID, Nome, Stato)
  Future<List<Map<String, dynamic>>> ottieniLista() async {
    final db = await database;
    return await db.query('listaSpesa');
  }

  // AGGIORNAMENTO: Modifica lo stato dell'alimento (0 o 1) basandosi sull'ID
  Future<void> aggiornaStato(int id, int nuovoStato) async {
    final db = await database;
    await db.update(
      'listaSpesa',
      {'statoAlimento': nuovoStato},
      where: 'idAlimento = ?',
      whereArgs: [id],
    );
  }

  // CANCELLAZIONE: Elimina un prodotto tramite il suo ID univoco
  Future<void> cancellaProdotto(int id) async {
    final db = await database;
    await db.delete(
      'listaSpesa',
      where: 'idAlimento = ?',
      whereArgs: [id],
    );
  }
}