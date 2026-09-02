# Registro de alterações

## 2026-09-02 — Google Tag Manager

- Instalado o contêiner `GTM-NZD23HPS` no layout principal da loja.
- Adicionado o carregador JavaScript no início de `<head>` e o fallback `noscript` imediatamente após a abertura de `<body>`.
- Confirmada a ausência de uma instalação anterior do mesmo contêiner antes da publicação, evitando rastreamento duplicado.
- Publicação validada na página inicial, na página do produto e na página Missão; todas responderam com status 200 e exibiram os dois blocos esperados do GTM.

## 2026-09-02 — Restauração da página Missão e prova visual

- Corrigidos os links de Missão nos menus desktop e mobile para `/pages/missao`.
- Removido da página História o bloco resumido de Missão que havia substituído indevidamente a página individual.
- Adicionado `scripts/ensure-mission-page.ps1` para criar ou atualizar a página na Shopify com o template `page.missao`.
- Concedida ao app a permissão opcional `write_content`; a página Shopify foi criada/atualizada, publicada e associada ao template `page.missao`.
- Publicação validada no tema ativo: `/pages/missao` respondeu com status 200, o menu contém o novo destino e a página História não exibe mais o bloco duplicado.
- Gerada pelo fluxo integrado de imagens a primeira direção visual, sem preços ou textos promocionais incorporados: packshot premium, hero desktop e hero mobile.
- Ampliado o pacote para 13 criativos mestres prontos, cobrindo produto, kits, QR code, triagem, aplicação, retorno ao jogo e reaproveitamento. As cinco posições de prova documental permanecem reservadas para fotografias reais.
- Registrados arquivos, fontes, prompts e invariantes em `docs/log-geracao-criativos-v1.md`; nenhuma das novas imagens foi vinculada ao tema ativo nesta etapa.
- Corrigida em `conserta-bola-aplicacao-preparo-v2.png` a escala do frasco de 5 ml quando mostrado em mãos, usando fotografia real na palma como referência dimensional; a versão anterior não deve ser usada.

## 2026-09-02 — Reformulação da narrativa do fundador

- Removidas da página História e da apresentação resumida na página inicial as referências a sócio, investimento e sociedade anterior.
- A narrativa passou a se concentrar na prática da Clínica da Bola, na criação e no aperfeiçoamento da formulação e no início do Conserta Bola em 2025.
- Alteração publicada no tema ativo e validada nas páginas públicas.
- Criado o plano do pacote de 18 criativos mestres com GPT Image 2 em `docs/plano-criativos-gpt-image-2.md`.
- Auditadas 281 mídias das pastas de referência; registradas as fontes aprovadas, os materiais da marca anterior que não podem ser usados, as lacunas de fotografia e a divergência entre 4 ml e 5 ml em `docs/inventario-fontes-criativos.md`.
- Confirmado que o produto entregue contém 5 ml. O site já estava correto; a etiqueta física ainda comunica 4 ml e foi gerada uma prévia separada com a indicação de 5 ml, sem sobrescrever a arte original.

## 2026-09-02 — Política de troca, devolução e reembolso

- Ambiente: loja Shopify em produção (`rmqmkm-kj.myshopify.com`).
- Página: `https://www.consertabola.com.br/policies/refund-policy`.
- Ação: substituição integral do texto genérico de política fornecido pela Shopify.
- Conteúdo publicado:
  - direito de arrependimento em compras online dentro de 7 dias corridos do recebimento;
  - tratamento de vício do produto conforme os arts. 18 e 26 do CDC;
  - prazo de 30 dias para reclamação de vício aparente em produto não durável e início da contagem no momento da constatação para vício oculto;
  - devolução sem custo nos casos de arrependimento dentro do prazo legal ou de vício confirmado;
  - esclarecimento sobre uso indevido, condições estruturais da bola e trocas por preferência após o prazo legal;
  - canais de atendimento por WhatsApp e e-mail.
- Fundamentos consultados:
  - Código de Defesa do Consumidor — arts. 18, 26 e 49;
  - orientações da Secretaria Nacional do Consumidor sobre compras online.
- Método de publicação: Shopify Admin GraphQL API, mutação `shopPolicyUpdate`, tipo `REFUND_POLICY`.
- Permissões aprovadas: `read_legal_policies` e `write_legal_policies` no app Conserta Bola Agent.
- Validação: página pública respondeu normalmente, as novas seções foram encontradas e o conteúdo genérico anterior foi removido, incluindo o marcador de endereço pendente e a regra destinada à União Europeia.
- Arquivos do tema: nenhuma alteração necessária; a política é armazenada pela Shopify fora do código do tema.
