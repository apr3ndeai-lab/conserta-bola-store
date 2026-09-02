# Plano do pacote de criativos — GPT Image 2

## Objetivo

Construir um sistema visual coerente para todo o site que fortaleça três percepções:

1. o Conserta Bola nasceu da prática diária de reparo;
2. o produto é apresentado com precisão e honestidade;
3. recuperar uma bola é uma alternativa prática antes da substituição.

O pacote deve priorizar autenticidade. O GPT Image 2 será usado para tratamento, composição, ambientação e criação de variações a partir de referências reais. Ele não será usado para fabricar resultados, depoimentos, instalações ou situações apresentadas como prova.

## Diagnóstico atual

- O hero tem impacto visual, mas a cena e o produto têm aparência sintética.
- O “antes e depois” atual é ilustrativo e não mostra claramente a mesma bola em duas etapas verificáveis.
- A imagem de autoridade contém muito texto dentro da arte e repete visualmente o número “5.000”. Ela deve ser substituída por uma fotografia real de Marcos e da bancada.
- A página História ainda não possui uma fotografia autêntica do fundador.
- As imagens principais dos produtos misturam fotografia, oferta e preço em uma única arte. Isso dificulta atualizações e cria divergências: o Kit Escolinha está anunciado por R$ 219,00 na loja, mas a imagem ainda mostra R$ 209,00.
- Os kits precisam mostrar quantidades e conteúdos exatos. O que acompanha o produto é frasco, seringa e agulha; a orientação é acessada pelo QR code da embalagem, sem cartilha física.
- A seção de prova social continuará desativada. Nenhum depoimento, cliente ou resultado será inventado.

## Princípios de produção

- Usar fotos reais como referência sempre que houver fundador, produto, embalagem, QR code, bancada ou resultado de reparo.
- Manter preço, promoção e textos de venda em HTML, nunca gravados na imagem.
- Preservar literalmente rótulo, logotipo, cores, quantidade de frascos e itens enviados.
- Fotografar o mesmo exemplar para o par antes/depois, com enquadramento e iluminação equivalentes.
- Gerar primeiro rascunhos para direção visual e somente depois finais em alta qualidade.
- Criar composições próprias para desktop e celular quando o corte alterar a leitura.
- Não produzir “prova social” sintética nem transformar imagens ilustrativas em alegações de resultado real.

## Material real necessário

Antes da geração final, reunir um pacote de referências fotografado com celular, em boa luz e na maior resolução disponível:

1. Marcos de frente, meio corpo, olhando para a câmera;
2. Marcos trabalhando na bancada, em enquadramento horizontal e vertical;
3. mãos examinando uma válvula e identificando o vazamento;
4. aplicação real com seringa e agulha;
5. frasco fotografado de frente, verso e laterais;
6. detalhe legível do QR code na embalagem;
7. conteúdo exato recebido no kit unitário;
8. três frascos e respectivos aplicadores do Kit Recuperação;
9. dez frascos organizados conforme o envio real do Kit Escolinha;
10. a mesma bola antes e depois do reparo;
11. bolas reais de modalidades e materiais diferentes na Clínica da Bola;
12. bancada, ferramentas e ambiente da Clínica da Bola sem preparação excessiva.

Essas fotos não precisam estar prontas para publicação. Elas funcionarão como referências de identidade, geometria, rótulo, quantidade e contexto.

## Pacote V1 — 18 criativos mestres

| ID | Página/uso | Criativo | Formato principal | Função |
| --- | --- | --- | --- | --- |
| H01 | Início | Hero com bola, frasco real e espaço para texto | 3840×2160 | Conversão |
| H02 | Início | Versão vertical do hero | 2160×3840 | Conversão mobile |
| H03 | Início/Missão | Bola real antes do reparo | quadrado | Demonstração |
| H04 | Início/Missão | A mesma bola depois do reparo | quadrado | Demonstração |
| H05 | Início | Marcos na bancada | horizontal | Autoridade |
| H06 | Início/Triagem | Diagnóstico de vazamento em detalhe | horizontal | Educação |
| H07 | Início/Produto | Etapa 1: preparar e dosar | quadrado | Instrução |
| H08 | Início/Produto | Etapa 2: aplicar pela válvula | quadrado | Instrução |
| H09 | Início/Produto | Etapa 3: distribuir e testar | quadrado | Instrução |
| H10 | Início | Bola recuperada voltando ao uso | horizontal | CTA final |
| P01 | Produto/Catálogo | Frasco unitário em estúdio | 3:4 | Clareza do produto |
| P02 | Produto | Conteúdo real do kit unitário em flat lay | 3:4 | Reduzir dúvida |
| P03 | Produto/Catálogo | Kit Recuperação com 3 unidades | 3:4 | Comparação de oferta |
| P04 | Produto/Catálogo | Kit Escolinha com 10 unidades | 3:4 | Comparação de oferta |
| P05 | Produto | QR code e orientação digital em detalhe | 3:4 | Pós-compra e confiança |
| S01 | História | Retrato autêntico de Marcos | 4:5 | Fundador |
| S02 | História/Missão | Clínica da Bola e bancada em uso | horizontal | Origem prática |
| S03 | Missão/Contato | Bolas preservadas e prontas para novo uso | horizontal | Reaproveitamento |

