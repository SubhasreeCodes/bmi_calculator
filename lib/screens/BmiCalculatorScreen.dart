import 'package:flutter/material.dart';
import 'ResultScreen.dart';

class BmiCalculatorScreen extends StatefulWidget {
  const BmiCalculatorScreen({Key? key}) : super(key: key);

  @override
  _BmiCalculatorScreenState createState() => _BmiCalculatorScreenState();
}

class _BmiCalculatorScreenState extends State<BmiCalculatorScreen> {
  double height = 160;
  double weight = 50;
  int age = 25;
  String gender = "Male";

  final TextEditingController _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BMI Calculator"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gender Selection Cards with Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GenderCard(
                  color: Colors.pink,
                  genderIcon: Icons.female,
                  isSelected: gender == "Female",
                  onTap: () {
                    setState(() {
                      gender = "Female";
                    });
                  },
                ),
                GenderCard(
                  color: Colors.orange,
                  genderIcon: Icons.male,
                  isSelected: gender == "Male",
                  onTap: () {
                    setState(() {
                      gender = "Male";
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Height Card with Slider
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      "Height (cm)",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Slider(
                      value: height,
                      min: 100,
                      max: 220,
                      onChanged: (double newHeight) {
                        setState(() {
                          height = newHeight;
                        });
                      },
                    ),
                    Text(
                      "${height.toStringAsFixed(1)} cm",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Weight and Age Cards in Horizontal Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Weight Card with Simple Slider
                Flexible(
                  flex: 1,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const Text(
                            "Weight (kg)",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Slider(
                            value: weight,
                            min: 30,
                            max: 200,
                            divisions: 170, // 170 steps between the min and max
                            label: weight.toStringAsFixed(1),
                            onChanged: (double newWeight) {
                              setState(() {
                                weight = newWeight;
                              });
                            },
                          ),
                          Text(
                            "${weight.toStringAsFixed(1)} kg",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // Age Card with Number Box
                Flexible(
                  flex: 1,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const Text(
                            "Age",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 80,
                            child: TextField(
                              controller: _ageController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: "Age",
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  age = int.tryParse(value) ?? 25;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Calculate BMI Button
            ElevatedButton(
              onPressed: () {
                // Ensure valid height and weight are set
                if (height >= 100 && weight >= 30) {
                  double bmi = weight / ((height / 100) * (height / 100));
                  // Navigate to ResultScreen and pass the BMI value and other data
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultScreen(
                        bmi: bmi,
                        gender: gender,
                        height: height,
                        weight: weight,
                        age: age,
                      ),
                    ),
                  );
                } else {
                  // Show a simple alert dialog if height or weight are invalid
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Invalid Input"),
                      content: const Text("Please make sure height and weight are within the valid range."),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text("Calculate BMI"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GenderCard extends StatelessWidget {
  final Color color;
  final IconData genderIcon;
  final bool isSelected;
  final VoidCallback onTap;

  const GenderCard({
    Key? key,
    required this.color,
    required this.genderIcon,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: isSelected ? color : color.withOpacity(0.6),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Icon(
              genderIcon,
              size: 50,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
