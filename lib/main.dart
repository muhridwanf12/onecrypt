import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'onecrypt',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController plainTextController;
  late TextEditingController keyController;
  late TextEditingController cipherTextController;
  late TextEditingController ivController;
  String process = '';
  late encrypt.IV iv;
  
  @override
  void initState(){
    super.initState();
    plainTextController = TextEditingController();
    keyController = TextEditingController();
    cipherTextController = TextEditingController();
    ivController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      body: Center(
        child: Container(
          height: 550,
          width: 500,
          decoration: BoxDecoration(
            color: Colors.grey[300]
          ),
          child: Column(
            children: [
              Container(
                width: 500,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue[700],
                ),
                child: const Center(
                  child: Text(
                    "AES (Advanced Encryption Standard)",
                    style:TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white
                    ) ,),) ,
              ),

              // PLAIN TEXT
              Padding(
                padding: const EdgeInsets.only(
                  left : 15,
                  top: 15,
                  right: 15
                ),
                child: TextField(
                  controller: plainTextController,
                  decoration:  const InputDecoration(
                    label:  Text("Before Process"),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              RadioListTile(
                value: 'Encrypt',
                title: const Text('Encrypt'), 
                groupValue: process, 
                onChanged: (value){
                  setState(() {
                  process = value!;
                  });
              }),

              RadioListTile(
                value: 'Decrypt', 
                title: const Text('Decrypt'),
                groupValue: process, 
                onChanged: (value){
                  setState(() {
                  process = value!;
                  });
              }),

              // KUNCI
              Padding(
                padding: const EdgeInsets.only(
                  left : 15,
                  top: 15,
                  right: 15
                ),
                child: TextField(
                  maxLength: 16,
                  controller: keyController,
                  decoration: const InputDecoration(
                    label: Text("Key ( must 16 chars)"),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),


              // INITIAL VECTOR
              Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  top: 15,
                  right: 15
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "*Optional",
                      textAlign: TextAlign.left,
                    ),
                    TextField(
                      maxLength: 16,
                      controller: ivController,
                      decoration: const InputDecoration(
                        label: Text("Initialization Vector ( max 16 chars)"),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),


              // TOMBOL EXECUTE/PROSES
              ElevatedButton(
                onPressed :(){
                  execute();
                }, 
                child: Text(process == ''? "Process" : process)
              ),


              // CIPHERTEXT
              Padding(
                padding: const EdgeInsets.only(
                  left : 15,
                  top: 15,
                  right: 15
                ),
                child: TextField(
                  controller: cipherTextController,
                  decoration:  const InputDecoration(
                    label: Text("After Process"),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

            ],
          ),
        ),
      )    
    );
  }


  void execute(){
    final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8(keyController.text)));
    if (encrypt.IV.fromUtf8(ivController.text) != encrypt.IV.fromUtf8('')){
      iv = encrypt.IV.fromUtf8(ivController.text);
      // Jika textfield IV diisi, maka karakter yang diinputkan akan dijadikan IV
      // Untuk mendekripsinya, gunakan kunci dan IV yang sama ketika melakukan enkripsi
    }else{
      iv = encrypt.IV.fromSecureRandom(16);
      // Jika textfield IV tidak diisi, maka akan dipilih  IV secara random setiap kali proses
      // ini membuat hasil enkripsi berbeda meskipun plaintext dan kuncinya sama.
      // Karena IV nya berbeda2 dan tidak diketahui, maka hasilnya tidak bisa dilakukan dekripsi
    }


    if (process == 'Encrypt'){
      final encrypted = encrypter.encrypt(plainTextController.text, iv : iv);
      setState(() {
        cipherTextController.text = encrypted.base64;
      });
    }else{
      final encrypted = encrypt.Encrypted.fromBase64(plainTextController.text);
      final decrypted = encrypter.decrypt(encrypted, iv : iv);
      setState(() {
        cipherTextController.text = decrypted;
      });
    }
  }

}


