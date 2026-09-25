import 'dart:convert';
import 'package:http/http.dart' as http;

class DatabaseHelper {
  // L'URL del tuo backend pubblicata su Render
  static const String baseUrl = 'https://spesa-6ekz.onrender.com/api/alimenti';

  // INSERIMENTO: Aggiunge un prodotto inviando una richiesta POST al server
  Future<void> inserisciProdotto(String nome) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nomeAlimento': nome, 'statoAlimento': 0}),
      );

      if (response.statusCode != 201) {
        print('Errore durante l\'inserimento: ${response.body}');
      }
    } catch (e) {
      print('Errore di connessione durante inserisciProdotto: $e');
    }
  }

  // LETTURA: Richiede la lista completa al server tramite GET
  Future<List<Map<String, dynamic>>> ottieniLista() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        print('Errore lettura lista: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Errore di connessione durante ottieniLista: $e');
      return [];
    }
  }

  // AGGIORNAMENTO: Modifica lo stato dell'alimento tramite PUT al server
  Future<void> aggiornaStato(int id, int nuovoStato) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'statoAlimento': nuovoStato}),
      );

      if (response.statusCode != 200) {
        print('Errore durante l\'aggiornamento dello stato: ${response.body}');
      }
    } catch (e) {
      print('Errore di connessione durante aggiornaStato: $e');
    }
  }

  // CANCELLAZIONE: Elimina un prodotto inviando una richiesta DELETE al server
  Future<void> cancellaProdotto(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode != 200) {
        print('Errore durante la cancellazione: ${response.body}');
      }
    } catch (e) {
      print('Errore di connessione durante cancellaProdotto: $e');
    }
  }
}
