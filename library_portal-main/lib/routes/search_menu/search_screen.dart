import 'package:flutter/material.dart';

import 'package:library_portal_app/configs/size_config.dart';
import 'package:library_portal_app/routes/search_menu/search_controller.dart';
import 'package:library_portal_app/widgets/appbar.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
   return ChangeNotifierProvider<SearchController>(
      create: (context) => SearchController(
      ),
      builder: (context, _) {
        return  _SearchScreenContent();
      },
    );
  }
}

class _SearchScreenContent extends StatelessWidget {
  _SearchScreenContent();

  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchController>(
      
      builder: (context, controller,_) {
        return Scaffold(
          appBar: const LibraryAppBar(title: "Search Items"),
          body: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(children: [
              TextFormField(
                
                controller: searchController,
                decoration: const InputDecoration(
                  label: Text("Search"),
                  //border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid,color: ColorConfig.borderColor))
                ),
              ),
            ]),
          ),
        );
      }
    );
  }
}
