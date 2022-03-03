import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/Usuario.dart';

class AbaContatos extends StatefulWidget {
  const AbaContatos({Key? key}) : super(key: key);

  @override
  _AbaContatosState createState() => _AbaContatosState();
}

class _AbaContatosState extends State<AbaContatos> {

  String? _idUsuarioLogado;
  String? _emailUsuarioLogado;

  Future<List<Usuario>> _recuperarContatos() async {

    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await db.collection("usuarios").get();

    List<Usuario> listaUsuarios = [];

    for (DocumentSnapshot item in querySnapshot.docs) {

      Map dadosmap = {};
      var dados = item.data();
      dadosmap = dados as Map;

      Usuario usuario = Usuario();
      if (dados["email"] == _emailUsuarioLogado) continue;
      usuario.idUsuario = item.id;
      usuario.email = dados["email"];
      usuario.nome = dados["nome"];
      usuario.urlImagem = dados["urlImagem"]??'defalt';

      listaUsuarios.add(usuario);
    }
    return listaUsuarios;

  }

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    var usuariologado = FirebaseAuth.instance.currentUser;
    _idUsuarioLogado = usuariologado!.uid;
    _emailUsuarioLogado = usuariologado.email;

  }

  @override
  void initState() {
    _recuperarDadosUsuario();
    _recuperarContatos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Usuario>>(
      future: _recuperarContatos(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: [
                  Text("Carregando contatos"),
                  CircularProgressIndicator()
                ],
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (_, indice) {
                  List<Usuario> listaItens = snapshot.data!;
                  Usuario usuario = listaItens[indice];
                  return ListTile(
                    onTap: (){
                      Navigator.pushNamed(
                          context,
                          "/mensagens",
                        arguments: usuario
                      );
                    },
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    leading: CircleAvatar(
                      maxRadius: 30,
                      backgroundColor: Colors.grey,
                      //backgroundImage: NetworkImage(usuario.urlImagem),
                        backgroundImage: (usuario.urlImagem == null)
                            ? AssetImage('images/user-avatar.png')
                            : NetworkImage(usuario.urlImagem) as ImageProvider,
                    ),
                    title: Text(
                      usuario.nome,
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  );
                });
            break;
        }
        return Container();
      },
    );
  }
}