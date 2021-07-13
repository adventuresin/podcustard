import 'package:http/http.dart' as http;
import 'package:podcustard/actions/store_feed_action.dart';
import 'package:podcustard/models/rss/rss_feed.dart';
import 'package:redfire/src/problems/extensions/error_extensions.dart';
import 'package:redfire/types.dart';

class FeedsService {
  FeedsService(this._httpClient);

  final http.Client _httpClient;

  Future<ReduxAction> retrieveFeed(String url) async {
    try {
      final uriResponse = await _httpClient.get(Uri.parse(url));
      final feed = RssFeed.parse(uriResponse.body);

      // Create an action and return
      return StoreFeedAction(feed);
    } catch (error, trace) {
      // if there were any problems collect available info and create an action
      return error.toAddProblemAction(trace);
    }
  }
}
