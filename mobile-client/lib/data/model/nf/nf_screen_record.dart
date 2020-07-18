import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:quantifico/data/model/nf/nf.dart';

class NfScreenRecord extends Equatable {
  final Color color;
  final Nf nf;

  const NfScreenRecord({
    this.color,
    this.nf,
  });

  @override
  List<Object> get props => [
        color,
        nf,
      ];

  @override
  String toString() {
    return 'NfScreenRecord{color: $color, nf: $nf';
  }
}
