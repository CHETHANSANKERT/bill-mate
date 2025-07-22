import 'package:bill_mate/components/ui/text_input_field.dart';
import 'package:bill_mate/components/ui/text_style.dart';
import 'package:bill_mate/model/store/store.dart';
import 'package:bill_mate/utils/app_snackbar.dart';
import 'package:bill_mate/utils/custon_date_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';

import '../../bloc/store/store_bloc.dart';
import '../../components/button/primary_button.dart';
import '../../components/ui/app_bar.dart';
import '../../components/ui/dropdown_textfield.dart';
import '../../model/general/key_value.dart';
import '../../routes/app_pages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/local/db_service.dart';

class CreateStore extends StatefulWidget {
  const CreateStore({super.key});

  @override
  State<CreateStore> createState() => _CreateStoreState();
}

class _CreateStoreState extends State<CreateStore> {
  late final TextEditingController _beatNameController;
  late final TextEditingController _areaNameController;
  late final TextEditingController _storeNameController;
  late final TextEditingController _ownerNameController;
  late final TextEditingController _productsController;
  late final TextEditingController _locationController;
  late final TextEditingController _addressController;
  late final TextEditingController _gstNumberController;
  late final TextEditingController _mobileNumberController;

  final _formKey = GlobalKey<FormState>();
  String _beatName = '';
  String _areaName = '';
  String _storeName = '';
  String _ownerName = '';
  String _location = '';
  String _gstNumber = '';
  String _address = '';

  @override
  void initState() {
    initailizeEditor();
    super.initState();
  }

