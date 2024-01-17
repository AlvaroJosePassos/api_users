import 'package:flutter/material.dart';
import 'Usuario.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<Usuario>> _buscaUsuarios() async {
    var url = Uri.parse('https://jsonplaceholder.typicode.com/users');
    http.Response response;

    response = await http.get(url);

    print('Resposta' + response.statusCode.toString());
    print('Resposta' + response.body);

    if (response.statusCode == 200) {
      List retorno = json.decode(response.body);
      print('retornou*******');
      return retorno.map((e) => Usuario.fromJson(e)).toList();
    } else {
      throw Exception('ERROOO');
    }
  }

  late Future<List<Usuario>> usuarios;

  @override
  void initState() {
    super.initState();
    usuarios = _buscaUsuarios();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Usuarios'),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder(
            future: usuarios,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    Usuario usuario = snapshot.data![index];
                    return ListTile(
                      leading: Icon(Icons.web),
                      title: Text(usuario.name!),
                      subtitle: Text(usuario.website!),
                      style: ListTileStyle.drawer,
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return CircularProgressIndicator();
            }),
      ),
    );
  }
}
