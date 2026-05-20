# Product App

Aplicativo Flutter de gerenciamento de produtos com autenticação, desenvolvido como atividade prática da disciplina de Mobile.

## O que o app faz

- Exige login antes de acessar qualquer funcionalidade (autenticação via DummyJSON)
- Lista produtos consumidos da API DummyJSON
- Exibe tela de detalhes de cada produto (busca por ID na API)
- Permite criar, editar e excluir produtos
- Permite marcar produtos como favoritos (persistidos localmente)
- Exibe o nome do usuário autenticado e permite logout

## Autenticação

A autenticação utiliza a rota `POST /auth/login` da [DummyJSON](https://dummyjson.com). Após o login bem-sucedido, os dados do usuário e o token de acesso são armazenados em memória via `SessionController`. A sessão é encerrada ao fazer logout ou fechar o app.

Credenciais de teste: `emilys` / `emilyspass`

## Arquitetura

O projeto segue **Clean Architecture** dividida em três camadas principais:

```
lib/
├── core/
│   ├── errors/          # Classe Failure para erros tipados
│   └── network/         # HttpClient (wrapper do pacote http)
│
├── domain/              # Regras de negócio (sem dependências externas)
│   ├── entities/        # Product — entidade central do domínio
│   └── repositories/    # ProductRepository — contrato abstrato
│
├── data/                # Implementações de acesso a dados
│   ├── models/          # ProductModel — serialização JSON e SQLite
│   ├── datasources/     # Remote (DummyJSON) e Local (SQLite / in-memory)
│   └── repositories/    # ProductRepositoryImpl — cache offline-first
│
├── presentation/        # Interface com o usuário
│   ├── pages/           # Telas: Login, Produtos, Detalhes, Formulário
│   ├── viewmodels/      # ProductListViewModel (ChangeNotifier)
│   └── states/          # ProductState — estado imutável da UI
│
├── models/              # AuthUser — modelo do usuário autenticado
├── services/            # AuthService — requisição de login
└── session/             # SessionController — gerenciamento de sessão
```

### Camadas e responsabilidades

**Domain** — define as entidades e os contratos (interfaces) dos repositórios. Não depende de nada externo.

**Data** — implementa os contratos do domínio. O `ProductRepositoryImpl` segue estratégia *offline-first*: retorna cache local se disponível, sincroniza com a API em segundo plano e persiste no SQLite (mobile) ou em memória (web).

**Presentation** — as telas consomem o `ProductListViewModel` via `Provider`. O ViewModel gerencia o estado e delega operações ao repositório, mantendo as telas desacopladas da fonte de dados.

**Auth** — segue a estrutura recomendada no material da aula: `AuthService` faz a requisição HTTP, `SessionController` (singleton) mantém o usuário autenticado em memória, e `LoginPage` coordena o fluxo de interface.

### Gerenciamento de estado

`Provider` + `ChangeNotifier`. O `ProductListViewModel` emite um `ProductState` imutável a cada mudança, e as telas reagem via `context.watch`.

### Persistência local

`sqflite` para mobile — banco `product_app.db` com a tabela `products`. Mantém favoritos e permite uso offline. Na web, usa implementação in-memory.