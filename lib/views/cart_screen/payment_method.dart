import 'package:furniture_user_side/consts/consts.dart';
import 'package:furniture_user_side/controllers/cart_controller.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';


import '../../consts/lists.dart';
import '../../widgets_common/loading_indicator.dart';
import '../../widgets_common/our_button.dart';
import '../home_screen/home.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({super.key});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  late Razorpay _razorpay;

  void openCheckout(amount)async{
    amount = amount *100;
    var options = {
      'key' : 'rzp_test_1DP5mmOlF5G5ag',
      'amount' : amount,
      'name' : 'One knot one',
      'prefill' : {'contact' : "1234567890", 'email' : 'test@gmail.com'},
      'external' : {
        'wallets' : ['paytm']
      }
    };
    try{
      _razorpay.open(options);
    }catch(e){
      debugPrint('Error: e');
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response){
    VxToast.show(context, msg: "Payment Successful${response.paymentId!}",);
  }

  void handlePaymentError(PaymentFailureResponse response){
    VxToast.show(context, msg: "Payment Fail${response.message!}",);
  }

  void handleExternalWallet(ExternalWalletResponse response){
    VxToast.show(context, msg: "External Wallet${response.walletName!}",);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }



  var controller = Get.find<CartController>();

  void _placeOrder() async {
    await controller.clearCart();
    VxToast.show(context, msg: "Order placed successfully");
    Get.offAll(const Home());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: SizedBox(
        height: 60,
        child: controller.placingOrder.value
            ? Center(
          child: loadingIndicator(),
        )
            : ourButton(
            onPress: () async {
              controller.placeMyOrder(
                orderPaymentMethod:
                paymentMethods[controller.paymentIndex.value],
                totalAmount: controller.totalP.value,
              );

              // Handle the selected payment method accordingly
              if (controller.paymentIndex.value == 0) {
                openCheckout(1);
                //openCheckout(controller.totalP.value);
              } else if (controller.paymentIndex.value == 1) {
                // Handle Cash on Delivery (COD)
                _placeOrder();
              }
            },
            color: redColor,
            textColor: whiteColor,
            title: "Place my order"),
      ),
      appBar: AppBar(
        title: "Payment Method"
            .text
            .fontFamily(semibold)
            .color(darkFontGrey)
            .make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Obx(
              () => Column(
            children: [
              displayPaymentOptions(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget displayPaymentOptions(var controller) {
    return Column(
      children: List.generate(paymentMethodimg.length, (index) {
        return GestureDetector(
          onTap: () {
            controller.changePaymentIndex(index);
          },
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: controller.paymentIndex.value == index
                    ? redColor
                    : Colors.transparent,
                width: 4,
              ),
            ),
            margin: const EdgeInsets.only(bottom: 8),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Image.asset(
                  paymentMethodimg[index],
                  width: double.infinity,
                  height: 120,
                  colorBlendMode: controller.paymentIndex.value == index
                      ? BlendMode.darken
                      : BlendMode.color,
                  color: controller.paymentIndex.value == index
                      ? Colors.black.withOpacity(0.4)
                      : Colors.transparent,
                  fit: BoxFit.cover,
                ),
                controller.paymentIndex.value == index
                    ? Transform.scale(
                  scale: 1.3,
                  child: Checkbox(
                    activeColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    value: true,
                    onChanged: (value) {},
                  ),
                )
                    : Container(),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: paymentMethods[index]
                      .text
                      .white
                      .fontFamily(semibold)
                      .size(16)
                      .make(),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
