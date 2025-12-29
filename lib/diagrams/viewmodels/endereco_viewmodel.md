# EnderecoViewmodel

## Descrição
ViewModel responsável por gerenciar o estado e operações relacionadas a endereços.

## Estrutura

```mermaid
classDiagram
    class EnderecoViewmodel {
        +EnderecoData data
        +buscarPorCliente(String clienteId) Future~void~
        +adicionar() Future~void~
    }
    
    class EnderecoData {
        +List~EnderecoModel~? enderecos
        +EnderecoModel? endereco
        +bool isLoading
    }
    
    EnderecoViewmodel --> EnderecoData : contém
```

## Relacionamentos

### Models Gerenciados
- `EnderecoModel` - Gerencia operações CRUD
- `ClienteModel` - Referencia cliente ao qual o endereço pertence

### Páginas que Usam
- Nenhuma página usa diretamente ainda (deve ser integrado com `CadastroClientePage`)

## Observações
- Estende `ChangeNotifier` para notificar mudanças de estado
- Operações são filtradas por cliente (`buscarPorCliente`)
- Deve ser injetado via `Modular.get<EnderecoViewmodel>()`
- Precisa ser integrado com `CadastroClientePage` para persistência de endereços

