# AgendaModel

## Descrição
Modelo de domínio que representa um agendamento/compromisso de visita.

## Estrutura

```mermaid
classDiagram
    class AgendaModel {
        +String id
        +String usuario
        +String cliente
        +String dataHoraCriacao
        +String descricao
        +String motivo
        +int situacao
        +String observacao
        +toJson() Map~String, dynamic~
        +fromJson() AgendaModel
        +copyWith() AgendaModel
    }
    
    class AgendaResponseModel {
        +String uuid
        +int dataCriacao
        +int dataAgenda
        +ClienteResponseModel cliente
        +String descricao
        +MotivoAgendaResponseModel motivo
        +int situacao
        +String? kmAtendimento
        +String? observacao
    }
    
    AgendaModel ..> AgendaResponseModel : relacionado
```

## Relacionamentos

### Referências
- `AgendaModel` --> `UsuarioModel` : referencia (via campo usuario)
- `AgendaModel` --> `ClienteModel` : referencia (via campo cliente)

## Páginas que Usam
- `DashboardPage` - Exibe compromissos (via AgendaResponseModel)
- `AppointmentPage` - Cria agendamento
- `ExecuteAppointmentPage` - Atualiza/executa agendamento

## Observações
- Implementa `EquatableMixin` para comparação de igualdade
- Campo `situacao` representa o status do agendamento (enum)
- `AgendaResponseModel` é usado para resposta da API com dados aninhados
- Serialização JSON via `json_annotation`

