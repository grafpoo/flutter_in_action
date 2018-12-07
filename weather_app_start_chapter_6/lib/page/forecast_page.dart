import 'package:flutter/material.dart';
import 'package:shared_lib/weather_app.dart';
import 'package:shared_lib/date_utils.dart';
import 'package:weather_app_start_chapter_6/blocs/forecast_bloc.dart';
import 'package:weather_app_start_chapter_6/styles.dart';
import 'package:weather_app_start_chapter_6/utils/flutter_ui_utils.dart';
import 'package:weather_app_start_chapter_6/utils/forecast_animation_utils.dart'
    as utils;
import 'package:weather_app_start_chapter_6/widget/clouds_background.dart';
import 'package:weather_app_start_chapter_6/widget/forecast_table.dart';
import 'package:weather_app_start_chapter_6/widget/sun_background.dart';
import 'package:weather_app_start_chapter_6/widget/time_picker_row.dart';

class ForecastPage extends StatefulWidget {
  final PopupMenuButton citiesMenu;
  final Widget settingsButton;
  final AppSettings settings;

  const ForecastPage({
    Key key,
    this.citiesMenu,
    this.settingsButton,
    @required this.settings,
  }) : super(key: key);

  @override
  _ForecastPageState createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage>
    with TickerProviderStateMixin {
  TabController _tabController;
  int activeTabIndex;
  ForecastBloc _bloc;

  _ForecastPageState();

  @override
  void initState() {
    super.initState();
    _render();
  }

  @override
  void didUpdateWidget(ForecastPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _render();
  }

  void _render() {
    _bloc = new ForecastBloc(widget.settings.selectedCity);
    var startTime = _bloc.selectedHourlyTemperature.dateTime.hour;
    var startTabIndex = utils.hours.indexOf(startTime);
    _tabController = TabController(
      length: utils.hours.length,
      vsync: this,
      initialIndex: startTabIndex,
    );
    _tabController.addListener(handleTabChange);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void handleTabChange() {
    if (_tabController.indexIsChanging) return;
    setState(() {
      activeTabIndex = _tabController.index;
    });
  }

  List<String> get _humanReadableHours {
    return utils.hours.map((hour) => '$hour:00').toList();
  }

  String get _weatherDescription {
    var day =
        DateUtils.weekdays[_bloc.selectedHourlyTemperature.dateTime.weekday];
    var description = _bloc.selectedHourlyTemperature.description.toString();
    return "$day. ${description.replaceFirst(description[0], description[0].toUpperCase())}.";
  }

  String get _currentTemp {
    var unit = utils.temperatureLabels[widget.settings.selectedTemperature];
    var temp = _bloc.selectedHourlyTemperature.temperature.current;

    if (widget.settings.selectedTemperature == TemperatureUnit.fahrenheit) {
      temp = Temperature.celsiusToFahrenheit(temp);
    }
    return '$temp $unit';
  }

  bool get isRaining =>
      _bloc.selectedHourlyTemperature.description == WeatherDescription.rain;

  @override
  Widget build(BuildContext context) {
    var background = Sun();

    var forecastContent = ForecastTableView(
      settings: widget.settings,
      forecast: _bloc.forecast,
    );

    var mainContent = Container(
      padding: EdgeInsets.only(bottom: 24.0),
      child: Column(
        children: <Widget>[
          Text(
            _weatherDescription,
            style: Theme.of(context).textTheme.headline,
          ),
          Text(
            _currentTemp,
            style: Theme.of(context).textTheme.display3,
          ),
        ],
      ),
    );

    var timePickerRow = TimePickerRow(
      controller: _tabController,
      tabItems: _humanReadableHours,
    );

    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          title: Text(widget.settings.selectedCity,
              style: Theme.of(context)
                  .textTheme
                  .headline
                  .copyWith(color: AppColor.textColorLight)),
          elevation: 0.0,
          bottomOpacity: 0.0,
          actions: <Widget>[widget.settingsButton],
          leading: widget.citiesMenu,
        ),
        preferredSize: Size.fromHeight(appBarHeight(context)),
      ),
      body: new Stack(
        children: <Widget>[
          Positioned(
            top: 100.0,
            bottom: 100.0,
            child: background,
          ),
          Positioned(
            top: 200.0,
            child: Clouds(),
          ),
          Column(
            verticalDirection: VerticalDirection.up,
            children: <Widget>[
              forecastContent,
              mainContent,
              Flexible(child: timePickerRow),
            ],
          ),
        ],
      ),
    );
  }
}
