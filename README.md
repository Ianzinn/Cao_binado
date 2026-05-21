# Cãobinado — Aplicativo de Adoção de Animais

Aplicativo mobile desenvolvido em Flutter como projeto acadêmico. A proposta é conectar protetores de animais com pessoas interessadas em adotar, oferecendo um fluxo completo desde a solicitação até a conclusão da adoção.

---

## Sobre o projeto

O Cãobinado permite que protetores cadastrem pets disponíveis para adoção e gerenciem todo o processo: recebimento de solicitações, agendamento de visitas presenciais e registro do resultado. Do lado do adotante, é possível explorar os pets, favoritar, solicitar adoção e acompanhar o andamento em tempo real.

---

## Tecnologias implementadas

### Flutter & Dart
- Desenvolvimento mobile multiplataforma (Android e iOS) com um único código-base
- Dart `^3.9.2` com recursos modernos da linguagem (switch expressions, pattern matching)
- Material Design 3 como base visual

### Firebase Authentication
- Autenticação por e-mail e senha
- Gerenciamento de sessão persistente
- Integração com o restante dos serviços Firebase

### Autenticação Biométrica
- Login por impressão digital ou reconhecimento facial via `local_auth`
- Credenciais armazenadas com segurança em `flutter_secure_storage` (keychain/keystore nativo)
- Ativação e desativação pelo próprio usuário nas configurações do perfil

### Cloud Firestore (Firebase)
- Banco de dados NoSQL em tempo real
- Streams reativos para atualização automática da UI sem necessidade de refresh manual
- Operações atômicas com `WriteBatch` para garantir consistência de dados (ex.: atualizar adoção e status do pet num único commit)
- Regras de segurança com controle de acesso por perfil de usuário (protetor / adotante)
- Índices compostos para queries complexas com múltiplos filtros e ordenação

### Cloudinary
- Upload de imagens dos pets e fotos de perfil via HTTP multipart
- Armazenamento externo com URL pública para exibição no app
- Suporte a múltiplas fotos por pet

### MobX — Gerenciamento de Estado
- Estado reativo com `@observable`, `@computed` e `@action`
- Geração automática de código com `mobx_codegen` e `build_runner`
- `Observer` widget para rebuild granular (apenas o que mudou re-renderiza)
- `reaction()` para sincronizar efeitos colaterais (ex.: CEP auto-preenchendo campos de endereço)

### GoRouter — Navegação
- Navegação declarativa com rotas nomeadas
- Passagem de objetos entre rotas via `extra`
- Histórico de navegação com `push`/`pop` e redirecionamento com `go`

### GetIt — Injeção de Dependência
- Registro de dependências como `LazySingleton` (compartilhado) e `Factory` (nova instância por tela)
- Inversão de controle seguindo os princípios SOLID

### ViaCEP — Autocomplete de Endereço
- Integração com a API pública ViaCEP (`viacep.com.br`)
- Preenchimento automático de logradouro, bairro, cidade e UF ao digitar o CEP
- Tratamento de erros de rede com `SocketException` e `TimeoutException`

### Image Picker
- Seleção múltipla de imagens da galeria do dispositivo
- Compressão automática de qualidade (80%) antes do upload

### Arquitetura Limpa (Clean Architecture)
Separação em três camadas independentes:

| Camada | Responsabilidade |
|---|---|
| **Domain** | Modelos de negócio e interfaces dos repositórios |
| **Data** | DTOs, datasources remotos e implementações dos repositórios |
| **Presentation** | Pages, Stores MobX e Widgets |

Cada feature (auth, pets, adoption, profile...) é isolada em seu próprio módulo dentro da camada de apresentação.

---

## Fluxo de adoção

```
1. Adotante solicita adoção de um pet
          ↓
2. Protetor recebe a solicitação e agenda uma visita
   (data, local, observações)
          ↓
3. Pet passa para o status "Visita agendada"
   Adotante recebe notificação in-app
          ↓
4. Visita presencial acontece
          ↓
5. Protetor informa o resultado
       ↙              ↘
  Adotado          Não adotado
Pet → "adotado"   Pet → "disponível" novamente
                  Aceita novas solicitações
```

---

## Estrutura do projeto

```
lib/
├── core/
│   ├── di/             # Configuração do GetIt
│   ├── router/         # Rotas da aplicação (GoRouter)
│   ├── services/       # AuthService, BiometricService, CepService
│   └── theme/          # Design system: cores, bordas, sombras, tipografia
│
├── domain/
│   ├── models/         # UserModel, PetModel, AdoptionModel
│   └── repositories/   # Interfaces abstratas dos repositórios
│
├── data/
│   ├── dtos/           # Conversão Firestore ↔ Model
│   ├── datasources/    # Acesso ao Firestore e Cloudinary
│   └── repositories/   # Implementações concretas
│
└── presentation/
    └── features/
        ├── auth/       # Login e cadastro
        ├── home/       # Tela inicial
        ├── pets/       # Listagem, detalhes, cadastro de pets, favoritos
        ├── adoption/   # Solicitações, agendamento e resultado de visita
        ├── adopters/   # Gestão de adotantes (visão do admin)
        ├── history/    # Histórico de adoções do usuário
        └── profile/    # Perfil e informações da conta
```

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

# HTTP (Cloudinary e ViaCEP)
http: ^1.2.2

# Fontes
google_fonts: ^6.2.1
```

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

> Os arquivos `google-services.json` e `GoogleService-Info.plist` são necessários para conectar ao Firebase e não estão versionados por questões de segurança.
