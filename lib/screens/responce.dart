import 'package:EventBasedapp/dropdown.dart';
import 'package:flutter/material.dart';

class responce extends StatefulWidget {
  const responce({Key? key}) : super(key: key);

  @override
  _responce createState() => _responce();
}

class _responce extends State<responce> {
  Map<String, int> itemCounts = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('responce '),
      ),
      endDrawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 350.0,
                height: 350.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/splash1.jpg',
                    fit: BoxFit.cover,
                    width: 350.0,
                    height: 350.0,
                  ),
                ),
              ),
              const SizedBox(height: 17),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.close),
                      label: const Text('Not interested'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(243, 250, 154, 154),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.check),
                      label: const Text('Yes, I will attend'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 345, 226, 185),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 17,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
              ),
              const Text(
                'Gifting Idea Links',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              _buildCardList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardList() {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        _buildCard(
          'assets/splash2.jpg',
          'Men\'s T-Shirt\nstripes \n\$19',
        ),
        _buildCard(
          'assets/splash3.jpg',
          ' White court\n\$20',
        ),
        _buildCard('assets/splash4.jpg', 'Item 3'),
        // Add more cards as needed
      ],
    );
  }

  Widget _buildCard(String imagePath, String text) {
    // Initialize count to 0 if not already set
    itemCounts[text] ??= 0;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: 100.0,
                height: 100.0,
              ),
              const SizedBox(width: 8.0),
              Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        itemCounts[text] = (itemCounts[text] ?? 0) + 1;
                      });
                    },
                  ),
                  Text(itemCounts[text]?.toString() ?? '0'),
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        if (itemCounts[text] != null && itemCounts[text]! > 0) {
                          itemCounts[text] = itemCounts[text]! - 1;
                        }
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
