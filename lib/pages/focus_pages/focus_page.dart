import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:task_management_app/blocs/focus_mode/focus_mode_bloc.dart';

class FocusPage extends StatelessWidget {
  const FocusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<FocusModeBloc, FocusModeState>(
      listener: (BuildContext context, FocusModeState state) {
        if (state is FocusModeCompletedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Hoàn thành"),
            ),
          );
        }
      },
      child: BlocBuilder<FocusModeBloc, FocusModeState>(
        buildWhen: (prev, state) => prev.runtimeType != state.runtimeType,
        builder: (BuildContext context, FocusModeState state) {
          return Scaffold(
            backgroundColor: Color(0xFF242424),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Tập trung",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 40),
                  CircularPercentIndicator(
                    radius: 180,
                    lineWidth: 8,
                    percent: context.select(
                      (FocusModeBloc bloc) => bloc.state.percent.toDouble(),
                    ),
                    center: Text(
                      context.select(
                        (FocusModeBloc bloc) => bloc.state.timeStr,
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                    progressColor: Colors.blue,
                  ),
                  const SizedBox(height: 40),
                  // state.isRunning ?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (state is! FocusModeInitialState) ...[
                        FloatingActionButton(
                          shape: CircleBorder(),
                          backgroundColor: Colors.blue,
                          elevation: 0,
                          highlightElevation: 0,
                          child: Icon(
                            Icons.restart_alt,
                            size: 40,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            context
                                .read<FocusModeBloc>()
                                .add(FocusModeResetEvent());
                          },
                        ),
                        const SizedBox(width: 20),
                      ],
                      // const SizedBox(width: 20),
                      FloatingActionButton(
                        shape: CircleBorder(),
                        backgroundColor: Colors.blue,
                        elevation: 0,
                        highlightElevation: 0,
                        child: state.isRunning
                            ? const Icon(
                                Icons.pause,
                                size: 40,
                                color: Colors.white,
                              )
                            : const Icon(
                                Icons.play_arrow,
                                size: 40,
                                color: Colors.white,
                              ),
                        onPressed: () {
                          state.isRunning
                              ? context
                                  .read<FocusModeBloc>()
                                  .add(FocusModePauseEvent())
                              : context
                                  .read<FocusModeBloc>()
                                  .add(FocusModeStartEvent());
                        },
                      ),
                    ],
                  )
                  // : ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.blue,
                  //       padding: EdgeInsets.symmetric(
                  //         horizontal: 40,
                  //         vertical: 20,
                  //       ),
                  //     ),
                  //     onPressed: () {
                  //       context
                  //           .read<FocusModeBloc>()
                  //           .add(FocusModeStartEvent());
                  //     },
                  //     child: Text(
                  //       "Bắt đầu",
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
