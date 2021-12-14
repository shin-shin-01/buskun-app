import 'package:stacked/stacked.dart';
import 'package:trainkun/shared/loading.dart';

import 'package:flutter/material.dart';

import 'login_viewmodel.dart';

class LoginView extends StatelessWidget {
  static const routeName = '/login';

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return ViewModelBuilder<LoginViewModel>.reactive(
        viewModelBuilder: () => LoginViewModel(),
        builder: (context, model, child) => model.isBusy
            ? Loading()
            : Scaffold(
                backgroundColor: Theme.of(context).primaryColor,
                body: SafeArea(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                              child: Image.asset(
                                'assets/images/top-icon.png',
                                width: size.width * 0.6,
                                fit: BoxFit.fitWidth,
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'ばすくん',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 32,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Align(
                                alignment: Alignment(0, 0),
                                child: Container(
                                  width: 230,
                                  height: 60,
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        width: 230,
                                        height: 60,
                                        child: Align(
                                          alignment: Alignment(0, 0),
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              model.signInWithGoogle();
                                            },
                                            label: const Text(
                                                'Sign in with Google',
                                                style: TextStyle(
                                                  color: Color(0xFF606060),
                                                  fontSize: 17,
                                                )),
                                            icon: Icon(
                                              Icons.add,
                                              color: Colors.transparent,
                                              size: 20,
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.white,
                                              elevation: 4,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(12),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment(-0.83, 0),
                                        child: Container(
                                          width: 22,
                                          height: 22,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: Image.network(
                                            'https://i0.wp.com/nanophorm.com/wp-content/uploads/2018/04/google-logo-icon-PNG-Transparent-Background.png?w=1000&ssl=1',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
  }
}
