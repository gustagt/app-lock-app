---
name: flutter-ui
description: >-
  Ative quando for criar ou revisar UI/UX Flutter — temas, widgets, layout,
  animações, glassmorphism, design system mobile, performance visual, cores,
  tipografia. Use para decisões de arquitetura visual, regra 60/30/10, grid de
  8pt, sombras tingidas, touch targets (Lei de Fitts), haptic feedback,
  shimmer, anti-padrões Flutter e plataforma iOS/Android.
---

# 🎯 Skill: Mobile Design System & UI/UX Architecture (Flutter Edition)
**(Mobile-First · Touch-First · Platform-Respectful · Performance-Driven)**

---

## 📌 Visão Geral & Filosofia Operacional

Esta documentação atua como a consolidação definitiva entre o **Diretor de Engenharia** (infraestrutura, performance e restrições de hardware) e o **Diretor de Produto & Arte** (intencionalidade visual, psicologia cognitiva e fluidez de UX). 

### 🛑 Lei Fundamental do Mobile
> **"Mobile NÃO é um desktop pequeno."**  
> Pense nas restrições físicas e técnicas do dispositivo primeiro; aplique a estética depois. Cada pixel, valor de espaçamento e animação deve justificar sua existência na tela e na bateria do usuário.

---

## 1. 🧮 Índice de Viabilidade e Risco Mobile (MFRI)

Antes de desenhar uma interface ou codificar um fluxo, avalie matematicamente a viabilidade para mitigar riscos arquitetônicos e falhas de experiência.

### Dimensões de Avaliação (Nota de 1 a 5)
| Dimensão | Pergunta Norteadora | Impacto na Fórmula |
| :--- | :--- | :--- |
| **Clarity of Platform** | As especificidades da plataforma (iOS vs. Android) estão explícitas? | Positivo (+) |
| **Accessibility Readiness** | O design contempla leitores de tela, contrastes e fontes dinâmicas? | Positivo (+) |
| **Interaction Complexity** | Quão complexos são os gestos, transições de tela e fluxos de navegação? | Negativo (-) |
| **Performance Risk** | O fluxo envolve listas infinitas, animações pesadas ou mídia intensiva? | Negativo (-) |
| **Offline Dependence** | A tela degrada graciosamente ou quebra sem conexão com a internet? | Negativo (-) |

$$	ext{MFRI} = (	ext{Platform Clarity} + 	ext{Accessibility Readiness}) - (	ext{Interaction Complexity} + 	ext{Performance Risk} + 	ext{Offline Dependence})$$

* **Range:** $-10$ a $+10$

| Pontuação MFRI | Classificação | Ação Exigida |
| :---: | :--- | :--- |
| **6 a 10** | 🟢 **Seguro** | Prosseguir normalmente com a arquitetura padrão. |
| **3 a 5** | 🟡 **Moderado** | Adicionar validações extras de performance, memoização e testes de estresse. |
| **0 a 2** | 🟠 **Arriscado** | Simplificar interações, reduzir animações ou revisar o modelo de estado. |
| **< 0** | 🔴 **Perigoso** | **PARADA OBRIGATÓRIA.** Redesenhar o fluxo antes de escrever qualquer linha de código. |

---

## 2. 🎨 Engenharia Visual no Flutter

A transição de design systems estáticos (ou web/Tailwind) para **Flutter** exige traduzir conceitos visuais para o ecossistema de **Widgets**, **ThemeData** e **Skia/Impeller**.

### 2.1. Regra de Cores (60 / 30 / 10) via `ColorScheme`
Nunca distribua cores por intuição. Utilize a regra de ouro do design balanceado através do sistema de temas nativo do Flutter:

* **60% (Base / Neutra):** Domina o fundo da tela e superfícies principais (`colorScheme.surface`, `colorScheme.background`).
* **30% (Estrutura / Contraste):** Elementos estruturais, cards secundarios e textos de alta legibilidade (`colorScheme.onSurface`, `colorScheme.secondary`).
* **10% (Acento / Herói):** Botões de chamada principal (CTAs), ícones interativos e notificações (`colorScheme.primary`, `colorScheme.tertiary`).

> 💡 **Hierarquia por Opacidade:** Mantenha a mesma cor para o texto base, variando apenas o canal alpha (transparência):
> * **100% (0xFF):** Títulos principais e números críticos.
> * **80% (0xCC):** Corpo de texto (Body).
> * **60% (0x99):** Legendas, marcações de tempo e labels secundários.

### 2.2. Sistema de Grid de 8 Pontos (`AppSpacing`)
No Flutter, evite magic numbers no layout (ex: `SizedBox(height: 13)` ou `EdgeInsets.all(15)`). Todos os espaçamentos devem ser **múltiplos de 4 ou 8**.

