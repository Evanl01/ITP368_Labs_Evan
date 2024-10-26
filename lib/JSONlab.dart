import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'JSONlabCubit.dart';

void main() {
  runApp(JSONlab());
}

class JSONlab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JSONlabCubit()..fetchLaunches(),
      child: MaterialApp(
        title: 'SpaceX Launches',
        home: JSONlabPage(),
      ),
    );
  }
}

class JSONlabPage extends StatefulWidget {
  @override
  _JSONlabPageState createState() => _JSONlabPageState();
}

class _JSONlabPageState extends State<JSONlabPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  String _formattedStartDate = "Start date";
  String _formattedEndDate = "End date";

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          _formattedStartDate = DateFormat('d-MMM-yy').format(picked);
        } else {
          _endDate = picked;
          _formattedEndDate = DateFormat('d-MMM-yy').format(picked);
        }
      });
      if (_startDate != null && _endDate != null) {
        context.read<JSONlabCubit>().filterLaunches(_startDate!, _endDate!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SpaceX Launches')),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  child: Text(_formattedStartDate),
                  onPressed: () => _selectDate(context, true),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  child: Text(_formattedEndDate),
                  onPressed: () => _selectDate(context, false),
                ),
              ),
            ],
          ),
          Expanded(
            child: BlocBuilder<JSONlabCubit, JSONlabState>(
              builder: (context, state) {
                if (state.launches.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: state.launches.length,
                  itemBuilder: (context, index) {
                    final launch = state.launches[index];
                    return ListTile(
                      title: Text(launch['name']),
                      subtitle: Text(launch['date_utc']),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}