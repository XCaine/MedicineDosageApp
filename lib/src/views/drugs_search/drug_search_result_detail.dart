import 'package:drugs_dosage_app/src/code/constants/constants.dart';
import 'package:drugs_dosage_app/src/code/models/database/medicine.dart';
import 'package:drugs_dosage_app/src/views/shared/drug_detail.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrugSearchResultDetail extends StatefulWidget {
  const DrugSearchResultDetail({Key? key, required this.medicine}) : super(key: key);
  final Medicine medicine;

  @override
  State<DrugSearchResultDetail> createState() => _DrugSearchResultDetailState();
}

class _DrugSearchResultDetailState extends State<DrugSearchResultDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Szczegóły leku'),
          actions: [IconButton(onPressed: () => context.go(Constants.homeScreenRoute), icon: const Icon(Icons.home))],
        ),
        body: Column(
          children: [DrugDetail(medicine: widget.medicine)],
        ));
  }
}
