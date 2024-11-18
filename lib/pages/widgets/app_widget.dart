import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/blocs/task/task_bloc.dart';
import 'package:task_management_app/pages/task_pages/add_task_page.dart';

import '../../blocs/home_page_navigation/home_page_navigation_bloc.dart';
import '../../models/task_model.dart';

part 'CustomDateTime.dart';
part 'CustomTextField.dart';
part 'RepeatOption.dart';
part 'app_bottom_navigation_bar.dart';
part 'app_floating_action_button.dart';
// part 'app_model_bottom_sheet.dart';
part 'app_task_item.dart';
part 'app_text_field.dart';
