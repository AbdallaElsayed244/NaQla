import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderUi extends StatelessWidget {
  final List<Map<String, dynamic>> orderItems;
  const OrderUi({super.key, required this.orderItems});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orderItems.length,
      itemBuilder: (context, index) {
        final orderItem = orderItems[index];
        return Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${orderItem['Price']}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Quantity: ${orderItem['Quantity']}'),
              Text(' ${orderItem['item']}'),
              Text('Location: ${orderItem['Location']}'),
              if (orderItem['Time'] != null) Text('Time: ${orderItem['Time']}'),
              if (orderItem['Additional Notes'] != null)
                Text('Additional Notes: ${orderItem['Additional Notes']}'),
            ],
          ),
        );
      },
    );
  }
}
