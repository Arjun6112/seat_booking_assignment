import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  final List<List<bool>> selectedSeats = List.generate(
    8, // Number of rows
    (index) =>
        List.generate(4, (index) => false), // Number of seats in each row
  );
  bool isSearchEnabled = false;

  void searchSeat() {
    int seatNumber = int.parse(searchController.text);
    print(seatNumber);
    int rowNumber = seatNumber ~/ 4;
    int seatIndex = seatNumber % 4;
    setState(() {
      selectedSeats[rowNumber][seatIndex - 1] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seat Finder',
              style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Colors.blue[300]),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: SearchBar(
                    controller: searchController,
                    onChanged: (value) {
                      if (value != '') {
                        setState(() {
                          isSearchEnabled = true;
                        });
                      } else {
                        setState(() {
                          isSearchEnabled = false;
                        });
                      }
                    },
                    side: MaterialStateBorderSide.resolveWith(
                      (states) =>
                          BorderSide(width: 3.5, color: Colors.blue.shade200),
                    ),
                    elevation: MaterialStateProperty.resolveWith<double?>(
                        (states) => 0),
                    hintStyle: MaterialStateProperty.resolveWith<TextStyle?>(
                      (states) => GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue[300],
                      ),
                    ),
                    shape: MaterialStateProperty.resolveWith(
                      (states) => const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                      ),
                    ),
                    hintText: "Enter seat number...",
                  ),
                ),
                TextButton(
                    onPressed: () {
                      searchSeat();
                    },
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.resolveWith(
                            (states) => const Size(100, 55)),
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => isSearchEnabled
                                ? Colors.blue[200]
                                : Colors.grey[300]),
                        shape: MaterialStateProperty.resolveWith((states) =>
                            const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10))))),
                    child: Text(
                      'Find',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ))
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildSeatGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSeatGrid() {
    int i = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        selectedSeats.length,
        (rowIndex) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              selectedSeats[rowIndex].length,
              (seatIndex) {
                int correctIndex = seatIndex + 1;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedSeats[rowIndex][seatIndex] =
                          !selectedSeats[rowIndex][seatIndex];
                    });
                  },
                  child: Container(
                    width: 55,
                    height: 55,
                    margin: EdgeInsets.fromLTRB(
                      0, // Add margin for every 4th container
                      0,
                      correctIndex % 3 == 0 ? 100 : 0,
                      30,
                    ),
                    decoration: BoxDecoration(
                      border: (rowIndex) % 2 == 0
                          ? Border(
                              right: BorderSide(
                                  width: 5.0, color: Colors.blue.shade700),
                              left: BorderSide(
                                  width: 5.0, color: Colors.blue.shade700),
                              top: BorderSide(
                                  width: 5.0, color: Colors.blue.shade700))
                          : Border(
                              right: BorderSide(
                                  width: 5.0, color: Colors.blue.shade700),
                              left: BorderSide(
                                  width: 5.0, color: Colors.blue.shade700),
                              bottom: BorderSide(
                                  width: 5.0, color: Colors.blue.shade700)),
                      color: selectedSeats[rowIndex][seatIndex]
                          ? Colors.blue[800]
                          : Colors.blue[300],
                      // borderRadius: correctIndex % 4 == 0
                      //     ? BorderRadius.circular(6)
                      //     : BorderRadius.circular(0),
                    ),
                    child: Center(
                      child: Text(
                        '${i++ + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
