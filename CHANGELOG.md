# Registro de alterações

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

