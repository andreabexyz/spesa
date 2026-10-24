import 'dart:async';

import 'package:flutter/material.dart';
import 'database_helper.dart'; // Importiamo il gestore del database

void main() {
  runApp(const SpesaApp());
}

class SpesaApp extends StatelessWidget {
  const SpesaApp({super.key, this.databaseHelper});

  final DatabaseHelper? databaseHelper;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista Spesa',
      theme: ThemeData(primarySwatch: Colors.green),
      home: SchermataSpesa(databaseHelper: databaseHelper),
    );
  }
}

class SchermataSpesa extends StatefulWidget {
  const SchermataSpesa({super.key, this.databaseHelper});

  final DatabaseHelper? databaseHelper;

  @override
  State<SchermataSpesa> createState() => _SchermataSpesaState();
}

class _SchermataSpesaState extends State<SchermataSpesa> {
  final TextEditingController _controller = TextEditingController();
  late final DatabaseHelper _dbHelper;
  late final Timer _timerAnimazione;
  int _intervalliAnimazione = 0;
  bool _backendPronto = false;

  // Lista di mappe per contenere i dati del database (idAlimento, nomeAlimento, statoAlimento)
  List<Map<String, dynamic>> elementiSpesa = [];

  @override
  void initState() {
    super.initState();
    _dbHelper = widget.databaseHelper ?? DatabaseHelper();
    _timerAnimazione = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted && !_backendPronto) {
        _intervalliAnimazione++;
        setState(() {});
      }
    });
    _avviaApp();
  }

  Future<void> _avviaApp() async {
    final attesaMinima = Future<void>.delayed(const Duration(seconds: 3));
    final dati = await _attendiBackend();
    await attesaMinima;

    if (!mounted || dati == null) return;
    setState(() {
      elementiSpesa = dati;
      _backendPronto = true;
    });
    _timerAnimazione.cancel();
  }

  Future<List<Map<String, dynamic>>?> _attendiBackend() async {
    while (mounted) {
      final dati = await _dbHelper.provaBackend();
      if (dati != null) return dati;
      await Future<void>.delayed(const Duration(seconds: 2));
    }
    return null;
  }

  // Funzione per leggere i dati dal DB e aggiornare lo schermo
  Future<void> _caricaDati() async {
    List<Map<String, dynamic>> datiDalDb = await _dbHelper.ottieniLista();
    if (!mounted) return;
    setState(() {
      elementiSpesa = datiDalDb;
    });
  }

  @override
  void dispose() {
    _timerAnimazione.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_backendPronto) {
      const sequenza = ['0.jpg', '1.jpg', '2.jpg', '3.jpg'];
      final immagine = _intervalliAnimazione < 6
          ? '3.jpg'
          : sequenza[(_intervalliAnimazione - 6) % sequenza.length];

      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image.asset(
            'assets/icons/$immagine',
            fit: BoxFit.contain,
            width: MediaQuery.sizeOf(context).width * 0.8,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Lista Spesa')),
      body: Column(
        children: [
          // 1. Lista dei prodotti
          Expanded(
            child: ListView.builder(
              itemCount: elementiSpesa.length,
              itemBuilder: (context, index) {
                // Controlliamo se l'alimento corrente è segnato come comprato (stato == 1)
                bool esComprato = elementiSpesa[index]['statoAlimento'] == 1;

                return ListTile(
                  // Checkbox a sinistra per cambiare lo stato dell'alimento
                  leading: Checkbox(
                    value: esComprato,
                    onChanged: (bool? nuovoValore) async {
                      int id = elementiSpesa[index]['idAlimento'];
                      // Se era 1 diventa 0, se era 0 diventa 1
                      int nuovoStato = esComprato ? 0 : 1;

                      // Aggiorna nel DB e rinfresca l'interfaccia
                      await _dbHelper.aggiornaStato(id, nuovoStato);
                      _caricaDati();
                    },
                  ),
                  // Il testo cambia colore e si barra se l'alimento è comprato
                  title: Text(
                    elementiSpesa[index]['nomeAlimento'],
                    style: TextStyle(
                      color: esComprato ? Colors.grey : Colors.black,
                      decoration: esComprato
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      // Recuperiamo l'ID e cancelliamo l'elemento
                      int id = elementiSpesa[index]['idAlimento'];
                      await _dbHelper.cancellaProdotto(id);
                      _caricaDati(); // Rinfresca lo schermo
                    },
                  ),
                );
              },
            ),
          ),
          // 2. Barra di inserimento in basso
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Aggiungi un prodotto...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add_circle,
                    color: Colors.green,
                    size: 40,
                  ),
                  onPressed: () async {
                    String testoPulito = _controller.text.trim();
                    if (testoPulito.isNotEmpty) {
                      await _dbHelper.inserisciProdotto(
                        testoPulito,
                      ); // Salva nel DB
                      _caricaDati(); // Rinfresca lo schermo
                      _controller.clear(); // Svuota il campo di testo
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
