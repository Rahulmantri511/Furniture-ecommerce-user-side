import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../consts/consts.dart';
import '../../services/firestore_services.dart';
import '../../widgets_common/loading_indicator.dart';
import 'orders_details.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  // Function to send a notification to the seller when an order is placed
  void sendOrderNotification() {
    // Construct notification payload
    var notificationPayload = {
      'notification': {
        'title': 'New Order',
        'body': 'A new order has been placed.',
      },
      'data': {
        // Add any additional data needed to identify the order
      },
      'topic': 'seller_orders', // Topic subscribed to by seller app
    };

    // Send notification using Firebase Cloud Messaging
    // Replace 'your-server-key' with your FCM server key
    // Implement the appropriate FCM sending mechanism
    // Example: FirebaseMessaging.instance.sendToTopic('seller_orders', notificationPayload);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "My Orders".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
          stream: FirestoreServices.getAllOrders(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if(!snapshot.hasData){
              return Center(child: loadingIndicator(),);
            }else if(snapshot.data!.docs.isEmpty){
              return "No orders yet!".text.color(darkFontGrey).makeCentered();
            }else{
              var data = snapshot.data!.docs;
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index){
                    return ListTile(
                      leading: "${index+1}".text.fontFamily(bold).color(darkFontGrey).xl.make(),
                      title: data[index]['order_code'].toString().text.color(redColor).fontFamily(semibold).make(),
                      subtitle: data[index]['total_amount'].toString().numCurrency.text.fontFamily(bold).make(),
                      trailing: IconButton(
                        onPressed: () {
                          Get.to(() => OrdersDetails(data: data[index]));
                          // Call function to send notification when order is viewed
                          sendOrderNotification();
                        },
                        icon: const Icon(Icons.arrow_forward_ios_rounded,color: darkFontGrey,),
                      ),
                    );
                  }
              );
            }
          }
      ),
    );
  }
}
