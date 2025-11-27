import 'package:flutter/material.dart';

class CustomTextFormFeild extends StatelessWidget {
   CustomTextFormFeild({super.key, required this.priceController, this.onChanged});
  final TextEditingController priceController ;
    void Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 80,
      child: TextFormField(
          keyboardType: TextInputType.number,
          controller: priceController,
          decoration: InputDecoration(
            hintText: "0.75",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
          ),
        onChanged:onChanged ,
      ),
    );
  }
}
