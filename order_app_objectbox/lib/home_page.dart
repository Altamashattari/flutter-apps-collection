import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:order_app_objectbox/entities.dart';
import 'package:order_app_objectbox/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'order_data_table.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final faker = Faker();

  late Store _store;
  bool hasBeenInitialized = false;

  late Customer _customer;

  late Stream<List<ShopOrder>> _stream;

  @override
  void initState() {
    super.initState();
    setNewCustomer();
    getApplicationDocumentsDirectory().then((dir) {
      _store = Store(
        getObjectBoxModel(),
        directory: join(dir.path, 'objectbox'),
      );
      setState(() {
        _stream = _store
            .box<ShopOrder>()
            .query()
            .watch(triggerImmediately: true)
            .map((query) => query.find());
        hasBeenInitialized = true;
      });
    });
  }

  @override
  void dispose() {
    _store.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Orders App"),
        actions: [
          IconButton(
            onPressed: setNewCustomer,
            icon: const Icon(Icons.person_add_alt),
          ),
          IconButton(
            onPressed: addFakeOrderForCurrentCustomer,
            icon: const Icon(Icons.attach_money),
          ),
        ],
      ),
      body: !hasBeenInitialized
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder<List<ShopOrder>>(
              stream: _stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return OrderDataTable(
                  orders: snapshot.data!,
                  onSort: (columnIndex, ascending) {
                    final newQueryBuilder = _store.box<ShopOrder>().query();
                    final sortField =
                        columnIndex == 0 ? ShopOrder_.id : ShopOrder_.price;
                    newQueryBuilder.order(
                      sortField,
                      flags: ascending
                          ? 0
                          : Order.descending, // | Order.caseSensitive
                    );
                    setState(() {
                      _stream = newQueryBuilder
                          .watch(triggerImmediately: true)
                          .map((query) => query.find());
                    });
                  },
                  store: _store,
                );
              }),
    );
  }

  void setNewCustomer() {
    _customer = Customer(name: faker.person.name());
  }

  void addFakeOrderForCurrentCustomer() {
    final order = ShopOrder(price: faker.randomGenerator.integer(500, min: 10));
    order.customer.target = _customer;
    _store.box<ShopOrder>().put(order);
  }
}