  initailizeEditor() {
    _beatNameController = TextEditingController();
    _areaNameController = TextEditingController();
    _storeNameController = TextEditingController();
    _ownerNameController = TextEditingController();
    _productsController = TextEditingController();
    _locationController = TextEditingController();
    _addressController = TextEditingController();
    _gstNumberController = TextEditingController();
    _mobileNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _areaNameController.dispose();
    _storeNameController.dispose();
    _ownerNameController.dispose();
    _productsController.dispose();
    _locationController.dispose();
    _addressController.dispose();
    _gstNumberController.dispose();
    _beatNameController.dispose();
    _mobileNumberController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final String storeId = const Uuid().v4();
      final StoreModel storeData = StoreModel(
        storeId: storeId,
        storeName: _storeName,
        ownerName: _ownerName,
        location: _location,
        gstNumber: _gstNumber,
        area: _areaName,
        beat: _beatName,
        address: _address,
        mobileNum: _mobileNumberController.text,
      );

      /// for adding the store if it is not present in into the database
      await DatabaseHelper().insertStore(storeData);
      Navigator.pushNamed(
        context,
        AppRoutes.addProducts,
        arguments: {
          'storeId': storeId,
          'storeName': _storeName,
          'ownerName': _ownerName,
          'location': _location,
          'area': _areaName,
          'beat': _beatName,
          'address': _address,
          'gstNumber': _gstNumber,
          'createdAt': DateTime.now().cddmmyyyy
        },
      );
    } else {
      appSnackbar(message: 'Please enter all the values');
    }
  }

  String storeId = '';

  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName cannot be empty';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
        context: context,
        title: 'Create-Store',
        isBackReq: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.h),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Create your store in minutes',
                  style: AppTextStyles.kw600Black18,
                  textAlign: TextAlign.center,
                ),
              ),
              16.verticalSpace,
              const Text(
                'Store Details : ',
                style: AppTextStyles.kw800Black18,
              ),
              16.verticalSpace,
              DropDownTextField(
                name: 'beat',
                label: 'Beat Name',
                hintText: 'Enter the Beat Name',
                suggestionsCallback: (query) => DatabaseHelper()
                    .getDistinctFieldValuesFromStore('beat', query),
                onSaved: (value) => _beatName = value ?? '',
                validator: (value) => _validateNotEmpty(value, 'Beat'),
                controller: _beatNameController,
              ),
              16.verticalSpace,
              DropDownTextField(
                name: 'area',
                hintText: 'Enter the area name',
                label: 'Area Name',
                onSaved: (value) => _areaName = value ?? '',
                validator: (value) => _validateNotEmpty(value, 'Area'),
                suggestionsCallback: (query) {
                  return DatabaseHelper().getDistinctFieldValuesFromStore(
                    'area',
                    query,
                    keyValue: [
                      KeyValue(key: 'beat', value: _beatNameController.text)
                    ],
                  );
                },
                controller: _areaNameController,
              ),
              16.verticalSpace,
              BlocBuilder<StoreBloc, StoreState>(builder: (context, state) {
                return DropDownTextField(
                  name: 'storeName',
                  label: 'Store Name',
                  controller: _storeNameController,
                  hintText: 'Enter store name',
                  onSaved: (value) => _storeName = value ?? '',
                  validator: (value) => _validateNotEmpty(value, 'storeName'),
                  suggestionsCallback: (query) {
                    return DatabaseHelper().getDistinctFieldValuesFromStore(
                      'storeName',
                      query,
                      keyValue: [
                        KeyValue(key: 'beat', value: _beatNameController.text),
                        KeyValue(key: 'area', value: _areaNameController.text),
                      ],
                    );
                  },
                  onTap: () async {
                    final store = await DatabaseHelper().findStore(
                        _storeNameController.text,
                        _areaNameController.text,
                        _beatNameController.text);
                    _ownerNameController.text = store['ownerName'].toString();
                    _addressController.text = store['address'].toString();
                    _gstNumberController.text = store['gstNumber'].toString();
                    _locationController.text = store['location'].toString();
                    storeId = store['storeId'].toString();
                    _mobileNumberController.text =
                        store['mobileNum'].toString();
                  },
                );
              }),
              16.verticalSpace,
              TextInputField(
                name: 'ownerName',
                label: 'Owner Name',
                controller: _ownerNameController,
                hintText: 'Enter store name',
                onSaved: (value) => _ownerName = value ?? '',
                validator: (value) => _validateNotEmpty(value, 'ownerName'),
              ),
              16.verticalSpace,
              TextInputField(
                name: 'address',
                label: 'Store address',
                controller: _addressController,
                hintText: 'Enter store address',
                onSaved: (value) => _address = value ?? '',
                validator: (value) => _validateNotEmpty(value, 'address'),
              ),
              16.verticalSpace,
              TextInputField(
                name: 'mobileNum',
                label: 'Mobile number',
                controller: _mobileNumberController,
                hintText: 'Enter store Mobile number',
                maxLength: 10,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                // onSaved: (value) => _mobileNum = value ?? '',
                validator: (value) => _validateNotEmpty(value, 'mobile number'),
              ),
              16.verticalSpace,
              TextInputField(
                name: 'gstNUmber',
                label: 'GST Number',
                controller: _gstNumberController,
                hintText: 'Enter the GST Number',
                onSaved: (value) => _gstNumber = value ?? '',
              ),
              16.verticalSpace,
              TextInputField(
                name: 'location',
                label: 'Store Location',
                controller: _locationController,
                hintText: 'Enter store location',
                onSaved: (value) => _location = value ?? '',
              ),
              24.verticalSpace,
              Center(
                child: PrimaryButton(
                  buttonName: 'Add-Sale',
                  onClickfunction: () {
                    // _isStorePresent ? Navigator.pushNamed(
                    //   context,
                    //   AppRoutes.addProducts,
                    //   arguments: {
                    //     'storeId': storeId,
                    //     'storeName': _storeNameController.text,
                    //     'ownerName': _ownerNameController.text,
                    //     'location': _locationController.text,
                    //     'area': _areaNameController.text,
                    //     'beat': _beatNameController.text,
                    //     'address': _addressController.text,
                    //     'gstNumber': _gstNumberController.text,
                    //     'createdAt': DateTime.now().cddmmyyyy
                    //   },
                    // ) :
                    _submitForm();
                  },
                  kSize: Size(0.4.sw, 60.h),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