Dos mestres serão derivados cortes para cards, compartilhamento social e telas menores. Não será necessário gerar uma imagem diferente para cada bloco quando um corte consistente resolver o uso.

## Direção visual

- Fotografia documental com acabamento profissional, não publicidade excessivamente polida.
- Azul-marinho, amarelo do frasco, branco e tons reais de quadra/bancada.
- Texturas verdadeiras: bola usada, bancada marcada, mãos trabalhando e embalagem real.
- Luz lateral controlada, contraste forte e sombras naturais.
- Pessoas e ambiente devem parecer brasileiros e reais, sem estética genérica de banco de imagens.
- O produto deve continuar sendo o mesmo frasco fotografado; o modelo não poderá redesenhar o rótulo.

## Estratégia no GPT Image 2

O fluxo será executado via CLI/API com `gpt-image-2`, pois o modelo foi solicitado explicitamente.

### Tipos de operação

- `identity-preserve`: retratos e cenas com Marcos;
- `precise-object-edit`: limpeza de fundo, luz e composição sem alterar produto ou rótulo;
- `compositing`: integrar produto real a cenas controladas mantendo escala e perspectiva;
- `product-mockup`: criar fundos de estúdio a partir do produto real;
- `photorealistic-natural`: ambientações de bancada e uso, sempre identificadas como imagens de apoio quando não forem registros documentais.

### Regras dos prompts

- Cada imagem de entrada terá papel declarado: alvo de edição, referência de identidade ou referência de produto.
- As invariantes serão repetidas: não alterar rosto, rótulo, QR code, quantidade, formato do frasco ou itens do kit.
- Não pedir texto promocional dentro da imagem.
- Gerar um ativo por prompt; variações distintas terão chamadas separadas.
- Rascunhos em qualidade baixa para aprovação de composição; finais em qualidade alta.
- O `gpt-image-2` não será usado para transparência. Os produtos terão fundo de estúdio claro ou escuro. Caso um recorte transparente seja indispensável, será necessária aprovação separada para outro fluxo.

## Etapas de execução

### 1. Captura e organização das referências

- receber as fotos reais;
- conferir rótulo, QR code, itens e quantidades;
- nomear os arquivos por assunto e uso;
- separar o que é registro documental do que pode receber ambientação criativa.

### 2. Prova de direção visual

Produzir três amostras antes do lote completo:

1. hero desktop;
2. retrato de autoridade;
3. packshot do frasco.

Após aprovação dessas três peças, a mesma linguagem será aplicada ao restante.

### 3. Produção por lotes

- Lote A: produto e catálogo — P01 a P05;
- Lote B: conversão da página inicial — H01, H02, H05, H06 e H10;
- Lote C: demonstração — H03, H04 e H07 a H09;
- Lote D: marca — S01 a S03.

### 4. Implementação no site

- subir os arquivos finais na Shopify;
- substituir imagens sem alterar textos e ofertas já aprovados;
- ativar imagem mobile específica no hero;
- colocar preço e promoção somente nos componentes HTML;
- cadastrar textos alternativos objetivos;
- manter nomes de arquivo descritivos e versionados.

### 5. Validação

- revisar desktop e celular;
- conferir enquadramento, legibilidade e continuidade do antes/depois;
- validar quantidades de 1, 3 e 10 frascos;
- confirmar que nenhum material menciona cartilha física;
- testar desempenho e carregamento da página;
- comparar cliques nos CTAs e avanço para o produto após a troca das imagens.

## Prioridade recomendada

1. remover preço das imagens dos produtos e corrigir imediatamente o Kit Escolinha;
2. substituir a arte de “5.000 bolas” por foto real de autoridade com texto em HTML;
3. produzir um antes/depois autêntico da mesma bola;
4. criar hero desktop e mobile com o frasco real;
5. completar História, Missão, processo de aplicação e contato.

## Critérios de aprovação

- produto e fundador reconhecíveis e fiéis às referências;
- rótulo e QR code preservados;
- quantidade exata em cada kit;
- nenhuma alegação visual fabricada;
- nenhum preço incorporado ao arquivo de imagem;
- leitura correta nos cortes desktop e mobile;
- coerência de luz, cor e acabamento entre todas as páginas;
- arquivos finais salvos no projeto e vinculados corretamente na Shopify.