```dart
class AppSpacing {
  AppSpacing._();
  
  static const double xxxs = 2.0;
  static const double xxs = 4.0;
  static const double xs  = 8.0;
  static const double sm  = 12.0;
  static const double md  = 16.0;
  static const double lg  = 24.0;
  static const double xl  = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
}
```

* **Lei da Proximidade:** Elementos logicamente relacionados devem ter um espaçamento menor (ex: `AppSpacing.xs` entre título e legenda). O espaçamento para o próximo grupo independente deve ser no mínimo o dobro (`AppSpacing.lg` ou `AppSpacing.xl`).

---

## 3. 🛡️ Sombras Tingidas, Glassmorphism e Touch Targets

### 3.1. O Anti-Padrão da Sombra Preta
Sombras `#000000` puras em fundos coloridos deixam a interface com aspecto "sujo" e datado. Em aplicativos de elite, a sombra **herda o matiz (hue) do elemento ou do fundo**, aplicando um raio de desfoque amplo com baixa opacidade.

```dart
// ❌ ERRADO: Sombra pesada e cinza/preta padrão do Material
boxShadow: [
  BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
]

// ✅ CORRETO: Sombra suave tingida com a cor primária ou tom de fundo
boxShadow: [
  BoxShadow(
    color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
    blurRadius: 24,
    spreadRadius: 0,
    offset: const Offset(0, 8),
  ),
]
```

### 3.2. Glassmorphism (Efeito Vidro / Blur)
Para barras de navegação flutuantes, modais ou cards de destaque sobre imagens, utilize o desfoque de fundo via `BackdropFilter`:

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(24),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
    child: Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: const Text('Conteúdo Translúcido e Elegante'),
    ),
  ),
)
```

### 3.3. Ergonomia e Touch Targets (Lei de Fitts)
O dedo humano não é um ponteiro de mouse. Em telas móveis:
* **Área de Toque Mínima:** **44x44pt** (iOS) ou **48x48dp** (Android). Nunca crie ícones tocáveis menores que isso sem envolver com um `Padding` ou usar `IconButton` com *constraints* adequadas.
* **Zona do Polegar:** Coloque as ações principais (CTAs de conversão) no terço inferior da tela. Ações destrutivas ("Excluir", "Cancelar") devem ficar fora do alcance acidental do polegar.

---

## 4. 🧠 Psicologia de UX & Design Emocional (Regra do Pico-Fim)

O cérebro humano avalia uma experiência por dois momentos críticos: o **Pico mais intenso** (a realização de uma tarefa chave) e o **Final do fluxo**.

### 4.1. Celebrando o Pico com `flutter_animate` e `HapticFeedback`
Quando o usuário completa uma ação importante (ex: pagar um boleto, bater uma meta, salvar um projeto), a resposta do aplicativo não pode ser silenciosa. Deve combinar **movimento**, **luz** e **tato**.

```dart
import 'package:flutter/services.dart';
import 'package:flutter_animate.dart';

