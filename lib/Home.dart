import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/Login.dart';
import 'package:whatsapp/telas/AbaContatos.dart';
import 'package:whatsapp/telas/AbaConversas.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{

  late TabController _tabController;

  List<String> itensMenu = [
    "Configurações", "Deslogar"
  ];

  Future _verificarUsuarioLogado() async{

    FirebaseAuth auth = FirebaseAuth.instance;

    User usuarioLogado = await auth.currentUser!;
    if(usuarioLogado == null){
      Navigator.pushReplacementNamed(context, "/login");

    }

  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verificarUsuarioLogado();
    _tabController = TabController(
        length: 2,
        vsync: this
    );
  }

  _escolhaMenuItem(String itemEscolhido){

    switch(itemEscolhido){
      case "Configurações":
        Navigator.pushNamed(context, "/configuracoes");
        break;
      case "Deslogar":
        _deslogarUsuario();
        break;
    }

  //print("item escolhido: " +itemEscolhido);

  }

  _deslogarUsuario() async{

    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushReplacementNamed(context, "/login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WathsApp"),
        bottom: TabBar(
          indicatorWeight: 4,
          labelStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: <Widget>[
            Tab(text: "Conversas",),
            Tab(text: "Contatos",)
          ],
        ),
        //Cria os itens de opções(3 pontinhos lado superior direito)
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context){
              return itensMenu.map((String item){
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      // Cria as abadas Conversas e Contatos
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          AbaConversas(),
          AbaContatos(),
        ],
      ),

    );
  }
}
