import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flyinsky/theme/color/colors.dart';
import 'package:flyinsky/views/chartsViews/pdfChartView.dart';
import 'package:flyinsky/blocs/charts/chart_bloc.dart';
import 'package:flyinsky/blocs/charts/chart_event.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpandedPanel extends StatefulWidget {
  final Map<String, List<Map<String, dynamic>>> groupedCharts;
  const ExpandedPanel({required this.groupedCharts});

  @override
  State<ExpandedPanel> createState() => _ExpandedPanelState();
}

class _ExpandedPanelState extends State<ExpandedPanel> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _sizeAnimations;
  late List<Animation<Offset>> _slideAnimations;
  late List<String> categories;

  @override
  void initState() {
    super.initState();
    categories = widget.groupedCharts.keys.toList();
    _controllers = [];
    _sizeAnimations = [];
    _slideAnimations = [];

    for (int i = 0; i < categories.length; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      );

      final sizeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.ease,
      ));

      final slideAnimation = Tween<Offset>(
        begin: const Offset(0, -1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.ease,
      ));

      _controllers.add(controller);
      _sizeAnimations.add(sizeAnimation);
      _slideAnimations.add(slideAnimation);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _togglePanel(int index) {
    setState(() {
      if (_controllers[index].isCompleted) {
        _controllers[index].reverse();
      } else {
        _controllers[index].forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: categories.asMap().entries.map((entry) {
        final index = entry.key;
        final category = entry.value;
        final List<Map<String, dynamic>> charts =
            widget.groupedCharts[category] ?? <Map<String, dynamic>>[];

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // header
              GestureDetector(
                onTap: () => _togglePanel(index),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorsPalette['card blue'],
                    borderRadius: BorderRadius.all(
                      Radius.circular(10)
                    ),
                  ),
                  child: Text(
                    category,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: colorsPalette['title'],
                    )
                  ),
                ),
              ),

              // Content
              ClipRect(
                child: AnimatedBuilder(
                  animation: _controllers[index],
                  builder: (context, child) {
                    return SizeTransition(
                      sizeFactor: _sizeAnimations[index],
                      child: SlideTransition(
                        position: _slideAnimations[index],
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: colorsPalette['dark blue'],
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            children: charts.map((chart) {
                              return _buildChartItem(chart);
                            }).toList(),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChartItem(Map<String, dynamic> chart) {
    return GestureDetector(
      onTap: () async {
        context.read<chartsBloc>().add(loadPdfChart(chart['chart_id'] ?? ''));
        await Future.delayed(Duration(seconds: 1));
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Pdfchartview(
              pdf_file: context.read<chartsBloc>().state.urlChart ?? '',
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorsPalette['input'],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          textAlign: TextAlign.left,
          chart['name'] ?? '',
          style: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colorsPalette['title'],
          )
        ),
      ),
    );
  }
}