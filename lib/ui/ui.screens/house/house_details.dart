import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:my_sylhet_version_1/model/houseOwnerModel.dart';
import '../../ui.widgets/background_body.dart';

class HouseDetails extends StatefulWidget {
  final HouseOwnerModel owner;
  const HouseDetails({super.key,required this.owner});


  @override
  State<HouseDetails> createState() => _HouseDetailsState();
}

class _HouseDetailsState extends State<HouseDetails> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Image.asset('assets/images/Details.png',
          // height: 180,
          fit: BoxFit.cover,
        ),

        toolbarHeight: 100,
        elevation: 15,
        backgroundColor: Colors.grey,
      ),
      body: BackgroundBody(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                          Column(
                            children: [
                              CarouselSlider(
                                options: CarouselOptions(height:160.0,),
                                items: [1,2,3,].map((i) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return Container(
                                          width: MediaQuery.of(context).size.width,
                                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          alignment: Alignment.center,
                                          child: Image.asset('assets/images/House.png',fit: BoxFit.cover,),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),

                              const SizedBox(height: 40,),
                              Row(
                                children: [
                                Text('Description:',style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),),
                                ],
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Text('The details that you provide for a product affect the way that the product is displayed to customers,'
                                    ' make it easier for you to organize your products, and help customers find the product.'
                                    'The name for your product that you want to display to your customers.',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontSize:15,
                                  ),
                                ),
                              ),
                            ],
                          ),


                      Padding(
                        padding:const EdgeInsets.symmetric(vertical: 12),
                        child: Text('House Rent:',style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),),
                      ),
                      Padding(
                        padding:const EdgeInsets.symmetric(vertical: 12),
                        child: Text('House No. :',style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),),
                      ),
                      Padding(
                        padding:const EdgeInsets.symmetric(vertical: 12),
                        child: Text('Road No. :',style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),),
                      ),
                      Padding(
                        padding:const EdgeInsets.symmetric(vertical: 12),
                        child: Text('Area:',style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),),
                      ),

                    ],
                  ),

              ),
            ),
          ),
        ),


      ),



    );
  }
}
