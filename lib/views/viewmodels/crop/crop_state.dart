import 'package:equatable/equatable.dart';
import 'package:farmtracker/domains/models/crop_model.dart';

sealed class CropState extends Equatable {
  const CropState();

  @override
  List<Object?> get props => [];
}

final class CropInitial extends CropState {
  const CropInitial();
}

final class CropLoading extends CropState {
  const CropLoading();
}

final class CropListLoaded extends CropState {
  final List<CropModel> crops;

  const CropListLoaded(this.crops);

  @override
  List<Object?> get props => [crops];
}

final class CropLoaded extends CropState {
  final CropModel crop;

  const CropLoaded(this.crop);

  @override
  List<Object?> get props => [crop];
}

final class CropGravadoSucesso extends CropState {
  const CropGravadoSucesso();
}

final class CropAlteradoSucesso extends CropState {
  const CropAlteradoSucesso();
}

final class CropErro extends CropState {
  final String mensagem;

  const CropErro(this.mensagem);

  @override
  List<Object?> get props => [mensagem];
}
