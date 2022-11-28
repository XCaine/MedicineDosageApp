import 'package:drugs_dosage_app/src/features/root/drugs/drug_detail.dart';
import 'package:drugs_dosage_app/src/shared/logging/log_distributor.dart';
import 'package:drugs_dosage_app/src/shared/models/database/medicine.dart';
import 'package:drugs_dosage_app/src/shared/views/main_menu.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../../../shared/database/database.dart';

class DrugsList extends StatefulWidget {
  const DrugsList({Key? key}) : super(key: key);

  @override
  State<DrugsList> createState() => _DrugsListState();
}

class _DrugsListState extends State<DrugsList> {
  static final Logger _logger = LogDistributor.getLoggerFor('DrugsList');
  final _dbHandler = DatabaseBroker();
  final int _limit = 10;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  int _lastId = 0;

  final List<Medicine> _drugs = [];

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      final db = await _dbHandler.database;
      List<Map<String, Object?>> responseList =
          await db.rawQuery('select * from medicine where id > $_lastId order by id limit $_limit');
      List<Medicine> tempDrugs = [];
      for (Map<String, Object?> response in responseList) {
        tempDrugs.add(Medicine.fromJson(response));
      }
      setState(() {
        _drugs.addAll(tempDrugs);
        _lastId += _limit;
      });
    } catch (e, stackTrace) {
      _logger.severe('Something went load during initial load', e, stackTrace);
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _loadMore() async {
    if (_hasNextPage == true && _isFirstLoadRunning == false && _isLoadMoreRunning == false
        //&& _controller.position.extentAfter < 300
        ) {
      setState(() {
        _isLoadMoreRunning = true;
      });
    }
    try {
      final db = await _dbHandler.database;
      _logger.info('Loading more; Last ID: $_lastId, Limit: $_limit');
      List<Map<String, Object?>> responseList =
          await db.rawQuery('select * from medicine where id > $_lastId order by id limit $_limit');
      if (responseList.isNotEmpty) {
        List<Medicine> tempDrugs = [];
        for (Map<String, Object?> response in responseList) {
          tempDrugs.add(Medicine.fromJson(response));
        }
        setState(() {
          _drugs.addAll(tempDrugs);
          _lastId += _limit;
        });
      } else {
        setState(() {
          _hasNextPage = false;
        });
      }
    } catch (e, stackTrace) {
      _logger.severe('Something went load during another load', e, stackTrace);
    }

    setState(() {
      _isLoadMoreRunning = false;
    });
  }

  //late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _firstLoad();
    //_controller = ScrollController()..addListener(_loadMore);
  }

/*  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Baza leków'),
      ),
      drawer: const MainMenu(),
      body: _isFirstLoadRunning
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                if (_drugs.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text('Brak leków'),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    //controller: _controller,
                    itemCount: _drugs.length,
                    itemBuilder: (_, index) => Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      child: ListTile(
                        title: Text(_drugs[index].productName),
                        subtitle: Text(_drugs[index].commonlyUsedName),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DrugDetail(medicine: _drugs[index])),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                if (_isLoadMoreRunning == true)
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 40),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                if (_hasNextPage && _drugs.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    color: Colors.grey[400],
                    child: Center(
                      child: TextButton(onPressed: _loadMore, child: const Text('Load more records')),
                    ),
                  ),
                if (!_hasNextPage)
                  Container(
                    padding: const EdgeInsets.only(top: 30, bottom: 40),
                    color: Colors.grey[400],
                    child: const Center(
                      child: Text('You have fetched all of the content'),
                    ),
                  ),
              ],
            ),
    );
  }
}

/*class DrugsList extends StatefulWidget {
  const DrugsList({Key? key}) : super(key: key);

  @override
  State<DrugsList> createState() => _DrugsListState();
}

class _DrugsListState extends State<DrugsList> {
  final DatabaseFacade _dbClient = DatabaseFacade();
  late Future<List<Medicine>> _medicineList;

  @override
  void initState() {
    super.initState();
    _medicineList = _dbClient.getMedicine();
  }

  @override
  Widget build(BuildContext context) {
    Widget noDrugsScreen = const Center(
      child: Text('Brak leków'),
    );

    Widget drugsList = FutureBuilder<List<Medicine>>(
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data!.isEmpty) {
            return noDrugsScreen;
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${snapshot.data?[index].productName}\t${snapshot.data?[index].createTime}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DrugDetail(medicine: snapshot.data![index])),
                    );
                  },
                );
              },
            );
          }
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Failed to fetch medicine data from database'),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
      future: _medicineList,
    );

    return RootLayout(child: drugsList);
  }
}*/
