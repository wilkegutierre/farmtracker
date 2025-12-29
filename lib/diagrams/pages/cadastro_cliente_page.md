# CadastroClientePage

## Descrição
Página para cadastro e edição de clientes, incluindo dados pessoais, contato, endereço e projetos/culturas.

## Campos Explícitos

```mermaid
classDiagram
    class CadastroClientePage {
        -GlobalKey~FormState~ _formKey
        -TextEditingController _nomeController
        -TextEditingController _proprietarioController
        -TextEditingController _responsavelTecnicoController
        -TextEditingController _emailController
        -TextEditingController _telefoneController
        -TextEditingController _ruaController
        -TextEditingController _numeroController
        -TextEditingController _bairroController
        -TextEditingController _cepController
        -TextEditingController _cidadeController
        -TextEditingController _estadoController
        -TextEditingController _complementoController
        -TextEditingController _referenciaController
        -List~CulturaItem~ _culturas
        +build() Widget
        -_onSalvar() void
        -_onAdicionarCultura() void
        -_buildTitulo() Widget
        -_buildSecaoTitulo() Widget
        -_buildField() Widget
        -_buildCulturasBox() Widget
    }
    
    class CulturaItem {
        +String projeto
        +String lote
        +double tamanhoHectare
        +String cultura
    }
    
    CadastroClientePage --> CulturaItem : gerencia
```

## Campos Implícitos
- `ClienteModel` - Modelo de cliente criado/editado
- `EnderecoModel` - Modelo de endereço associado ao cliente
- `CulturaItem` - Lista de projetos/culturas do cliente

## Relacionamentos

### Navegação
- Navega para: `CulturaPage` (via FAB para adicionar cultura)

### Dependências
- Cria/Edita: `ClienteModel`
- Cria/Edita: `EnderecoModel`
- Gerencia: `CulturaItem` (lista de projetos/culturas)

## Observações
- Formulário completo com validação de campos obrigatórios
- Permite adicionar múltiplas culturas/projetos
- Deve ser integrada com `ClienteViewmodel` e `EnderecoViewmodel` para persistência

