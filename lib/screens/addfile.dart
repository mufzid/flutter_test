import 'package:crud_api/functions/provider_api.dart';
import 'package:crud_api/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:gap/gap.dart';

class AddScreen extends StatefulWidget {
  final Map? todo;
  const AddScreen({super.key, this.todo});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  String? selectedStates;
  String? gender;
  String? countryValue = "";
  String? stateValue = "";
  String? cityValue = "";
  String? address = "";
  TextEditingController employeeName = TextEditingController();
  TextEditingController employeeEmail = TextEditingController();
  TextEditingController employeeJob = TextEditingController();
  TextEditingController employeeAddress = TextEditingController();
  TextEditingController employeeNumber = TextEditingController();

  bool isEdit = false;
  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final name = todo['name'];
      final email = todo['email'];
      final job = todo['job'];
      final sex = todo['sex'];
      final address = todo['address'];
      final number = todo['number'];
      final state = todo['state'];
      final country = todo['country'];
      final city = todo['city'];

      employeeName.text = name;
      employeeEmail.text = email;
      employeeJob.text = job;
      gender = sex;
      employeeAddress.text = address;
      employeeNumber.text = number;
      countryValue = country;
      stateValue = state;
      cityValue = city;
    }
  }

  @override
  Widget build(BuildContext context) {
    // GlobalKey<CSCPickerState> _cscPickerKey = GlobalKey();

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        title: Text(
          isEdit ? 'Update Employee' : 'Add Employee',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(children: [
            TextField(
              controller: employeeName,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3)),
                  label: const Text('Employee Name')),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: employeeEmail,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(3)),
                label: const Text('Email'),
              ),
            ),

            const Gap(10),
            TextField(
              controller: employeeJob,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3)),
                  label: const Text('Designation')),
            ),

            const Gap(10),
            ListTile(
              title: const Text('Male'),
              leading: Radio(
                  value: 'male',
                  groupValue: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value;
                    });
                  }),
            ),
            ListTile(
              title: const Text('Female'),
              leading: Radio(
                  value: 'female',
                  groupValue: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value;
                    });
                  }),
            ),
            SizedBox(
              child: TextField(
                controller: employeeAddress,
                decoration: InputDecoration(
                    // contentPadding: EdgeInsets.symmetric(vertical: 40.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3)),
                    label: const Text('Address')),
              ),
            ),
            const Gap(20),
            TextField(
              controller: employeeNumber,
              keyboardType: TextInputType.number,
              maxLength: 10,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3)),
                  label: const Text('Phone Number')),
            ),
            //
            CSCPicker(
              showStates: true,
              showCities: true,
              flagState: CountryFlag.DISABLE,
              dropdownDecoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color.fromARGB(255, 236, 235, 235),
              ),
              disabledDropdownDecoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: const Color.fromARGB(255, 234, 233, 233),
                  border: Border.all(color: Colors.grey, width: 1)),
              // defaultCountry: CscCountry.India,
              countryFilter: const [
                CscCountry.India,
                CscCountry.United_States,
                CscCountry.Canada
              ],
              countrySearchPlaceholder: "Country",
              stateSearchPlaceholder: "State",
              citySearchPlaceholder: "City",
              countryDropdownLabel: "Country",
              stateDropdownLabel: "State",
              cityDropdownLabel: "City",
              selectedItemStyle: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
              dropdownHeadingStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
              dropdownItemStyle: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
              dropdownDialogRadius: 10.0,
              searchBarRadius: 10.0,
              onCountryChanged: (value) {
                setState(() {
                  countryValue = value;
                });
              },
              onStateChanged: (valueState) {
                setState(() {
                  ///store value in state variable
                  stateValue = valueState;
                });
              },
              onCityChanged: (valueCity) {
                setState(() {
                  ///store value in city variable
                  cityValue = valueCity;
                });
              },
            ),

            const Gap(20),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/list');
                  if (isEdit == true) {
                    if (updateEmployee() == true) {
                      showErrorMessage(context, message: 'update successfully');
                    }
                  } else {
                    // addEmployee();
                    if (addEmployee() == true) {
                      showErrorMessage(context, message: 'Added successfully');
                    }
                  }
                },
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.red),
                  minimumSize:
                      MaterialStatePropertyAll(Size(double.infinity, 56)),
                ),
                child: Text(
                  isEdit ? 'Update' : 'Submit',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                )),
            const SizedBox(
              height: 10,
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> updateEmployee() async {
    final todo = widget.todo;
    if (todo == null) {
      print('You can not call updated without todo data');
      return;
    }
    final id = todo['_id'];
    final name = employeeName.text;
    final email = employeeEmail.text;
    final job = employeeJob.text;
    final sex = gender.toString();
    final address = employeeAddress.text;
    final number = employeeNumber.text;
    final country = countryValue.toString();
    final state = stateValue.toString();
    final city = cityValue.toString();

    final body = {
      "address": address,
      "city": city,
      "country": country,
      "email": email,
      "job": job,
      "sex": sex,
      "number": number,
      "state": state,
      "name": name
    };

    return await EmployeeProvider().updateEmployee(id, body);
  }

  Future<void> addEmployee() async {
    final name = employeeName.text;
    final email = employeeEmail.text;
    final job = employeeJob.text;
    final sex = gender.toString();
    final address = employeeAddress.text;
    final number = employeeNumber.text;
    final country = countryValue.toString();
    final state = stateValue.toString();
    final city = cityValue.toString();

    final body = {
      "address": address,
      "city": city,
      "country": country,
      "email": email,
      "job": job,
      "sex": sex,
      "number": number,
      "state": state,
      "name": name
    };
    return await EmployeeProvider().addEmployee(body);
  }
}
