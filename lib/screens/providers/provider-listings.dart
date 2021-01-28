import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:provider/provider.dart';
import 'package:prozone/data-models/provider-model.dart';
import 'package:prozone/screens/providers/image-upload.dart';
import 'package:prozone/services/main-service.dart';
import 'package:prozone/utils/theme-data.dart';

class ProviderListings extends KFDrawerContent {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProviderListingsState();
  }
}

class ProviderListingsState extends State<ProviderListings>
    with CustomThemeData {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TextEditingController searchController = new TextEditingController();
  bool isLoading = false;
  String filter = '';

  initState() {
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
    getProviders();
    super.initState();
  }

  getProviders() async {
    final provider = Provider.of<MainAppProvider>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    await provider.getProviders();
    setState(() {
      isLoading = false;
    });
  }

  Widget buildProviderList(provider) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.75,
        // decoration: customBoxDecoration(),
        margin: EdgeInsets.only(top: 20),
        child: provider.allProviders.length > 0
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: provider.allProviders.length,
                itemBuilder: (context, index) {
                  final item = provider.allProviders[index];
                  return filter == null || filter == ""
                      ? providerItem(item)
                      : item.name
                                  .toLowerCase()
                                  .contains(filter.toLowerCase()) ||
                              item.state
                                  .toLowerCase()
                                  .contains(filter.toLowerCase())
                          ? providerItem(item)
                          // return empty container if it does not contain filter
                          : new Container();
                })
            : Center(child: Text('There are no providers')));
  }

  getStatusColor(status) {
    if (status == 'Active') {
      return Colors.green;
    } else if (status == 'Deleted') {
      return Colors.red;
    } else {
      return Colors.orange[700];
    }
  }

  providerItem(item) {
    return Column(
      children: <Widget>[
        ListTile(
            dense: true,
            onTap: () async {
              _providerModalBottomSheet(context, item);
            },
            leading: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: CircleAvatar(
                    child: CachedNetworkImage(
                  imageUrl: item.image,
                  imageBuilder: (context, imageProvider) => Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        // color: Color(0xff000000).withOpacity(0.23)
                        image: DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter: new ColorFilter.mode(
                          Colors.black.withOpacity(0.9), BlendMode.softLight),
                      image: NetworkImage(item.image),
                    )),
                  ),
                  placeholder: (context, url) => SizedBox(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      child: ProfileShimmer(
                          // isDarkMode: true,
                          // hasBottomBox: true,
                          )),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ))),
            // child: Text('AB')

            title: Text(
              '${item.name}',
              style: tile_title,
            ),
            subtitle: Container(
                child: Text(
              '${item.state}',
            )),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ratings(item.rating.toDouble()),
                SizedBox(height: 3),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: getStatusColor(item.activeStatus),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text('${item.activeStatus}', style: badge_style)),
              ],
            )

            // Text('${beneficiary.phoneNumber}', style: KontactTheme.subtitle,),
            ),
        Divider(thickness: 1),
      ],
    );
  }

  Widget ratings(rating) {
    return SizedBox(
        child: RatingBar.builder(
      initialRating: rating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 18.0,
      itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        print(rating);
      },
    ));
  }

  endDrawer() {
    return Drawer(child: Center(child: Text('Work In Progress')));
  }

  // provider details
  void _providerModalBottomSheet(context, singleProvider) {
    showModalBottomSheet(
      isScrollControlled: true,
      // useRootNavigator: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      )
          // BorderRadius.circular(20.0),
          ),
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.90,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            // You can wrap this Column with Padding of 8.0 for better design
            child: SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.only(
                    // left: 20,
                    // right: 20,
                    // top: 30,
                    bottom: 10,
                  ),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[providerInfo(singleProvider)])),
            ));
      },
    );
  }

  Widget providerInfo(ProviderModel singleProvider) {
    return Container(
        // padding: const EdgeInsets.only(left: 24, right: 24),
        child: InkWell(
            child: Container(

                // height: 300,
                // width: 300,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  Stack(
                    children: <Widget>[
                      ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                          child: singleProvider.image == null
                              ? Container(
                                  height: 150,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color:
                                          Color(0xff000000).withOpacity(0.23)),
                                )
                              : CachedNetworkImage(
                                  imageUrl: singleProvider.image,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height: 250,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        // color: Color(0xff000000).withOpacity(0.23)
                                        image: DecorationImage(
                                      fit: BoxFit.cover,
                                      colorFilter: new ColorFilter.mode(
                                          Colors.black.withOpacity(0.9),
                                          BlendMode.softLight),
                                      image: NetworkImage(singleProvider.image),
                                    )),
                                  ),
                                  placeholder: (context, url) => SizedBox(
                                      height: 150,
                                      width: MediaQuery.of(context).size.width,
                                      child: ProfileShimmer(
                                          // isDarkMode: true,
                                          // hasBottomBox: true,
                                          )),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                )),
                    ],
                  ),
                  Container(
                    child: Column(
                      children: [
                        ListTile(
                            title: Text('${singleProvider.name}'),
                            trailing:
                                ratings(singleProvider.rating.toDouble())),
                        ListTile(
                          title: Text('${singleProvider.description}'),
                        ),
                        ListTile(
                          title: Row(
                            children: [
                              MaterialButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  var result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              ImageUpload(singleProvider)));
                                  print('result $result');
                                  final provider = Provider.of<MainAppProvider>(
                                      context,
                                      listen: false);
                                  print('updating');
                                  await provider.getProviders();
                                },
                                child: Text('Add Image',
                                    style: TextStyle(color: Colors.white)),
                                minWidth: 100,
                                color: Colors.green[700],
                              ),
                              Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: MaterialButton(
                                    onPressed: () {},
                                    child: Text('Edit Provider',
                                        style: TextStyle(color: Colors.white)),
                                    minWidth: 100,
                                    color: Colors.blue[700],
                                  ))
                            ],
                          ),
                        ),
                        Divider(),
                        ListTile(
                            title: Text('Other Information',
                                style: TextStyle(fontWeight: FontWeight.w600))),
                        Divider(),
                        ListTile(
                            dense: true,
                            title: Text('Address'),
                            trailing: Text('${singleProvider.address}',
                                style: TextStyle(fontWeight: FontWeight.w600))),
                        Divider(),
                        ListTile(
                            dense: true,
                            title: Text('State'),
                            trailing: Text('${singleProvider.state}',
                                style: TextStyle(fontWeight: FontWeight.w600))),
                        Divider(),
                        ListTile(
                            dense: true,
                            title: Text('Provider Type'),
                            trailing: Text('${singleProvider.providerType}',
                                style: TextStyle(fontWeight: FontWeight.w600))),
                        Divider(),
                        ListTile(
                          dense: true,
                          title: Text('Active Status'),
                          trailing: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color:
                                    getStatusColor(singleProvider.activeStatus),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text('${singleProvider.activeStatus}',
                                  style: badge_style)),
                        )
                      ],
                    ),
                  ),
                ])),
            onTap: () {
              // Navigator.of(context).pushNamed(
              //     ServiceProviderClientView.routeName,
              //     arguments: hitModel);
            }));
  }

  buildSearchFormField() {
    return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        height: 45,
        child: TextField(
            controller: searchController,
            style: TextStyle(
              color: Colors.black,
            ),
            decoration: new InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(30.0),
                  ),
                  borderSide: BorderSide(color: Colors.black54, width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(30.0),
                  ),
                  borderSide: BorderSide(color: Colors.black38, width: 1.0),
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 20,
                  color: Colors.black54,
                ),
                hintText: 'Search providers',
                hintStyle: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    fontWeight: FontWeight.w600))));
  }

  Widget build(BuildContext context) {
    final provider = Provider.of<MainAppProvider>(context, listen: false);
    return Scaffold(
        key: _scaffoldKey,
        // drawer: sideDrawer(),
        endDrawer: endDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.menu, color: Colors.black87),
            onPressed: widget.onMenuPressed,
          ),
          title: Text('Our Providers', style: TextStyle(color: Colors.black87)),
          actions: [
            InkWell(
                onTap: () {
                  _scaffoldKey.currentState.openEndDrawer();
                },
                child: Icon(Icons.filter_list, color: Colors.black87))
          ],
        ),
        body: isLoading
            ? Center(
                child: SpinKitWanderingCubes(
                color: Color(0xff0047ff),
                size: 50.0,
              ))
            : SingleChildScrollView(
                child: Column(
                children: [
                  SizedBox(height: 20),
                  buildSearchFormField(),
                  buildProviderList(provider)
                ],
              )));
  }
}
