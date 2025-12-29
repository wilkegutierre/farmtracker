# ClienteViewmodel

## Descrição
ViewModel responsável por gerenciar o estado e operações relacionadas a clientes.

## Estrutura

```mermaid
classDiagram
    class ClienteViewmodel {
        +ClienteData data
        +buscarTodos() Future~void~
        +adicionar() Future~void~
        +alterar() Future~void~
        +remover() Future~void~
        +changeState() void
    }
    
    class ClienteData {
        +ClienteModel? cliente
        +ClienteCulturaModel? clienteCultura
        +ClienteModel? clienteSelecinado
        +EnderecoModel? enderecoClienteSelecinado
        +bool isLoading
        +List~ClienteModel~ clientes
        +List~ClienteCulturaModel~ clienteCulturas
        +List~ClienteCulturaRelacaoModel~ clienteCulturaRelacao
        +Object? state
        +String? projeto
        +String? lote
        +String? titleAppBar
        +String? subtitleAppBar
    }
    
    ClienteViewmodel --> ClienteData : contém
```

## Relacionamentos

### Models Gerenciados
- `ClienteModel` - Gerencia operações CRUD
- `EnderecoModel` - Gerencia endereços dos clientes
- `ClienteCulturaModel` - Gerencia relacionamento cliente-cultura

### Páginas que Usam
- `ProjetoPage` - Usa para referenciar cliente selecionado

## Observações
- Estende `ChangeNotifier` para notificar mudanças de estado
- Gerencia estado complexo através de `ClienteData`
- Deve ser injetado via `Modular.get<ClienteViewmodel>()`

