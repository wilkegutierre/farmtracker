import 'package:farmtracker/databases/local/repositories/organization_local_repository.dart';
import 'package:farmtracker/databases/models/response/organization_response_model.dart';
import 'package:farmtracker/views/cubits/organization/organization_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrganizationCubit extends Cubit<OrganizationState> {
  final OrganizationLocalRepository _organizationLocalRepository;

  OrganizationCubit(this._organizationLocalRepository) : super(const OrganizationInitial());

  Future<void> carregarOrganizations() async {
    emit(const OrganizationLoading());

    final result = await _organizationLocalRepository.organizations();
    result.fold(
      (organizations) => emit(OrganizationListLoaded(organizations)),
      (_) => emit(const OrganizationErro('Falha ao carregar organizations.')),
    );
  }

  Future<void> obterPorAddressId(String addressId) async {
    emit(const OrganizationLoading());

    final result = await _organizationLocalRepository.obterPorAddressId(addressId);
    result.fold(
      (organizations) => emit(OrganizationListLoaded(organizations)),
      (_) => emit(const OrganizationErro('Falha ao buscar organizations por address_id.')),
    );
  }

  Future<void> obterPorId(String id) async {
    emit(const OrganizationLoading());

    final result = await _organizationLocalRepository.obterPorId(id);
    result.fold(
      (organization) => emit(OrganizationLoaded(organization)),
      (_) => emit(const OrganizationErro('Organization não encontrada.')),
    );
  }

  Future<void> gravar(OrganizationResponseModel organization) async {
    emit(const OrganizationLoading());

    final result = await _organizationLocalRepository.gravar(organization);
    result.fold((success) {
      if (success) {
        emit(const OrganizationGravadoSucesso());
      } else {
        emit(const OrganizationErro('Falha ao gravar organization.'));
      }
    }, (_) => emit(const OrganizationErro('Falha ao gravar organization.')));
  }

  Future<void> alterar(OrganizationResponseModel organization) async {
    emit(const OrganizationLoading());

    final result = await _organizationLocalRepository.alterar(organization);
    result.fold((success) {
      if (success) {
        emit(const OrganizationAlteradoSucesso());
      } else {
        emit(const OrganizationErro('Falha ao alterar organization.'));
      }
    }, (_) => emit(const OrganizationErro('Falha ao alterar organization.')));
  }
}