Widget buildPeakAction(BuildContext context) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(double.infinity, 56),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
    ),
    onPressed: () {
      // 1. Resposta tátil imediata (Haptic Feedback)
      HapticFeedback.mediumImpact();
      
      // 2. Lógica da ação...
    },
    child: const Text('Confirmar Transferência', style: TextStyle(fontSize: 16)),
  )
  // Animação contínua sutil de respiração/brilho para sinalizar interatividade
  .animate(onPlay: (controller) => controller.repeat(reverse: true))
  .shimmer(delay: 2.seconds, duration: 1.seconds, color: Colors.white24)
  .scale(begin: const Offset(1, 1), end: const Offset(1.02, 1.02), duration: 800.ms);
}
```

---

## 5. ⚖️ Matriz de Respeito à Plataforma (Unificar vs. Divergir)

Em uma base de código única no Flutter, saiba exatamente o que compartilhar e onde respeitar as convenções nativas do sistema operacional (iOS vs. Android).

| Componente / Camada | Unificar (Compartilhar 100%) | Divergir (Respeitar OS Nativo) |
| :--- | :--- | :--- |
| **Arquitetura & Regras** | Lógica de negócios, State Management (BLoC/Riverpod), Models, Repositories e Endpoints. | N/A |
| **Tipografia & Fontes** | Escala de tamanhos (Headers, Body, Caption) e pesos de tipografia. | **SF Pro** (iOS) vs. **Roboto / Inter** (Android). |
| **Navegação & Gestos** | Estrutura de rotas (GoRouter) e fluxo de telas no funil. | Gestos de volta (*Edge Swipe* no iOS vs. Gesto de sistema no Android). |
| **Componentes de UI** | Cards, Listas, Botões primários, Gráficos e Ilustrações da marca. | Seletores de data (*Date Pickers*), Modais/Action Sheets e Switches. |
| **Ícones do Sistema** | Ícones ilustrativos e identidade visual própria do app. | **CupertinoIcons / SF Symbols** no iOS vs. **Material Icons / Phosphor** no Android. |

---

## 6. 🚫 Anti-Padrões & Erros Fatais no Flutter (Hard Bans)

| Categoria | ❌ Pecado Capital (Proibido) | ❓ Por que é perigoso? | ✅ Redenção (Padrão Exigido) |
| :--- | :--- | :--- | :--- |
| **Performance** | Usar `SingleChildScrollView` envolto em `Column` para listas longas. | Renderiza todos os itens simultaneamente, causando explosão de memória (OOM). | Usar **`ListView.builder`**, **`ListView.separated`** ou **`SliverList`** com virtualização. |
| **Performance** | Omitir a palavra-chave `const` na construção de widgets visuais. | Força a árvore do Flutter a recriar instâncias idênticas em todo re-render (`setState`). | Exigir **`const` em todos os construtores estáticos** via linter (`prefer_const_constructors`). |
| **Performance** | Executar cálculos pesados ou JSON parsing diretamente na Thread UI. | Bloqueia a animação de 60/120fps, causando engasgos (*jank* visível). | Mover processamento para **`compute()`**, **`Isolates`** ou *Web Workers* em Flutter Web. |
| **UX / Touch** | Esconder ações principais em gestos complexos sem alternativa visual. | Exclui usuários com limitações motoras ou que desconhecem o gesto invisível. | Sempre incluir um **botão explícito** ou ícone visual além do gesto de atalho. |
| **UX / Touch** | Deixar de apresentar estados de carregamento (*Loading*) ou estados vazios (*Empty*). | A tela parece travada ou quebrada, destruindo a confiança no app. | Implementar **Shimmer Effects**, *Skeletons* ou *Empty States* ilustrados com CTA de ação. |
| **Segurança** | Armazenar tokens de sessão (JWT) em `SharedPreferences` ou em texto puro. | Facilmente extraído em aparelhos com *root/jailbreak* ou por backup não criptografado. | Exigir **`flutter_secure_storage`** (que utiliza *Keychain* no iOS e *Keystore* no Android). |
| **Segurança** | Deixar chaves de API estáticas hardcoded diretamente no código-fonte. | Facilita a engenharia reversa via descompilação do APK/IPA. | Carregar via **variáveis de ambiente (`--dart-define`)** + ofuscação no build de release. |

---

## 7. 🛠️ O Stack de Elite para UI/UX no Flutter

Para executar esta *skill* em produção, recomendamos o seguinte conjunto de pacotes testados e validados por times de alta performance:

```yaml
dependencies:
  # Tipografia moderna e limpa
  google_fonts: ^6.2.1
  
  # Ícones geométricos de classe mundial (substitui Material Icons padrão)
  phosphor_flutter: ^2.0.1
  # OU: lucide_icons: ^1.1.0
  
  # Animações e micro-interações declarativas em 1 linha de código
  flutter_animate: ^4.5.0
  
  # Gráficos e visualização de dados de alta performance
  fl_chart: ^0.68.0
  
  # Armazenamento criptografado nativo (Keystore/Keychain)
  flutter_secure_storage: ^9.2.2
  
  # Sombras suaves e efeitos visuais avançados
  flutter_svg: ^2.0.10
```

---

## 8. 🚀 Release Readiness Checklist (Pré-Lançamento)

Antes de enviar qualquer *build* para a App Store ou Google Play, audite a aplicação passando por este checklist rigoroso:

- [ ] **MFRI Score:** O fluxo foi avaliado e possui nota $\ge 3$ (ou riscos arquitetônicos foram mitigados)?
- [ ] **Touch Targets:** Todos os botões, ícones e links interativos possuem área clicável mínima de **44x44pt**?
- [ ] **Const Correctness:** O comando `flutter analyze` roda sem avisos de falta de construtores `const` ou *lints* de performance?
- [ ] **Lista Virtualizada:** Nenhuma lista com dados dinâmicos ou infinitos está usando `Column` + `SingleChildScrollView`?
- [ ] **Zero Hardcoded Secrets:** Nenhuma chave de API ou segredo está em texto puro no código fonte Dart?
- [ ] **Secure Storage:** Tokens de autenticação estão armazenados no cofre nativo (`flutter_secure_storage`)?
- [ ] **Soft Shadows:** Nenhuma sombra está usando `#000000` preto puro em fundos coloridos?
- [ ] **Haptic Feedback:** As ações de "Pico" e sucesso de transações disparam `HapticFeedback` tátil adequadamente?
- [ ] **Fallback Offline:** Telas que dependem de internet exibem mensagens claras de erro, *retry* ou cache local em vez de quebrar?
- [ ] **Teste de Estresse (Low-End):** O app mantém 60fps constantes ao rolar listas ou acionar modais em dispositivos Android de entrada? 
