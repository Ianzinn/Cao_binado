# Cãobinado — Aplicativo de Adoção de Animais

Aplicativo mobile desenvolvido em Flutter como projeto acadêmico. A proposta é conectar protetores de animais com pessoas interessadas em adotar, oferecendo um fluxo completo desde a solicitação até a conclusão da adoção.

---

## Sobre o projeto

O Cãobinado permite que protetores cadastrem pets disponíveis para adoção e gerenciem todo o processo: recebimento de solicitações, agendamento de visitas, reagendamento e registro do resultado. Do lado do adotante, é possível explorar os pets, favoritar, solicitar adoção, acompanhar o andamento em tempo real e solicitar reagendamento de visita.

O app possui dois perfis distintos de usuário com interfaces e fluxos diferentes:

- **Protetor (admin):** cadastra pets, analisa solicitações, agenda visitas, aprova/recusa reagendamentos e finaliza adoções
- **Adotante:** busca pets, solicita adoção, acompanha o status, solicita reagendamento e pode cancelar a solicitação

---

## Tecnologias

### Flutter & Dart
- Desenvolvimento mobile multiplataforma (Android e iOS) com código único
- Dart `^3.9.2` com recursos modernos (switch expressions, pattern matching, records)
- Material Design 3 como base visual com design system customizado

### Firebase Authentication
- Autenticação por e-mail e senha
- Gerenciamento de sessão persistente com redirecionamento automático de rotas

### Autenticação Biométrica
- Login por impressão digital ou reconhecimento facial via `local_auth`
- Credenciais armazenadas com segurança em `flutter_secure_storage` (Keychain no iOS, Keystore no Android)
- Ativação opcional ao fazer login, desativação pelo perfil

### Cloud Firestore
- Banco de dados NoSQL em tempo real
- **Streams reativos** para atualização automática da UI sem polling
- **WriteBatch** para operações atômicas (ex.: atualizar adoção e status do pet em um único commit)
- **Regras de segurança** com controle de acesso por perfil (protetor/adotante) e por campos específicos (ex.: adotante só pode alterar `status` de `visita_agendada` para `reagendamento_pendente`)
- **Índices compostos** para queries com múltiplos filtros e ordenação

### Cloudinary
- Upload de imagens dos pets e foto de perfil via HTTP multipart
- Suporte a múltiplas fotos por pet

### MobX — Gerenciamento de Estado
- Estado reativo com `@observable`, `@computed` e `@action`
- Geração automática de boilerplate via `mobx_codegen` + `build_runner`
- `Observer` para rebuild granular — apenas o widget afetado é reconstruído
- `autorun` para efeitos que devem disparar imediatamente com o valor atual e em toda mudança subsequente (ex.: notificações ao entrar na home)
- `reaction` para efeitos que respondem apenas a mudanças (ex.: CEP preenchendo campos de endereço)
- Stores com ciclo de vida controlado: `LazySingleton` para estado global (HomeStore) e `Factory` para estado de tela

### GoRouter — Navegação
- Navegação declarativa com rotas nomeadas e guarda de autenticação
- Passagem de objetos complexos entre rotas via `extra`
- `push` para empilhar telas e `go` para navegação substituindo o histórico

### GetIt — Injeção de Dependência
- `LazySingleton` para dependências compartilhadas entre telas (AuthStore, PetStore, HomeStore, repositórios)
- `Factory` para stores de tela com ciclo de vida isolado (LoginStore, RegisterStore, etc.)
- Reset de singleton no logout (`resetLazySingleton`) para garantir estado limpo entre sessões

### ViaCEP — Autocomplete de Endereço
- Preenchimento automático de logradouro, bairro, cidade e UF ao digitar o CEP
- Debounce para evitar chamadas desnecessárias durante digitação

### Outras bibliotecas
- `image_picker` — seleção múltipla da galeria com compressão (80%)
- `cached_network_image` — cache de imagens com shimmer de carregamento
- `shimmer` — skeleton screens durante carregamento
- `google_fonts` — tipografia com Poppins e Tomorrow

---

## Arquitetura

O projeto segue **Clean Architecture** com separação em três camadas independentes:

```
┌─────────────────────────────────────────┐
│           Presentation Layer            │
│  Pages · Stores (MobX) · Widgets       │
└────────────────┬────────────────────────┘
                 │ usa interfaces de
┌────────────────▼────────────────────────┐
│             Domain Layer                │
│  Models · Repository Interfaces         │
└────────────────┬────────────────────────┘
                 │ implementado por
┌────────────────▼────────────────────────┐
│              Data Layer                 │
│  DTOs · Datasources · Repositórios     │
└─────────────────────────────────────────┘
```

| Camada | Responsabilidade |
|---|---|
| **Domain** | Modelos de negócio puros (`UserModel`, `PetModel`, `AdoptionModel`) e interfaces abstratas dos repositórios |
| **Data** | DTOs para serialização/deserialização Firestore ↔ Model, datasources remotos e implementações concretas dos repositórios |
| **Presentation** | Pages, Stores MobX e Widgets. Cada feature é um módulo isolado |

---

## Estrutura do projeto

