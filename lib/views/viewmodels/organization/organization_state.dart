import 'package:equatable/equatable.dart';
import 'package:farmtracker/databases/models/response/organization_response_model.dart';

sealed class OrganizationState extends Equatable {
  const OrganizationState();

  @override
  List<Object?> get props => [];
}

final class OrganizationInitial extends OrganizationState {
  const OrganizationInitial();
}

final class OrganizationLoading extends OrganizationState {
  const OrganizationLoading();
}

final class OrganizationListLoaded extends OrganizationState {
  final List<OrganizationResponseModel> organizations;

  const OrganizationListLoaded(this.organizations);

  @override
  List<Object?> get props => [organizations];
}

final class OrganizationLoaded extends OrganizationState {
  final OrganizationResponseModel organization;

  const OrganizationLoaded(this.organization);

  @override
  List<Object?> get props => [organization];
}

final class OrganizationGravadoSucesso extends OrganizationState {
  const OrganizationGravadoSucesso();
}

final class OrganizationAlteradoSucesso extends OrganizationState {
  const OrganizationAlteradoSucesso();
}

final class OrganizationErro extends OrganizationState {
  final String mensagem;

  const OrganizationErro(this.mensagem);

  @override
  List<Object?> get props => [mensagem];
}
