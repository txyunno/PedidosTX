import 'package:flutter/material.dart';

class FinalizarPage extends StatefulWidget {

  final double total;

  FinalizarPage({required this.total});

  @override
  State<FinalizarPage> createState()=>_FinalizarPageState();

}

class _FinalizarPageState extends State<FinalizarPage>{

  final controller=TextEditingController();

  late double totalFinal;

  bool desconto=false;

  @override
  void initState(){

    super.initState();

    totalFinal=widget.total;

  }

  void aplicarCupom(){

    if(controller.text=="DESCONTO10" && !desconto){

      setState((){

        totalFinal*=0.9;

        desconto=true;

      });

    }

  }

  @override
  Widget build(BuildContext context){

    return Scaffold(

      appBar: AppBar(
        title: Text("Pagamento"),
      ),

      body: Padding(

        padding: EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(

              controller: controller,

              decoration: InputDecoration(

                labelText:"Cupom",

              ),

            ),

            SizedBox(height:20),

            ElevatedButton(

              onPressed: aplicarCupom,

              child: Text("Aplicar Cupom"),

            ),

            SizedBox(height:30),

            Text(

              "Valor Final",

              style: TextStyle(fontSize:20),

            ),

            Text(

              "R\$ ${totalFinal.toStringAsFixed(2)}",

              style: TextStyle(
                fontSize:32,
                fontWeight: FontWeight.bold,
              ),

            ),

            Spacer(),

            ElevatedButton(

              child: Text("Comprar"),

              onPressed:(){

                showDialog(

                  context: context,

                  builder:(_){

                    return AlertDialog(

                      title: Text("Pedido realizado"),

                      content: Text("Obrigado pela compra!"),

                      actions: [

                        TextButton(

                          onPressed:(){

                            Navigator.popUntil(context,(route)=>route.isFirst);

                          },

                          child: Text("OK"),

                        )

                      ],

                    );

                  },

                );

              },

            ),

          ],

        ),

      ),

    );

  }

}