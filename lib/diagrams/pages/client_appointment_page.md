# ClientAppointmentPage

## Descrição
Página para seleção de cliente e projeto para criação de um novo agendamento, exibindo lista de clientes com seus projetos.

## Campos Explícitos

```mermaid
classDiagram
    class ClientAppointmentPage {
        -TextEditingController _searchController
        -String _query
        -List~_Client~ _clients
        +build() Widget
        -_buildSearchField() Widget
        -_showProjectsDialog() Future~void~
    }
    
    class _Client {
        +String name
        +String address
        +List~_Project~ projects
    }
    
    class _Project {
        +String title
        +String batch
        +double area
        +Color batchColor
    }
    
    class _ClientCard {
        +_Client client
        +VoidCallback onTap
        +build() Widget
    }
    
    class _ProjectsDialog {
        +_Client client
        +build() Widget
    }
    
    class _ProjectCard {
        +_Project project
        +build() Widget
    }
    
    ClientAppointmentPage --> _Client : contém
    ClientAppointmentPage --> _ClientCard : usa
    ClientAppointmentPage --> _ProjectsDialog : usa
    _Client --> _Project : possui
    _ProjectsDialog --> _ProjectCard : usa
```

## Campos Implícitos
- `ClienteModel` - Lista de clientes exibidos (atualmente usando dados estáticos)
- `ProjetoModel` - Projetos associados aos clientes (via projetos do cliente)

## Relacionamentos

### Navegação
- Recebe navegação de: `DashboardPage` (via FAB)
- Navega para: `AppointmentPage` (ao selecionar cliente e projeto)

### Dependências
- Lista/Seleciona: `ClienteModel`
- Referencia: `ProjetoModel` (via projetos do cliente)

## Observações
- Atualmente usa lista estática de clientes e projetos
- Exibe diálogo modal para seleção de projeto do cliente
- Deve ser integrada com `ClienteViewmodel` para buscar dados reais
- Permite busca por nome ou endereço do cliente

