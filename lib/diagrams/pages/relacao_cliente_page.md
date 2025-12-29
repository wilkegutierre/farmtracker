# RelacaoClientePage

## Descrição
Página que exibe uma lista de clientes com funcionalidade de busca e navegação para cadastro/edição.

## Campos Explícitos

```mermaid
classDiagram
    class RelacaoClientePage {
        -TextEditingController _searchController
        -String _query
        -List~_Client~ _clients
        +build() Widget
        -_buildSearchField() Widget
    }
    
    class _Client {
        +String name
        +String address
    }
    
    class _ClientCard {
        +_Client client
        +build() Widget
    }
    
    RelacaoClientePage --> _Client : contém
    RelacaoClientePage --> _ClientCard : usa
```

## Campos Implícitos
- `ClienteModel` - Lista de clientes exibidos (atualmente usando dados estáticos)

## Relacionamentos

### Navegação
- Navega para: `CadastroClientePage` (ao clicar no FAB ou em um cliente)

### Dependências
- Referencia: `ClienteModel` (lista/exibe)

## Observações
- Atualmente usa uma lista estática de clientes (`_clients`)
- Deve ser integrada com `ClienteViewmodel` para buscar dados reais
- Permite busca por nome ou endereço do cliente

