import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/model/Conversa.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp/model/Usuario.dart';

class AbaConversas extends StatefulWidget {
  const AbaConversas({Key? key}) : super(key: key);

  @override
  _AbaConversasState createState() => _AbaConversasState();
}

class _AbaConversasState extends State<AbaConversas> {

  List<Conversa> _listaConversas = [];
  final _controller = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;
  String? _idUsuarioLogado;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarDadosUsuario();
    Conversa conversa = Conversa();
    conversa.nome = "Weslley";
    conversa.mensagem = "Olá, tudo bem?";
    conversa.caminhoFoto = "https://firebasestorage.googleapis.com/v0/b/whatsapp-45847.appspot.com/o/perfil%2Fperfil4.jpg?";

    _listaConversas.add(conversa);

  }

  Stream<QuerySnapshot> _adicionarListenerConversas(){

    final stream = db.collection("conversa")
        .doc(_idUsuarioLogado)
        .collection("ultima_conversa")
        .snapshots();
    stream.listen((dados) {
      _controller.add(dados);
    });
    return stream;
  }

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;
    _idUsuarioLogado = usuarioLogado!.uid;

    _adicionarListenerConversas();

  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.close();
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(

      stream: _controller.stream,
      builder: (context, snapshot){
          switch (snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
            return Center(
              child: Column(
                children: <Widget>[
                  Text("Carregando conversas"),
                  CircularProgressIndicator()
                ],
              ),
            );
            break;
            case ConnectionState.active:
            case ConnectionState.done:
            if (snapshot.hasError) {
              return Text("Erro ao carregar os dados!");
            }else{
              QuerySnapshot? querySnapshot = snapshot.data;
              if(querySnapshot!.docs.length == 0){
                  return Center(
                    child: Text(
                      "Você não tem nenhuma mensagem ainda",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  );
              }
              return ListView.builder(
                  itemCount: _listaConversas.length,
                  itemBuilder: (context, indece){

                    List<DocumentSnapshot> conversa = querySnapshot.docs.toList();
                    DocumentSnapshot item = conversa[indece];

                    String urlImagem = item["caminhoFoto"] ?? 'defalt' ;
                    String tipo = item["tipoMensagem"];
                    String mensagem = item["mensagem"];
                    String nome = item["nome"];
                    String idDestinatario = item["idDestinatario"];

                    Usuario usuario = Usuario();
                    usuario.nome = nome;
                    usuario.urlImagem = urlImagem;
                    usuario.idUsuario = idDestinatario;

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
                        backgroundImage: urlImagem != null
                            ? NetworkImage(urlImagem)
                            :null,
                      ),
                      title: Text(
                        nome,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),
                      ),
                      subtitle: Text(
                          tipo == "texto"
                              ? mensagem
                              : "Imagem...",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14
                          )
                      ),
                    );

                  }
              );
            }
          }
      },

    );


  }
}
