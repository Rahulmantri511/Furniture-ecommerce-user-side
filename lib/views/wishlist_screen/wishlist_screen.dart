import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../../consts/consts.dart';
import '../../services/firestore_services.dart';
import '../../widgets_common/loading_indicator.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: redColor.withOpacity(0.5)),
        title: "My Wishlist".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
          stream: FirestoreServices.getWishlists(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if(!snapshot.hasData){
              return Center(child: loadingIndicator(),);
            }else if(snapshot.data!.docs.isEmpty){
              return Column(
                children: [
                  150.heightBox,
                  "Wishlist is empty".text.size(16).fontFamily(semibold).make(),
                  10.heightBox,
                  "Start adding by tapping on heart \n     when you like something!".text.color(fontGrey).make(),
                  10.heightBox,
                  Center(child: Image.asset("assets/images/wishlist.jpg")),

                ],
              );

            }else{
              var data = snapshot.data!.docs;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context,int index){
                        return ListTile(
                          leading: SizedBox(
                            width: 80,
                              height: 80,
                              child: Image.network('${data[index]['p_imgs'][0]}',width: 80,fit: BoxFit.cover,)
                          ).box.roundedSM.clip(Clip.antiAlias).make(),
                          title: "${data[index]['p_name']} "
                              .text
                              .fontFamily(semibold)
                              .size(16)
                              .make(),
                          subtitle: "${data[index]['p_price']}"
                              .numCurrency
                              .text
                              .size(14)
                              .color(redColor)
                              .fontFamily(semibold)
                              .make(),
                          trailing: const Icon(
                              Icons.favorite,
                              color: redColor
                          ).onTap(() async{
                            await firestore
                                .collection(productsCollection)
                                .doc(data[index].id)
                                .set({
                              'p_wishlist': FieldValue.arrayRemove([currentUser!.uid])
                            },SetOptions(merge: true));
                          }
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          }

      ),
    );
  }
}