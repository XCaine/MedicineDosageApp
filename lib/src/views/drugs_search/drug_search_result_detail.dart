import 'package:drugs_dosage_app/src/code/models/database/medicine.dart';
import 'package:drugs_dosage_app/src/views/drugs_search/drug_detail.dart';
import 'package:flutter/material.dart';

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
        ),
        body: Column(
          children: [DrugDetail(medicine: widget.medicine)],
        ));
  }
}
