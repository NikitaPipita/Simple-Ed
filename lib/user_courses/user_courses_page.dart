import 'package:flutter/material.dart';

import '../api_interection/data_models.dart';
import '../api_interection/requests.dart';
import '../course_view/course_card.dart';
import 'course_creation_page.dart';

class UserCoursesPage extends StatefulWidget {
  @override
  _UserCoursesPageState createState() => _UserCoursesPageState();
}

class _UserCoursesPageState extends State<UserCoursesPage> with SingleTickerProviderStateMixin {

  final coursesTabs = [
    Tab(text: 'My Courses'),
    Tab(text: 'Created Courses'),
  ];
  TabController _tabController;

  Future<UserCourses> _futureUserCourses;
  bool _isFutureLoaded = false;
  final userCourses = <Widget>[];
  final createdCourses = <Widget>[];

  void reloadPage(Course course, String requestType) async {
    if (requestType == 'create') {
      await createCourse(course);
    } else if (requestType == 'update') {
      await patchUpdateCourseInfo(course);
    } else if (requestType == 'delete') {
      await deleteCourse(course.id);
    }
    //TODO: Repair page reload.
    setState(() {
      _isFutureLoaded = false;
      userCourses.clear();
      createdCourses.clear();
      _futureUserCourses = getUserCourses();
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: coursesTabs.length);
    _futureUserCourses = getUserCourses();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: coursesTabs,
        ),
      ),
      body: FutureBuilder(
        future: _futureUserCourses,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (!_isFutureLoaded) {
              _isFutureLoaded = true;
              for (Course course in snapshot.data.userCourses) {
                userCourses.add(CourseCard(course, 'added'));
              }
              for (Course course in snapshot.data.createdCourses) {
                createdCourses.add(
                    CourseCard(
                      course,
                      'created',
                      userCoursesPageUpdate: reloadPage,
                    )
                );
              }
            }
            return userCoursesPageTabBarView();
          } else if (snapshot.hasError) {
            return Center(
                child: Text("${snapshot.error}")
            );
          }
          return Center(
              child: CircularProgressIndicator()
          );

        },
      ),
    );
  }

  Widget userCoursesPageTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(userCourses),
            ),
          ],
        ),
        //TODO: Replace with API requests
        CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.all(8.0),
              sliver: SliverToBoxAdapter(
                child: RaisedButton(
                  child: Text('+ Create Course'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            CourseCreationPage(reloadPage))
                    );
                  },
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(createdCourses),
            ),
          ],
        ),
      ],
    );
  }
}
