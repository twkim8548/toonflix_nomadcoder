import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toonflix/services/api_service.dart';
import 'package:toonflix/widgets/webtoon_widget.dart';

import '../model/webtoon_model.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("오늘의 웹툰",
            style: TextStyle(
              fontSize: 24,
            )),
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
      ),
      body: FutureBuilder(
        future: webtoons,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                const SizedBox(
                    // height: 80,
                    ),
                Expanded(
                  child: makeList(snapshot),
                  // 리스트 뷰의 남는 공간을 채워주기 위해 사용 (Column은 높이 계산이 필요하기에)
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  GridView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return GridView.builder(
      itemCount: snapshot.data?.length ?? 0,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 30,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.7,
        mainAxisSpacing: 10,
        crossAxisSpacing: 30,
      ),
      itemBuilder: (context, index) {
        var webtoon = snapshot.data![index];

        return Webtoon(
            title: webtoon.title, thumb: webtoon.thumb, id: webtoon.id);
      },
    );
    // return ListView.separated(
    //   scrollDirection: Axis.vertical,
    //   itemCount: snapshot.data!.length,
    //   padding: const EdgeInsets.symmetric(
    //     vertical: 10,
    //     horizontal: 10,
    //   ),
    //   itemBuilder: (context, index) {
    //     var webtoon = snapshot.data![index];
    //     return Webtoon(title: webtoon.title, thumb: webtoon.thumb, id: webtoon.id);
    //   },
    //   separatorBuilder: (context, index) => const SizedBox(width: 40),
    // );
  }
}
