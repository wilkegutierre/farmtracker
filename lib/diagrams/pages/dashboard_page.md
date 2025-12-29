# DashboardPage

## Descrição
Página principal do aplicativo que exibe um calendário com compromissos agendados e permite navegação para outras funcionalidades.

## Campos Explícitos

```mermaid
classDiagram
    class DashboardPage {
        -DateTime? _selectedDate
        -DateTime _currentMonth
        -DateTime _today
        -Set~int~ _eventDates
        -Set~int~ _overdueDates
        +build() Widget
        -_buildCalendarSection() Widget
        -_buildAppointmentsSection() Widget
        -_buildDrawer() Widget
        -_handleFloatingActionButton() void
        -_getAgendaMOck(DateTime?) List~AgendaResponseModel~
        -_getDateKey(DateTime) String
        -_isDifferentMonth() bool
        -_navigateToToday() void
    }
```

## Campos Implícitos
- `AgendaResponseModel` - Lista de compromissos exibidos no calendário
- `ClienteModel` - Referenciado através dos compromissos da agenda

## Relacionamentos

### Navegação
- Navega para: `ClientAppointmentPage` (ao clicar no FAB com data selecionada)
- Navega para: `RelacaoClientePage` (via drawer menu)
- Navega para: `ExecuteAppointmentPage` (ao clicar em um compromisso)

### Dependências
- Usa: `AgendaResponseModel` (mock de dados)
- Referencia: `ClienteModel` (via agenda)

## Observações
- A página usa dados mockados (`mockAgendaList`) para exibir os compromissos
- O calendário permite seleção de datas e exibe indicadores visuais para datas com eventos
- Compromissos são filtrados por data selecionada

