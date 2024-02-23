import 'package:easy_localization/easy_localization.dart' hide
TextDirection;
import 'package:flutter/material.dart';
import 'package:homiee/l10n/locale_keys.g.dart';
import 'package:homiee/pages/date_time.dart';
import 'package:scoped_model/scoped_model.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../models/cart_model.dart';

class CartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CartPageState();
  }
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 60.0, right: 20.0, left: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap:(){Navigator.pop(context);},
                      child: Icon(
                    Icons.arrow_back_ios,
                    size: MediaQuery.sizeOf(context).width * 0.08,
                  )),
                  Text(
                    LocaleKeys.cartTitle.tr(),
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width*0.09,
                      color: Colors.grey.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ScopedModel.of<CartModel>(context, rebuildOnChange: true)
                              .cart
                              .length ==
                          0
                      ? Container(width: MediaQuery.sizeOf(context).width * 0.11,)
                      : GestureDetector(
                          onTap: () {
                            ScopedModel.of<CartModel>(context).clearCart();
                          },
                          child: Icon(Icons.delete_outlined,
                              size: MediaQuery.sizeOf(context).width * 0.11))
                ],
              ),
            ),
          )
        ];
      },
      body: ScopedModel.of<CartModel>(context, rebuildOnChange: true)
                  .cart
                  .length ==
              0
          ? Center(
              child: Text(LocaleKeys.noItemsCart.tr()),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Divider(height: 0, thickness: 1),
                  Expanded(
                    child: Container(
                        child: Column(children: <Widget>[
                      Expanded(
                        child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(
                            thickness: 0.7,
                            indent: 15,
                            endIndent: 15,
                          ),
                          itemCount: ScopedModel.of<CartModel>(context,
                                  rebuildOnChange: true)
                              .total,
                          itemBuilder: (context, index) {
                            return ScopedModelDescendant<CartModel>(
                              builder: (context, child, model) {
                                return ListTile(
                                  title: Text(context.locale.languageCode == 'en' ?
                                  model.cart[index].title:
                                    model.cart[index].titleAr,
                                    textDirection: context.locale.languageCode == 'en'? TextDirection.ltr:
                                    TextDirection.rtl,),
                                  subtitle: Text(
                                      "${model.cart[index].qty} x ${model.cart[index].price} = ${model.cart[index].qty *
                                                  model.cart[index].price}",
                                  textDirection: context.locale.languageCode == 'en'? TextDirection.ltr:
                                      TextDirection.ltr),
                                  trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () {
                                            model.updateProduct(
                                                model.cart[index],
                                                model.cart[index].qty + 1);
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () {
                                            model.updateProduct(
                                                model.cart[index],
                                                model.cart[index].qty - 1);
                                          },
                                        ),
                                      ]),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${LocaleKeys.total.tr()} ${ScopedModel.of<CartModel>(context, rebuildOnChange: true).totalCartValue.toInt()}",
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width *0.050, fontWeight: FontWeight.bold),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: ElevatedButton(
                          onPressed: () {
                            for (int i = 0; i <ScopedModel.of<CartModel>(context).cart.length; i++) {
                              setState(() {
                                Dservices.add("${ScopedModel.of<CartModel>(context).cart[i].title}_${ScopedModel.of<CartModel>(context).cart[i].qty}");
                                Dprices.add(ScopedModel.of<CartModel>(context).cart[i].price.toString());
                              });
                            }
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return const DateAndTime();
                            }));
                          },
                          child: Text(
                            LocaleKeys.selectTime.tr(),
                            style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width *0.053),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: FlutterFlowTheme.of(context).primary,
                              fixedSize: Size(
                                  MediaQuery.of(context).size.width * 0.85,
                                  MediaQuery.of(context).size.height * 0.065),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                    ])),
                  ),
                ],
              ),
            ),
    ));
  }
}
