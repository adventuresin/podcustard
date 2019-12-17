library problem;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:podcustard/redux/app_state.dart';
import 'package:podcustard/redux/serializers.dart';

part 'problem.g.dart';

abstract class Problem implements Built<Problem, ProblemBuilder> {
  ProblemTypeEnum get type;
  String get message;
  @nullable
  StackTrace get trace;
  @nullable
  AppState get state;
  @nullable
  Map<String, dynamic> get info;

  Problem._();

  factory Problem([void updates(ProblemBuilder b)]) = _$Problem;

  Object toJson() => serializers.serializeWith(Problem.serializer, this);

  static Problem fromJson(String jsonString) =>
      serializers.deserializeWith(Problem.serializer, json.decode(jsonString));

  static Serializer<Problem> get serializer => _$problemSerializer;
}

class ProblemTypeEnum extends EnumClass {
  static Serializer<ProblemTypeEnum> get serializer =>
      _$problemTypeEnumSerializer;

  static const ProblemTypeEnum yes = _$yes;
  static const ProblemTypeEnum no = _$no;

  const ProblemTypeEnum._(String name) : super(name);

  static BuiltSet<ProblemTypeEnum> get values => _$values;
  static ProblemTypeEnum valueOf(String name) => _$valueOf(name);
}
