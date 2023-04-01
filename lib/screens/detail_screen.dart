import 'package:flutter/material.dart';
import 'package:toonflix/model/webtoon_episode_model.dart';
import 'package:toonflix/services/api_service.dart';

import '../model/webtoon_detail_model.dart';

class DetailScreen extends StatefulWidget {
  final title, thumb, id;

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episodes;

  @override
  void initState() {
    super.initState();

    webtoon = ApiService.getToonById(widget.id);
    episodes = ApiService.getLatestEpisodeById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
          elevation: 2,
          backgroundColor: Colors.white,
          foregroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: widget.id,
                      child: Container(
                        width: 250,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 15,
                                offset: const Offset(10, 10),
                                color: Colors.black.withOpacity(0.3),
                              ),
                            ]),
                        child: Image.network(widget.thumb),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                FutureBuilder(
                  future: webtoon,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data!.about,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "${snapshot.data!.genre} / ${snapshot.data!.age}",
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      );
                    }
                    return const RefreshProgressIndicator();
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                FutureBuilder(
                    future: episodes,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            for (var episode in snapshot.data!)
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.green.shade400, width: 1),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow:  [
                                    BoxShadow(
                                      blurRadius: 15,
                                      offset: const Offset(10,10),
                                      color: Colors.green.withOpacity(0.2),
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 20,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        episode.title,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.green.shade400,
                                        ),
                                      ),
                                      Icon(
                                        Icons.chevron_right_rounded,
                                        color: Colors.green.shade400,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                          ],
                        );
                      }
                      return Container();
                    }),
              ],
            ),
          ),
        ));
  }
}
