# ExecuteAppointmentPage

## Descrição
Página para completar/executar uma visita agendada, permitindo registrar conclusão, motivo, pragas identificadas e observações.

## Campos Explícitos

```mermaid
classDiagram
    class ExecuteAppointmentPage {
        +String? clientName
        -bool _appointmentCompleted
        -bool _hadPests
        -String? _selectedReason
        -String? _selectedSubItem
        -TextEditingController _observationController
        -List~PestLotCropInfo~ _pestLotCropList
        -List~String~ _reasons
        -List~String~ _subItems
        -List~String~ _pests
        -List~String~ _lots
        -List~String~ _crops
        +build() Widget
        -_showPestDialog() void
        -_buildLabel() Widget
        -_buildDropdown() Widget
        -_buildObservationField() Widget
        -_buildDialogDropdown() Widget
        -_buildPestLotCropBox() Widget
    }
    
    class PestLotCropInfo {
        +String pest
        +String lot
        +String crop
        +double hectares
    }
    
    ExecuteAppointmentPage --> PestLotCropInfo : gerencia
```

## Campos Implícitos
- `AgendaModel` - Modelo de agendamento atualizado/executado
- `ClienteModel` - Referenciado via parâmetro (`clientName`)
- `LoteModel` - Referenciado via pragas identificadas
- `CulturaModel` - Referenciado via pragas identificadas

## Relacionamentos

### Navegação
- Recebe dados de: `DashboardPage` (via navegação com argumentos)
- Retorna para: `DashboardPage` (após completar)

### Dependências
- Atualiza/Executa: `AgendaModel`
- Referencia: `ClienteModel` (via parâmetros)
- Gerencia: `PestLotCropInfo` (lista de pragas identificadas)
- Referencia: `LoteModel` (via pragas)
- Referencia: `CulturaModel` (via pragas)

## Observações
- Permite marcar visita como concluída ou não realizada
- Permite adicionar múltiplas pragas com informações de lote, cultura e hectares
- Motivos de visita pré-definidos: Monitoramento, Tratamento, Consulta, Inspeção
- Deve ser integrada com `AgendaViewmodel` para atualização do agendamento

