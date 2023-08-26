import 'package:flutter/material.dart';

import '../LocalStorage.dart';
import '../consts.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  LocalStorage store = LocalStorage();
  String contactsNumber = '0';

  @override
  void initState() {
    getContacts();
    super.initState();
  }

  void getContacts() {
    store.getStringList(CONTACTS).then(
        (value) => setState(() => contactsNumber = value.length.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Row(
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
                  child: Column(
                    children: const [
                      ListTile(
                        leading: Icon(Icons.calendar_today),
                        title: Text('Scheduled'),
                        subtitle: Center(
                          child: Text(
                            '0',
                            style: TextStyle(fontSize: 32.0),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.phone,
                        ),
                        title: const Text('Contacts'),
                        subtitle: Center(
                          child: Text(
                            contactsNumber,
                            style: const TextStyle(fontSize: 32.0),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }
}

// class Dashboard extends StatelessWidget {
//   const Dashboard({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(children: [
//         Row(
//           children: [
//             Expanded(
//               child: Card(
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
//                   child: Column(
//                     children: const [
//                       ListTile(
//                         leading: Icon(Icons.calendar_today),
//                         title: Text('Scheduled'),
//                         subtitle: Center(
//                           child: Text(
//                             '0',
//                             style: TextStyle(fontSize: 32.0),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Card(
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
//                   child: Column(
//                     children: const [
//                       ListTile(
//                         leading: Icon(Icons.phone,),
//                         title: Text('Contacts'),
//                         subtitle: Center(
//                           child: Text(
//                             '0',
//                             style: TextStyle(fontSize: 32.0),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         )
//       ]),
//     );
//   }
// }
