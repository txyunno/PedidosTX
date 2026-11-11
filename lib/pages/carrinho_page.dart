import 'package:flutter/material.dart';
import '../data/carrinho.dart';
import 'finalizar_page.dart';

class CarrinhoPage extends StatefulWidget {
  @override
  State<CarrinhoPage> createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {

  double get total{

    double soma=0;

    for(var item in carrinho){
      soma+=item.preco*item.quantidade;
    }

    return soma;
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(

      appBar: AppBar(
        title: Text("Carrinho"),
      ),

      body: Column(

        children: [

          Expanded(

            child: ListView.builder(

              itemCount: carrinho.length,

              itemBuilder:(context,index){

                final item=carrinho[index];

                return Card( //

                  child: ListTile(

                    leading: Icon(Icons.shopping_cart),

                    title: Text(item.nome),

                    subtitle: Text(
                        "${item.quantidade} x R\$ ${item.preco.toStringAsFixed(2)}"
                    ),

                    trailing: IconButton(

                      icon: Icon(Icons.delete),

                      onPressed:(){

                        setState((){

                          carrinho.removeAt(index);

                        });

                      },

                    ),

                  ),

                );

              },

            ),

          ),

          Text(
            "Total: R\$ ${total.toStringAsFixed(2)}",
            style: TextStyle(fontSize:22,fontWeight: FontWeight.bold),
          ),

          SizedBox(height:20),

          ElevatedButton(

            child: Text("Finalizar Compra"),

            onPressed:(){

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:(_)=>FinalizarPage(total: total),
                ),
              );

            },

          ),

          SizedBox(height:20),

        ],

      ),

    );

  }

}