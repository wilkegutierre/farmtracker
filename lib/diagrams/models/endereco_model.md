# EnderecoModel

## Descrição
Modelo de domínio que representa um endereço associado a um cliente.

## Estrutura

```mermaid
classDiagram
    class EnderecoModel {
        +String uuid
        +String logradouro
        +String bairro
        +String cidade
        +String uf
        +String cep
        +int numero
        +String complemento
        +int principal
        +String pessoa
        +toJson() Map~String, dynamic~
        +fromJson() EnderecoModel
        +copyWith() EnderecoModel
    }
```

## Relacionamentos

### Composição
- `ClienteModel` "1" *-- "0..*" `EnderecoModel` : possui endereços

## Páginas que Usam
- `CadastroClientePage` - Cria/edita endereço

## Observações
- Implementa `EquatableMixin` para comparação de igualdade
- Campo `principal` indica se é o endereço principal do cliente
- Campo `pessoa` referencia o UUID do cliente
- Serialização JSON via `json_annotation`

