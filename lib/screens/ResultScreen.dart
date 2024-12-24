import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart'; // for formatting date

class ResultScreen extends StatelessWidget {
  final double bmi;
  final String gender;
  final double height;
  final double weight;
  final int age;

  const ResultScreen({
    Key? key,
    required this.bmi,
    required this.gender,
    required this.height,
    required this.weight,
    required this.age,
  }) : super(key: key);

  // Function to determine the BMI status
  String getBmiStatus() {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return 'Normal weight';
    } else if (bmi >= 25 && bmi < 29.9) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }

  // Function to generate a unique reference number
  String generateReferenceNumber() {
    final DateFormat formatter = DateFormat('yyyyMMddHHmmss');
    final String referenceNumber = "BMI-${formatter.format(DateTime.now())}";
    return referenceNumber;
  }

  // Function to generate PDF
  Future<void> _generatePdf() async {
    final pdf = pw.Document();
    final referenceNumber = generateReferenceNumber();

    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          children: [
            // Title
            pw.Text("BMI Report", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),

            // Reference Number
            pw.Text("Reference No: $referenceNumber", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),

            // User Details Table
            pw.Table.fromTextArray(
              border: pw.TableBorder.all(width: 0.5, color: PdfColors.black),
              headers: ['Property', 'Details'],
              data: [
                ['Gender', gender],
                ['Height', '${height.toStringAsFixed(1)} cm'],
                ['Weight', '${weight.toStringAsFixed(1)} kg'],
                ['Age', '$age'],
                ['BMI', bmi.toStringAsFixed(2)],
                ['BMI Status', getBmiStatus()],
              ],
            ),
            pw.SizedBox(height: 20),

            // BMI Categories Table
            pw.Text("BMI Categories:", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              border: pw.TableBorder.all(width: 0.5, color: PdfColors.black),
              headers: ['BMI Category', 'BMI Range'],
              data: [
                ['Underweight', '< 18.5'],
                ['Normal weight', '18.5 - 24.9'],
                ['Overweight', '25 - 29.9'],
                ['Obese', '>= 30'],
              ],
            ),
            pw.SizedBox(height: 20),

            // Footer
            pw.Text("Generated on: ${DateTime.now().toLocal()}", style: pw.TextStyle(fontSize: 10)),
          ],
        );
      },
    ));

    // Saving the PDF to a file or sending for printing
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  // Function to stream the PDF (used for displaying the PDF on the screen)
  Future<void> _viewPdf() async {
    final pdf = pw.Document();
    final referenceNumber = generateReferenceNumber();

    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          children: [
            // Title
            pw.Text("BMI Report", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),

            // Reference Number
            pw.Text("Reference No: $referenceNumber", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),

            // User Details Table
            pw.Table.fromTextArray(
              border: pw.TableBorder.all(width: 0.5, color: PdfColors.black),
              headers: ['Property', 'Details'],
              data: [
                ['Gender', gender],
                ['Height', '${height.toStringAsFixed(1)} cm'],
                ['Weight', '${weight.toStringAsFixed(1)} kg'],
                ['Age', '$age'],
                ['BMI', bmi.toStringAsFixed(2)],
                ['BMI Status', getBmiStatus()],
              ],
            ),
            pw.SizedBox(height: 20),

            // BMI Categories Table
            pw.Text("BMI Categories:", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              border: pw.TableBorder.all(width: 0.5, color: PdfColors.black),
              headers: ['BMI Category', 'BMI Range'],
              data: [
                ['Underweight', '< 18.5'],
                ['Normal weight', '18.5 - 24.9'],
                ['Overweight', '25 - 29.9'],
                ['Obese', '>= 30'],
              ],
            ),
            pw.SizedBox(height: 20),

            // Footer
            pw.Text("Generated on: ${DateTime.now().toLocal()}", style: pw.TextStyle(fontSize: 10)),
          ],
        );
      },
    ));

    // Streaming the PDF to the screen
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: "BMI_Report_$referenceNumber.pdf",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BMI Result"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Displaying BMI and its status
            Text(
              "Your BMI is: ${bmi.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "Status: ${getBmiStatus()}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: getBmiStatus() == 'Obese'
                    ? Colors.red
                    : getBmiStatus() == 'Underweight'
                        ? Colors.yellow
                        : Colors.green,
              ),
            ),
            const SizedBox(height: 30),

            // User Data Table
            Table(
              border: TableBorder.all(),
              columnWidths: const {
                0: FixedColumnWidth(150),
                1: FlexColumnWidth(),
              },
              children: [
                // Row for Gender
                TableRow(
                  children: [
                    const TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Gender',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(gender),
                      ),
                    ),
                  ],
                ),
                // Row for Height
                TableRow(
                  children: [
                    const TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Height',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${height.toStringAsFixed(1)} cm'),
                      ),
                    ),
                  ],
                ),
                // Row for Weight
                TableRow(
                  children: [
                    const TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Weight',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${weight.toStringAsFixed(1)} kg'),
                      ),
                    ),
                  ],
                ),
                // Row for Age
                TableRow(
                  children: [
                    const TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Age',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('$age'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),

            // BMI Status and Category Table
            Table(
              border: TableBorder.all(),
              columnWidths: const {
                0: FixedColumnWidth(150),
                1: FlexColumnWidth(),
              },
              children: [
                TableRow(
                  children: [
                    const TableCell(child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('BMI Category', style: TextStyle(fontWeight: FontWeight.bold)),
                    )),
                    const TableCell(child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('BMI Range', style: TextStyle(fontWeight: FontWeight.bold)),
                    )),
                  ]
                ),
                TableRow(
                  children: [
                    const TableCell(child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Underweight'),
                    )),
                    const TableCell(child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('< 18.5'),
                    )),
                  ]
                ),
                TableRow(
                  children: [
                    const TableCell(child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Normal weight'),
                    )),
                    const TableCell(child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('18.5 - 24.9'),
                    )),
                  ]
                ),
                TableRow(
                  children: [
                    const TableCell(child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Overweight'),
                    )),
                    const TableCell(child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('25 - 29.9'),
                    )),
                  ]
                ),
                TableRow(
                  children: [
                    const TableCell(child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Obese'),
                    )),
                    const TableCell(child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('>= 30'),
                    )),
                  ]
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Button to generate or view PDF
            Center(
              child: ElevatedButton(
                onPressed: _generatePdf,
                child: const Text("Generate PDF"),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: _viewPdf,
                child: const Text("View PDF"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
