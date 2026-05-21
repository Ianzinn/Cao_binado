# Cãobinado

Aplicativo mobile de adoção de animais desenvolvido em Flutter. Conecta protetores que desejam dar animais para adoção com pessoas interessadas em adotar.

---

## Funcionalidades

### Para adotantes
- Navegar pela lista de pets disponíveis com filtros por espécie e porte
- Favoritar pets para acompanhar depois
- Solicitar adoção com um toque
- Receber notificação in-app quando a visita for agendada pelo protetor
- Acompanhar o histórico de solicitações

### Para protetores (administradores)
- Cadastrar pets com múltiplas fotos
- Gerenciar solicitações de adoção recebidas
- Agendar visitas com data, local e observações
- Informar o resultado da visita (adotado / não adotado)
- Quando não adotado, o pet volta automaticamente para a lista de disponíveis

### Geral
- Autenticação por e-mail/senha e login por biometria
- Perfil de usuário com dados de endereço e autocomplete de CEP via ViaCEP
- Foto de perfil com upload para Cloudinary

---

## Fluxo de adoção

```
Adotante solicita
       ↓
Protetor analisa e agenda visita
       ↓
Pet fica com status "Visita agendada"
       ↓
Visita acontece presencialmente
       ↓
Protetor informa o resultado
    ↙           ↘
Adotado       Não adotado
Pet → adotado  Pet → disponível novamente
```

---

## Stack

| Camada | Tecnologia |
|---|---|
| Framework | Flutter (Dart) |
| Estado | MobX + flutter_mobx |
| Navegação | GoRouter |
| Injeção de dependência | GetIt |
| Backend | Firebase (Auth + Firestore) |
| Armazenamento de imagens | Cloudinary |
| Autenticação biométrica | local_auth |
| Fontes | Google Fonts (Poppins) |
| CEP | ViaCEP (API pública) |

---

## Arquitetura

Arquitetura limpa em três camadas:

```
lib/
├── core/
│   ├── di/             # Injeção de dependência (GetIt)
│   ├── router/         # Rotas (GoRouter)
│   ├── services/       # Serviços transversais (Auth, CEP, Biometria)
│   └── theme/          # Design system (cores, raios, sombras)
│
├── domain/
│   ├── models/         # Entidades de domínio
│   └── repositories/   # Interfaces dos repositórios
│
├── data/
│   ├── dtos/           # Conversão Firestore ↔ Model
│   ├── datasources/    # Acesso remoto (Firestore, Cloudinary)
│   └── repositories/   # Implementações dos repositórios
│
└── presentation/
    └── features/
        ├── auth/       # Login, cadastro
        ├── home/       # Tela inicial
        ├── pets/       # Listagem, detalhes, cadastro, favoritos
        ├── adoption/   # Solicitações, agendamento, resultado de visita
        ├── adopters/   # Gestão de adotantes (admin)
        ├── history/    # Histórico de adoções
        └── profile/    # Perfil, informações da conta
```

Cada feature segue o padrão `page → store (MobX) → repository → datasource`.

---

## Pré-requisitos

- Flutter SDK `^3.9.2`
- Conta no Firebase com projeto configurado
- Conta no Cloudinary com upload preset configurado

---

## Configuração

1. Clone o repositório:
```bash
git clone <url-do-repo>
cd cao_binado
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Configure o Firebase:
   - Crie um projeto no [Firebase Console](https://console.firebase.google.com)
   - Adicione um app Android e/ou iOS
   - Baixe o `google-services.json` (Android) e/ou `GoogleService-Info.plist` (iOS)
   - Coloque os arquivos nos respectivos diretórios (`android/app/` e `ios/Runner/`)

4. Configure as regras do Firestore:
```bash
firebase deploy --only firestore:rules
```

5. Gere os arquivos do MobX:
```bash
dart run build_runner build --delete-conflicting-outputs
```

6. Execute o app:
```bash
flutter run
```

---

## Índices Firestore necessários

A query de solicitações pendentes requer um índice composto. Ao abrir a tela de solicitações pela primeira vez, o Firebase exibirá um link no console para criá-lo automaticamente.

Índice manual (coleção `adoptions`):

| Campo | Ordem |
|---|---|
| `protetorId` | Crescente |
| `status` | Crescente |
| `criadoEm` | Decrescente |

---

## Status dos pets

| Status | Significado |
|---|---|
| `disponivel` | Disponível para adoção |
| `visita_agendada` | Possui visita presencial agendada |
| `adotado` | Adoção concluída |

## Status das solicitações

| Status | Significado |
|---|---|
| `interesse` | Solicitação enviada, aguardando análise |
| `visita_agendada` | Visita agendada pelo protetor |
| `adotado` | Adoção finalizada com sucesso |
| `cancelado` | Solicitação recusada pelo protetor |
| `nao_adotado` | Visita realizada, adoção não concluída |
