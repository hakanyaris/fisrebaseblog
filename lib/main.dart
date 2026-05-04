import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Iskele());
  }
}

class Iskele extends StatefulWidget {
  @override
  State<Iskele> createState() => _IskeleState();
}

class _IskeleState extends State<Iskele> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();

  var gelenYaziBasligi = "";
  var gelenYaziIcerigi = "";

  yaziEkle() {
    FirebaseFirestore.instance
        .collection('Yazilar')
        .doc(t1.text)
        .set({'baslik': t1.text, 'icerik': t2.text})
        .whenComplete(() => {print("yazı eklendi")});
  }

  yaziGuncelle() {
    FirebaseFirestore.instance
        .collection('Yazilar')
        .doc(t1.text)
        .update({'baslik': t1.text, 'icerik': t2.text})
        .whenComplete(() => {print("yazı güncellendi")});
  }

  yaziSil() {
    FirebaseFirestore.instance
        .collection('Yazilar')
        .doc(t1.text)
        .delete()
        .whenComplete(() => {print("yazı silindi")});
  }

  yaziGetir() {
    FirebaseFirestore.instance
        .collection('Yazilar')
        .doc(
          t1.text,
        ) // koleksiyondaki tüm yazıları çekmek için bu satırı (doc(t1.text)) siliyoruz.
        .get()
        .then((gelenVeri) {
          setState(() {
            gelenYaziBasligi = gelenVeri.data()?['baslik'];
            gelenYaziIcerigi = gelenVeri.data()?["icerik"];
          });
        })
        .whenComplete(() => {print("yazı alındı.")});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(15),
        child: Center(
          child: Column(
            children: [
              TextField(controller: t1),
              TextField(controller: t2),
              Row(
                children: [
                  ElevatedButton(onPressed: yaziEkle, child: Text("Ekle")),
                  ElevatedButton(
                    onPressed: yaziGuncelle,
                    child: Text("Güncelle"),
                  ),
                  ElevatedButton(onPressed: yaziSil, child: Text("Sil")),
                  ElevatedButton(
                    onPressed: yaziGetir,
                    child: Text("Görüntüle"),
                  ),
                ],
              ),
              ListTile(
                title: Text(gelenYaziBasligi),
                subtitle: Text(gelenYaziIcerigi),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
