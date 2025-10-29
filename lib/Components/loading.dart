import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ShoppingCartLoading extends StatelessWidget {
  final String? message;

  const ShoppingCartLoading({super.key, this.message = 'Carregando...'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/shopping-cart-loading.json',
            width: 200,
            height: 200,
          ),
          if (message != null) ...[
            Container(
              width: 150,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white70,
              ),
              child: Text(
                message!,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
