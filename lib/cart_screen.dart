import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_model.dart';
import 'cart_provider.dart';
import 'db_helper.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper dbHelper = DBHelper();
  @override


  Widget build(BuildContext context) {
    final cort  = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart List'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: (){
              //  Navigator.push(context,MaterialPageRoute(builder: (context) => CartScreen()));
            },
            child: Center(
              child: Badge(
                showBadge: true,
                badgeContent: Consumer<CartProvider>(
                  builder: (context, value , child){
                    return Text(value.getCounter().toString(),style: TextStyle(color: Colors.white));
                  },
                ),
                animationType: BadgeAnimationType.fade,
                animationDuration: Duration(milliseconds: 300),
                child: Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),

          SizedBox(width: 20.0)
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: cort.getData(),
              builder: (context, AsyncSnapshot<List<Cart>> snapshot){
                if(snapshot.hasData){


                  return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index){
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Image(
                                          height: 100,
                                          width: 100,
                                          image: AssetImage(snapshot.data![index].image.toString()),
                                        ),
                                        SizedBox(width: 10,),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(snapshot.data![index].productName.toString(),
                                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                                  ),
                                                  IconButton(onPressed: (){
                                                    dbHelper!.delete(snapshot.data![index].id!);
                                                    cort.removeCounter();
                                                    cort.removeTotalPrice(double.parse(snapshot.data![index].initialPrice.toString()));
                                                  }, icon: Icon(Icons.delete))

                                                ],
                                              ),

                                              SizedBox(height: 5,),
                                              Text(snapshot.data![index].unitTag.toString() +" "+r"$"+ snapshot.data![index].initialPrice.toString() ,
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                              ),
                                              SizedBox(height: 5,),
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: InkWell(

                                                  child:  Container(
                                                    height: 35,
                                                    width: 130,
                                                    decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius: BorderRadius.circular(5)
                                                    ),
                                                    child:  Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          IconButton(onPressed: (){
                                                            int quantity = snapshot.data![index].quantity!;
                                                            int price = snapshot.data![index].initialPrice!;
                                                            quantity++;
                                                            int? newPrice = quantity * price;
                                                            dbHelper!.updateQuantity(Cart(
                                                                id:  snapshot.data![index].id!,
                                                                productId:  snapshot.data![index].id!.toString(),
                                                                productName:  snapshot.data![index].productName!,
                                                                initialPrice:  snapshot.data![index].initialPrice!,
                                                                productPrice: newPrice,
                                                                quantity: quantity,
                                                                unitTag: snapshot.data![index].unitTag.toString(),
                                                                image: snapshot.data![index].image.toString())
                                                            ).then((value) {

                                                              newPrice =0;
                                                              quantity= 0;
                                                              cort.addTotalPrice(double.parse( snapshot.data![index].initialPrice!.toString()));
                                                            }).onError((error, stackTrace) {
                                                              print(error.toString());
                                                            });
                                                          }, icon: Icon(Icons.add, color: Colors.white,)),
                                                          Text( snapshot.data![index].quantity.toString(), style: TextStyle(color: Colors.white),),
                                                          IconButton(onPressed: (){
                                                            int quantity = snapshot.data![index].quantity!;
                                                            int price = snapshot.data![index].productPrice!;
                                                            quantity--;
                                                            if(quantity <= 0){
                                                              final snackBar = const SnackBar(backgroundColor: Colors.red,
                                                                content: Text('Bus ker na sale, Or kitna kam karega'),
                                                                duration: Duration(seconds: 1),);
                                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                              dbHelper!.delete(snapshot.data![index].id!);
                                                              cort.removeCounter();
                                                              cort.removeTotalPrice(double.parse(snapshot.data![index].productPrice.toString()));

                                                            }else{
                                                              int? newPrice = quantity * price;
                                                              dbHelper!.updateQuantity(Cart(
                                                                  id:  snapshot.data![index].id!,
                                                                  productId:  snapshot.data![index].id!.toString(),
                                                                  productName:  snapshot.data![index].productName!,
                                                                  initialPrice:  snapshot.data![index].initialPrice!,
                                                                  productPrice: newPrice,
                                                                  quantity: quantity,
                                                                  unitTag: snapshot.data![index].unitTag.toString(),
                                                                  image: snapshot.data![index].image.toString())
                                                              ).then((value) {

                                                                newPrice =0;
                                                                quantity= 0;
                                                                cort.removeTotalPrice(double.parse( snapshot.data![index].initialPrice!.toString()));
                                                              }).onError((error, stackTrace) {
                                                                print(error.toString());
                                                              });
                                                            }

                                                          }, icon: Icon(Icons.remove, color: Colors.white,)),

                                                        ],

                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )

                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          }), );
                }
                return Text('Nothing');
              }),
          Consumer<CartProvider>(builder: (context, value, child) {
            return Visibility(
              visible: value.getTotalPrice().toStringAsFixed(2) == '0.00' ? false : true,
              child: Column(
              children: [
                ReUsable(value: r'$' + value.getTotalPrice().toStringAsFixed(2), title: 'Sub total'),
                ReUsable(value: r'$' + value.getTotalPrice().toStringAsFixed(2), title: 'Total total')

              ],
              ),
            );
    }),
        ],
      ),
    );
  }
}



class ReUsable extends StatelessWidget {
  final String title, value;
  const ReUsable({Key? key, required this.value, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(value),
        ],
      ),
    );
  }
}
