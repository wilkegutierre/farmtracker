# AppointmentPage

## Descrição
Página para criação de agendamentos de visitas, permitindo selecionar tipo de visita, data, hora e descrição.

## Campos Explícitos

```mermaid
classDiagram
    class AppointmentPage {
        +String? clientName
        +String? farmName
        +String? projectTitle
        +String? projectBatch
        +double? projectArea
        -TextEditingController _descriptionController
        -DateTime? _selectedDate
        -TimeOfDay? _selectedTime
        -String? _selectedVisitType
        -List~String~ _visitTypes
        +build() Widget
        -_selectDate() Future~void~
        -_selectTime() Future~void~
        -_formatDate() String
        -_formatTime() String
        -_buildLabel() Widget
        -_buildTextField() Widget
        -_buildDateField() Widget
        -_buildTimeField() Widget
        -_buildDropdownField() Widget
    }
```

## Campos Implícitos
- `AgendaModel` - Modelo de agendamento criado ao salvar
- `ClienteModel` - Referenciado via parâmetros (`clientName`, `farmName`)
- `ProjetoModel` - Referenciado via parâmetros (`projectTitle`, `projectBatch`, `projectArea`)

## Relacionamentos

### Navegação
- Recebe dados de: `ClientAppointmentPage` (via navegação com argumentos)
- Retorna para: `DashboardPage` (após salvar)

### Dependências
- Cria: `AgendaModel` (ao salvar)
- Referencia: `ClienteModel` (via parâmetros)
- Referencia: `ProjetoModel` (via parâmetros)

## Observações
- Recebe dados do cliente e projeto via parâmetros de navegação
- Tipos de visita pré-definidos: Monitoramento, Tratamento, Consulta, Inspeção, etc.
- Data inicial é hoje e horário padrão é 10:30 AM
- Deve ser integrada com `AgendaViewmodel` para persistência