```
lib/
├── core/
│   ├── di/             # Configuração do GetIt (injection.dart)
│   ├── router/         # GoRouter com guards de autenticação
│   ├── services/       # AuthService, BiometricService, CepService
│   └── theme/          # Design system: cores, bordas, sombras, tipografia
│
├── domain/
│   ├── models/         # UserModel, PetModel, AdoptionModel
│   └── repositories/   # Interfaces abstratas
│
├── data/
│   ├── dtos/           # AdoptionDto, PetDto, UserDto
│   ├── datasources/
│   │   └── remote/     # Firestore e Cloudinary
│   └── repositories/   # Implementações concretas
│
└── presentation/
    └── features/
        ├── auth/        # Login, cadastro
        ├── home/        # Home com badges de notificação
        ├── pets/        # Listagem, detalhes, cadastro, favoritos
        ├── adoption/    # Solicitações (admin), minhas adoções (adotante)
        ├── adopters/    # Gestão de adotantes (visão do admin)
        ├── history/     # Histórico de adoções
        ├── profile/     # Perfil, informações da conta
        └── splash/      # Splash screen
```

---

## Fluxo completo de adoção

```
[Adotante] Solicita adoção de um pet  →  status: interesse
                    │
                    ▼
[Admin] Recebe notificação in-app (bottomsheet + badge na home)
                    │
                    ▼
              Aprovar?
             /        \
           Sim         Não → status: cancelado
            │               (pet permanece disponível;
            │                adotante não é notificado)
            ▼
[Admin] Agenda a visita (data, local, observações)
        status: visita_agendada
                    │
                    ▼
[Adotante] Recebe notificação in-app com os detalhes da visita
                    │
          ┌─────────┼──────────────┐
          │         │              │
        Entendi  Solicitar      Cancelar
          │      reagend.       solicitação
          │         │               │
          │         ▼               ▼
          │  [Adotante] Propõe  status: cancelado
          │  nova data e motivo (pet permanece disponível)
          │  status: reagend._pendente
          │         │
          │         ▼
          │   [Admin] Analisa proposta de reagendamento
          │        /              \
          │   Confirmar          Manter data original
          │       │                      │
          │       ▼                      ▼
          │  visitaData atualizada   data original mantida
          │  status: visita_agendada  status: visita_agendada
          │  Adotante notificado     Adotante notificado
          │  (nova visita)           (reagendamento recusado)
          │       │                      │
          └───────┴──────────────────────┘
                    │
                    ▼
              Visita acontece
                    │
                    ▼
          [Admin] Registra resultado
               /            \
           Adotado        Não adotado
              │                │
              ▼                ▼
     pet → "adotado"   pet → "disponivel"
     adoção → "adotado" adoção → "nao_adotado"
                         (aceita novas solicitações)
```

### Status do processo de adoção

| Status | Descrição |
|---|---|
| `interesse` | Solicitação enviada, aguardando análise do protetor |
| `visita_agendada` | Protetor aprovou e agendou a visita |
| `reagendamento_pendente` | Adotante solicitou nova data, aguardando resposta |
| `adotado` | Visita realizada e adoção confirmada |
| `nao_adotado` | Visita realizada, adoção não concluída |
| `cancelado` | Solicitação recusada ou cancelada pelo adotante |

---

## Sistema de notificações in-app

O app não usa push notifications — toda comunicação acontece via streams do Firestore ao entrar na tela inicial.

**Para o protetor (admin):**
- Badge vermelho no ícone de envelope da AppBar com a contagem de solicitações pendentes
- Bottomsheet automático ao entrar na home quando há novas solicitações (exibido uma vez por sessão)
- Ao tocar no badge, navega direto para a tela de solicitações

**Para o adotante:**
- Badge vermelho no ícone de notificação da AppBar com a contagem de notificações não lidas
- Bottomsheet automático com detalhes da visita agendada (ou recusa de reagendamento)
- Ao confirmar, o evento é marcado como visto no Firestore
- Ao tocar no badge, navega para "Minhas Adoções"

**Implementação técnica:**
- `HomeStore` registrado como `LazySingleton` — o mesmo estado persiste enquanto o usuário está logado
- Três streams simultâneos são abertos na inicialização: estatísticas do protetor, solicitações pendentes e notificações do adotante
- `autorun` (MobX) detecta o valor atual imediatamente ao entrar na home, garantindo exibição mesmo que os dados cheguem antes do widget estar montado

---

## Segurança

- Arquivos de configuração do Firebase (`google-services.json`, `GoogleService-Info.plist`) não versionados
- Credenciais biométricas armazenadas exclusivamente no Keychain/Keystore nativo do dispositivo
- Regras do Firestore validam operações campo a campo — o adotante não pode alterar campos que não sejam de sua responsabilidade
- Perfis de acesso separados em rotas protegidas: rotas de admin bloqueadas para adotantes

---

## Como executar

```bash
# Instalar dependências
flutter pub get

# Gerar código do MobX
dart run build_runner build --delete-conflicting-outputs

# Executar
flutter run
```

> Os arquivos `google-services.json` e `GoogleService-Info.plist` são necessários para conectar ao Firebase e devem ser obtidos separadamente no console do Firebase.

---

## Dependências principais

```yaml
# Estado
mobx: ^2.4.0
flutter_mobx: ^2.2.1

# Navegação
go_router: ^14.6.2

# Injeção de dependência
get_it: ^8.0.3

# Firebase
firebase_core: ^3.6.0
firebase_auth: ^5.3.1
cloud_firestore: ^5.4.3

# Biometria
local_auth: ^2.3.0
flutter_secure_storage: ^9.2.2

# Mídia
image_picker: ^1.1.2
cached_network_image: ^3.4.1
shimmer: ^3.0.0

# HTTP (Cloudinary e ViaCEP)
http: ^1.2.2

# Fontes
google_fonts: ^6.2.1
```
