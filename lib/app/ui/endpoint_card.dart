import 'package:coronavirus_rest_api_flutter_course/app/services/api.dart';
import 'package:flutter/material.dart';

class EndpointCard extends StatelessWidget {
  final Endpoint endpoint;
  final int value;

  const EndpointCard({Key key, this.endpoint, this.value}) : super(key: key);

  static Map<Endpoint, String> _cardTitles = {
    Endpoint.cases: 'Cases',
    Endpoint.casesConfirmed: 'Confirmed Cases',
    Endpoint.casesSuspected: 'Suspected Cases',
    Endpoint.deaths: 'Deaths',
    Endpoint.recovered: 'Recovered'
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                _cardTitles[endpoint],
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                value != null ? value.toString() : '',
                style: Theme.of(context).textTheme.headline5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
