import 'package:flutter/material.dart';

class FloatingButtonWidget extends StatelessWidget {
  const FloatingButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, 38),

      child: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/nova-transacao");
        },

        backgroundColor: Colors.blue.shade700,

        child: Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }
}
