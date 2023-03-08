import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocr_app/model/image.dart' as ima;
import 'package:ocr_app/screen/details_page.dart';
import 'package:ocr_app/screen/image_form_page.dart';
import 'package:provider/provider.dart';

import '../model/image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.image),
          onPressed: () {
            Navigator.pushNamed(context, ImageFormPage.routeName);
          },
        ),
        appBar: AppBar(title: Text('ORC App')),
        body: FutureBuilder(
          future:
              Provider.of<ima.ImageFile>(context, listen: false).fetchImage(),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Consumer<ima.ImageFile>(
                      child: Center(child: Text("Start add your story")),
                      builder: (context, image, child) => image.items.isEmpty
                          ? Container()
                          : GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      childAspectRatio: 3 / 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10),
                              itemBuilder: (context, i) => Padding(
                                padding: EdgeInsets.all(16.sp),
                                child: GridTile(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, DetailsPage.routeName,
                                          arguments: image.items[i]);
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.r),
                                      child: Image.file(
                                        image.items[i].image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  header: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () => Provider.of<ImageFile>(
                                                context,
                                                listen: false)
                                            .deleteImage(image.items[i]),
                                        icon: Icon(Icons.delete),
                                        color: Colors.red,
                                      )
                                    ],
                                  ),
                                  footer: GridTileBar(
                                    leading: Text(
                                      image.items[i].title,
                                      style: TextStyle(
                                          fontSize: 30.sp, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              itemCount: image.items.length,
                            ),
                    ),
        ));
  }
}
