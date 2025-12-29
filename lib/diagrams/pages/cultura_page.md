# CulturaPage

## Descrição
Página para gerenciamento de culturas, permitindo adicionar, editar e listar culturas cadastradas.

## Campos Explícitos

```mermaid
classDiagram
    class CulturaPage {
        -TextEditingController _nomeController
        -TextEditingController _descricaoController
        -List~_CulturaItem~ _culturas
        +build() Widget
        -_adicionarCultura() void
        -_buildField() Widget
    }
    
    class _CulturaItem {
        +String nome
        +String descricao
    }
    
    class _CulturaCard {
        +String nome
        +String descricao
        +VoidCallback? onEdit
        +VoidCallback? onDelete
        +build() Widget
    }
    
    CulturaPage --> _CulturaItem : contém
    CulturaPage --> _CulturaCard : usa
```

## Campos Implícitos
- `CulturaModel` - Modelo de cultura criado/editado

## Relacionamentos

### Navegação
- Retorna para: `CadastroClientePage` (via FAB de salvar)

### Dependências
- Cria/Edita: `CulturaModel`

## Observações
- Atualmente usa lista estática de culturas
- Deve ser integrada com `CulturaViewmodel` para persistência
- Permite edição inline dos itens da lista

