import 'package:drugs_dosage_app/src/code/models/dosage_search.dart';
import 'package:flutter/material.dart';

class SearchInputDataSummary extends StatefulWidget {
  const SearchInputDataSummary({Key? key, required this.searchWrapper}) : super(key: key);
  final DosageSearchWrapper searchWrapper;

  @override
  State<SearchInputDataSummary> createState() => _SearchInputDataSummaryState();
}

class _SearchInputDataSummaryState extends State<SearchInputDataSummary> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Card(
        elevation: 8,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), 'Podsumowanie wyszukiwania'),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Column(
                        children: [
                          const Text(
                            'Substancja aktywna',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                              widget.searchWrapper.selectedMedicine.commonlyUsedName),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Column(
                      children: [

                            Column(
                              children: [
                                const Text(
                                  'Moc',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                    //style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                    widget.searchWrapper.potency!),
                              ],
                            )
                      ],
                    ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            const Text(
                              'Dawek dziennie',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                                //style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                '${widget.searchWrapper.dosagesPerDay}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Column(
                            children: [
                              const Text(
                                  style: TextStyle(fontWeight: FontWeight.bold), 'Liczba dni'),
                              Text(
                                  //style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                  '${widget.searchWrapper.totalDays}'),
                            ],
                          )
                        ],
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
