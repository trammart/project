import 'package:flutter/material.dart';

class AppBanner extends StatelessWidget {
  const AppBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.fromLTRB(75, 60, 65, 0),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                'SnackStore',
                style: TextStyle(
                  color: Theme.of(context).textTheme.titleLarge?.color,
                  fontSize: 42,
                  fontFamily: 'ShortBaby',
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Welcome to SnackStore :)',
                style: TextStyle(
                  color: Theme.of(context).textTheme.titleLarge?.color,
                  fontSize: 20,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Image(
                image: AssetImage('assets/images/logo.png'),
                width: 200,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
