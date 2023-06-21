import 'package:ecom_users/auth/auth_service.dart';
import 'package:ecom_users/models/adddress_model.dart';
import 'package:ecom_users/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserAddressPage extends StatefulWidget {
  static const String routeName = '/user_address';
  const UserAddressPage({super.key});

  @override
  State<UserAddressPage> createState() => _UserAddressPageState();
}

class _UserAddressPageState extends State<UserAddressPage> {
  late UserProvider userProvider;
  final formKey = GlobalKey<FormState>();
  final addressController = TextEditingController();
  final zipController = TextEditingController();

  String? city;
  String? area;


  @override
  void dispose() {
    addressController.dispose();
    zipController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    userProvider = Provider.of<UserProvider>(context);
    userProvider.getAllCities();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Address'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            TextFormField(
              controller: addressController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Street Address'
              ),
              validator: (value) {

              },
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: zipController,
              decoration: InputDecoration(
                  filled: true,
                  labelText: 'Zip Code'
              ),
              validator: (value) {

              },
            ),
            const SizedBox(height: 10,),
            DropdownButtonFormField<String>(
              value: city,
                hint: const Text('Choose your city'),
                items: userProvider.cityList.map((city) => DropdownMenuItem<String>(
                    child: Text(city.name),
                  value: city.name,)).toList(),

                onChanged: (value){
                    setState(() {
                      city = value;
                    });
                }
            ),
            const SizedBox(height: 10,),
            DropdownButtonFormField<String>(
                value: area,
                hint: const Text('Select Area'),
                items: userProvider.getAreasByCity(city).map((area) => DropdownMenuItem<String>(
                  child: Text(area),
                  value: area,)).toList(),

                onChanged: (value){
                  setState(() {
                    area = value;
                  });
                }
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
                onPressed: _save,
                child: const Text('Set Address'),),
          ],
        ),
      ),
    );
  }

  void _save() {
    if(formKey.currentState!.validate()){
      final address = AddressModel(
          streetAddress: addressController.text,
          area: area!,
          city: city!,
          zipCode: int.parse(zipController.text));
      userProvider
          .updateProfile(
          AuthService.user!.uid,
          address.toMap()).then((value) => Navigator.pop(context));

    }
  }
}
