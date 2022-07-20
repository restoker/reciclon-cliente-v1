import 'package:flutter/material.dart';

class Loading {
  static Future<void> show(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width * 0.25;
    return showDialog(
      context: context,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: Container(
          width: ancho,
          height: double.infinity,
          color: Colors.white54,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 100),
            child: Visibility(
              child: LinearProgressIndicator(
                backgroundColor: Colors.white,
              ),
            ),
          ),
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
