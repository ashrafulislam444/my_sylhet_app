import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../../model/garageOwnerModel.dart';
import '../../ui.widgets/background_body.dart';
import 'garage_details.dart';
import 'garage_owner.dart';

class GarageScreen extends StatefulWidget {
  const GarageScreen({super.key});

  @override
  State<GarageScreen> createState() => _GarageScreenState();
}

class _GarageScreenState extends State<GarageScreen> {
  String? selectedArea = 'All';
  List<GarageOwnerModel> garageOwnerList = [];
  bool isLoading = false;

  final List<String> areaItems = [
    'All',
    'Ambarkhana', 'Arambagh', 'Bagbari', 'Barutkhana', 'Bondar', 'Chowhatta',
    'Chowkidekhi', 'Dariapara', 'Dorga Gate', 'Electric Supply', 'Fazil Chisth',
    'Hawapara', 'Housing Estate', 'Jollarpar', 'Kazir Bazar', 'Kazitula',
    'Korer Para', 'Kumar para', 'Kuar par', 'Lama Bazar', 'Londoni Road',
    'Laladigir par', 'Mezor Tila', 'Mirabazar', 'Munshi Para', 'Mirboxtula',
    'Mirer Maidan', 'Modina Market', 'Noyasorok', 'Osmani Medical', 'Pathantula',
    'Payra', 'Pir Moholla', 'Rikabi Bazar', 'Subidbazar', 'Sekhghat',
    'Shahi Eidgah', 'Shibgonj', 'Subhanighat', 'Tilaghar', 'Uposhohar A Block',
    'Uposhohar B Block', 'Uposhohar C Block', 'Uposhohar D Block',
    'Uposhohar E Block', 'Uposhohar G Block', 'Uposhohar H Block',
    'Uposhohar Plaza', 'Uposhohor', 'Zindabazar',
  ];

  @override
  void initState() {
    super.initState();
    fetchGarageOwners();
  }

  Future<void> fetchGarageOwners() async {
    setState(() => isLoading = true);

    try {
      QuerySnapshot snapshot;
      if (selectedArea == 'All') {
        snapshot = await FirebaseFirestore.instance.collection('Garage Owner').get();
      } else {
        snapshot = await FirebaseFirestore.instance
            .collection('Garage Owner')
            .where('address', isEqualTo: selectedArea)
            .get();
      }

      final owners = snapshot.docs.map((doc) {
        return GarageOwnerModel.fromFirestore(doc);
      }).toList();

      setState(() => garageOwnerList = owners);
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Image.asset(
          'assets/images/Garage.png',
          fit: BoxFit.cover,
        ),
        toolbarHeight: 100,
        elevation: 15,
        backgroundColor: Colors.grey,
      ),
      body: BackgroundBody(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: const Text(
                            'Select Area',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w900),
                          ),
                          items: areaItems
                              .map((String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: item == 'All'
                                      ? FontWeight.bold
                                      : FontWeight.normal),
                            ),
                          ))
                              .toList(),
                          value: selectedArea,
                          onChanged: (String? value) {
                            setState(() => selectedArea = value);
                            fetchGarageOwners();
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 80,
                            width: 200,
                          ),
                          menuItemStyleData:
                          const MenuItemStyleData(height: 40),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GarageOwner(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
                          fixedSize: const Size(90, 65),
                          elevation: 2,
                          backgroundColor: Colors.white38,
                          foregroundColor: Colors.black,
                          shadowColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: const BorderSide(color: Colors.white70, width: 2),
                          ),
                        ),
                        child: const Text(
                          'Garage Owner',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  buildGarageListView(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGarageListView() {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (garageOwnerList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(selectedArea == 'All'
              ? 'No garages available'
              : 'No garages found in $selectedArea'),
        ),
      );
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: garageOwnerList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final garage = garageOwnerList[index];
        return SizedBox(
          height: 150,
          child: Card(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 10,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/images/Garage.png', width: 120),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.blue),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                garage.address,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.phone, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(garage.phone),
                          ],
                        ),
                        const SizedBox(height: 5),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      GarageDetails(owner: garage),
                                ));
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            fixedSize: const Size(90, 35),
                            elevation: 5,
                            backgroundColor: Colors.blueGrey,
                            foregroundColor: Colors.white,
                            side: const BorderSide(
                                color: Colors.black26, width: 2),
                          ),
                          child: const Text(
                            'Details',
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}