# Diagramas UML - FarmTracker

Análise realizada em: 2025-01-27

Este diretório contém diagramas UML de classes organizados por categoria, representando todos os objetos de tela (Pages), ViewModels e Models encontrados no diretório `lib/views`.

## Estrutura

```
diagrams/
├── README.md (este arquivo)
├── pages/                    # Páginas (Views)
│   ├── dashboard_page.md
│   ├── relacao_cliente_page.md
│   ├── cadastro_cliente_page.md
│   ├── cultura_page.md
│   ├── projeto_page.md
│   ├── lote_page.md
│   ├── appointment_page.md
│   ├── execute_appointment_page.md
│   └── client_appointment_page.md
├── viewmodels/               # ViewModels
│   ├── cliente_viewmodel.md
│   ├── projeto_viewmodel.md
│   ├── cultura_viewmodel.md
│   ├── lote_viewmodel.md
│   ├── endereco_viewmodel.md
│   ├── agenda_viewmodel.md
│   └── usuario_viewmodel.md
├── models/                   # Models de Domínio
│   ├── cliente_model.md
│   ├── endereco_model.md
│   ├── projeto_model.md
│   ├── lote_model.md
│   ├── cultura_model.md
│   ├── lote_cultura_model.md
│   ├── agenda_model.md
│   ├── cliente_cultura_model.md
│   └── usuario_model.md
└── auxiliary/                # Classes Auxiliares
    ├── cultura_item.md
    └── pest_lot_crop_info.md
```

## Páginas (9 total)

1. **[DashboardPage](pages/dashboard_page.md)** - Dashboard principal com calendário e compromissos
2. **[RelacaoClientePage](pages/relacao_cliente_page.md)** - Lista de clientes
3. **[CadastroClientePage](pages/cadastro_cliente_page.md)** - Cadastro/edição de clientes
4. **[CulturaPage](pages/cultura_page.md)** - Gerenciamento de culturas
5. **[ProjetoPage](pages/projeto_page.md)** - Gerenciamento de projetos
6. **[LotePage](pages/lote_page.md)** - Gerenciamento de lotes
7. **[AppointmentPage](pages/appointment_page.md)** - Criação de agendamentos
8. **[ExecuteAppointmentPage](pages/execute_appointment_page.md)** - Execução/completar visita
9. **[ClientAppointmentPage](pages/client_appointment_page.md)** - Seleção de cliente para agendamento

## ViewModels (7 total)

1. **[ClienteViewmodel](viewmodels/cliente_viewmodel.md)** - Gerencia clientes
2. **[ProjetoViewmodel](viewmodels/projeto_viewmodel.md)** - Gerencia projetos
3. **[CulturaViewmodel](viewmodels/cultura_viewmodel.md)** - Gerencia culturas
4. **[LoteViewmodel](viewmodels/lote_viewmodel.md)** - Gerencia lotes
5. **[EnderecoViewmodel](viewmodels/endereco_viewmodel.md)** - Gerencia endereços
6. **[AgendaViewmodel](viewmodels/agenda_viewmodel.md)** - Gerencia agendamentos
7. **[UsuarioViewmodel](viewmodels/usuario_viewmodel.md)** - Gerencia usuários

## Models (9 total)

1. **[ClienteModel](models/cliente_model.md)** - Modelo de cliente
2. **[EnderecoModel](models/endereco_model.md)** - Modelo de endereço
3. **[ProjetoModel](models/projeto_model.md)** - Modelo de projeto
4. **[LoteModel](models/lote_model.md)** - Modelo de lote
5. **[CulturaModel](models/cultura_model.md)** - Modelo de cultura
6. **[LoteCulturaModel](models/lote_cultura_model.md)** - Relacionamento lote-cultura
7. **[AgendaModel](models/agenda_model.md)** - Modelo de agendamento
8. **[ClienteCulturaModel](models/cliente_cultura_model.md)** - Relacionamento cliente-cultura
9. **[UsuarioModel](models/usuario_model.md)** - Modelo de usuário

## Classes Auxiliares (2 total)

1. **[CulturaItem](auxiliary/cultura_item.md)** - Usado em CadastroClientePage
2. **[PestLotCropInfo](auxiliary/pest_lot_crop_info.md)** - Usado em ExecuteAppointmentPage

## Fluxos de Navegação Principais

### Fluxo 1: Criar Agendamento
```
DashboardPage 
  → ClientAppointmentPage 
    → AppointmentPage 
      → DashboardPage
```

### Fluxo 2: Executar Visita
```
DashboardPage 
  → ExecuteAppointmentPage 
    → DashboardPage
```

### Fluxo 3: Cadastrar Cliente
```
RelacaoClientePage 
  → CadastroClientePage 
    → CulturaPage 
      → CadastroClientePage
```

### Fluxo 4: Gerenciar Projeto
```
ProjetoPage 
  → LotePage 
    → CulturaPage
```

## Relacionamentos Principais

### Hierarquia de Dados
```
ClienteModel
  ├── EnderecoModel (1..*)
  └── ProjetoModel (0..*)
        └── LoteModel (0..*)
              └── LoteCulturaModel (0..*)
                    └── CulturaModel
```

### Agendamentos
```
AgendaModel
  ├── UsuarioModel
  └── ClienteModel
```

## Legenda de Relacionamentos

- `-->` : Relacionamento de uso/dependência direta
- `..>` : Relacionamento implícito (uso indireto através de dados)
- `*--` : Composição (1 para muitos)
- `o--` : Agregação (1 para muitos)

## Observações Importantes

### Integração com ViewModels

- **ProjetoPage** é a única página que usa ViewModels diretamente
- As demais páginas trabalham com dados estáticos ou mockados
- **Recomendação**: Integrar todas as páginas com seus respectivos ViewModels

### Dados Mockados

As seguintes páginas usam dados mockados/estáticos:
- `DashboardPage` - usa `mockAgendaList`
- `RelacaoClientePage` - lista estática de clientes
- `ClientAppointmentPage` - lista estática de clientes e projetos
- `CulturaPage` - lista estática de culturas
- `LotePage` - lista estática de lotes

### Campos Explícitos vs Implícitos

Cada arquivo de página documenta:
- **Campos Explícitos**: Campos declarados diretamente na classe
- **Campos Implícitos**: Models e dados referenciados indiretamente

## Como Usar

1. Para entender uma página específica, consulte o arquivo correspondente em `pages/`
2. Para entender um ViewModel, consulte o arquivo correspondente em `viewmodels/`
3. Para entender um Model, consulte o arquivo correspondente em `models/`
4. Para ver relacionamentos gerais, consulte este README

Todos os diagramas usam Mermaid e podem ser visualizados em:
- GitHub/GitLab (renderiza automaticamente)
- VS Code com extensão Mermaid
- Ferramentas online como [mermaid.live](https://mermaid.live)

