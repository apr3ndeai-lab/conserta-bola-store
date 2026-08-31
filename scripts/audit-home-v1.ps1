param(
  [Parameter(Mandatory = $true)]
  [string]$Base,

  [Parameter(Mandatory = $false)]
  [string]$Head = "HEAD"
)

$ErrorActionPreference = "Stop"
$failures = @()
$warnings = @()

function Fail([string]$message) {
  $script:failures += $message
}

function Pass([string]$message) {
  Write-Host "PASSOU  $message" -ForegroundColor Green
}

function Check([bool]$condition, [string]$passMessage, [string]$failMessage) {
  if ($condition) {
    Pass $passMessage
  } else {
    Fail $failMessage
    Write-Host "FALHOU  $failMessage" -ForegroundColor Red
  }
}

Write-Host "`nAuditoria Home v1 - Conserta Bola" -ForegroundColor Cyan
Write-Host "Comparando $Base..$Head`n"

$changedFiles = @(git diff --name-only "$Base..$Head")
if ($LASTEXITCODE -ne 0) {
  throw "Nao foi possivel obter o diff Git entre $Base e $Head."
}

$allowedFiles = @(
  "templates/index.json",
  "templates/product.json",
  "templates/page.avaliacao.json",
  "sections/whatsapp-float.liquid",
  "sections/triagem.liquid",
  "sections/pagina-avaliacao.liquid",
  "sections/media-with-content.liquid",
  "sections/header-group.json",
  "sections/footer-group.json",
  "blocks/comparison-slider.liquid",
  "blocks/_product-trust-badges.liquid",
  "blocks/_product-details.liquid",
  "blocks/_pdp-leve2.liquid",
  "blocks/_judgeme-badge.liquid",
  "blocks/_judgeme-widget.liquid",
  "sections/faq-schema.liquid",
  "snippets/cart-drawer.liquid",
  "snippets/shipping-progress-bar.liquid",
  "assets/pagina-avaliacao.js",
  "config/settings_data.json",
  "scripts/audit-home-v1.ps1"
)

$protectedFiles = @(
  "layout/theme.liquid"
)

$unexpectedFiles = @(
  $changedFiles | Where-Object { $_ -notin $allowedFiles }
)

Check `
  ($unexpectedFiles.Count -eq 0) `
  "Somente arquivos autorizados foram alterados." `
  ("Arquivos fora do escopo: " + ($unexpectedFiles -join ", "))

$protectedChanged = @(
  $changedFiles | Where-Object { $_ -in $protectedFiles }
)

Check `
  ($protectedChanged.Count -eq 0) `
  "Arquivos protegidos permanecem inalterados." `
  ("Arquivo protegido alterado: " + ($protectedChanged -join ", "))

$renderableThemeDirs = @("templates/", "sections/", "snippets/", "assets/", "locales/")
$renderableChangedFiles = @(
  $changedFiles | Where-Object {
    $file = $_
    ($renderableThemeDirs | Where-Object { $file.StartsWith($_) }).Count -gt 0
  }
)

if ($renderableChangedFiles.Count -gt 0) {
  $renderableDiff = git diff --no-ext-diff --unified=0 "$Base..$Head" -- $renderableChangedFiles
  if ($LASTEXITCODE -ne 0) {
    throw "Nao foi possivel ler o diff Git dos arquivos renderizaveis."
  }

  $addedLines = $renderableDiff | Where-Object {
    $_.StartsWith("+") -and -not $_.StartsWith("+++")
  }
} else {
  $addedLines = @()
}

$prohibitedTerms = @(
  "formula secreta",
  "artesanal",
  "100% garantido",
  "cola bola"
)

foreach ($term in $prohibitedTerms) {
  $found = $addedLines | Select-String -Pattern ([regex]::Escape($term)) -CaseSensitive:$false
  Check `
    ($null -eq $found) `
    "Termo proibido ausente: $term" `
    "Termo proibido encontrado no conteudo renderizavel adicionado: $term"
}

$commercialScanDirs = @("templates", "sections", "snippets", "blocks", "layout")
$commercialScanFiles = @()
foreach ($dir in $commercialScanDirs) {
  if (Test-Path $dir) {
    $commercialScanFiles += Get-ChildItem -Path $dir -Recurse -File -Include *.liquid, *.json | ForEach-Object { $_.FullName }
  }
}

$hardFailPatterns = @(
  @{ Name = 'Preco R$26,90 hardcoded';   Pattern = 'R\$\s*26,90' },
  @{ Name = 'Preco R$27,90 hardcoded';   Pattern = 'R\$\s*27,90' },
  @{ Name = 'Preco R$29,90 hardcoded';   Pattern = 'R\$\s*29,90' },
  @{ Name = "CTA 'Comprar Conserta Bola' hardcoded"; Pattern = 'Comprar Conserta Bola' }
)

foreach ($rule in $hardFailPatterns) {
  $matches = $commercialScanFiles | Select-String -Pattern $rule.Pattern -CaseSensitive:$false
  Check `
    ($null -eq $matches -or $matches.Count -eq 0) `
    ("Sem ocorrencias hardcoded: " + $rule.Name) `
    ("Encontrado hardcoded (" + $rule.Name + "): " + (($matches | ForEach-Object { $_.Path + ":" + $_.LineNumber }) -join "; "))
}

$softWarnPatterns = @(
  @{ Name = "'Frete gratis' fora de config"; Pattern = 'Frete\s+gr[aá]tis' },
  @{ Name = "'5.000 bolas' hardcoded";       Pattern = '5\.000\s+bolas' }
)

foreach ($rule in $softWarnPatterns) {
  $matches = $commercialScanFiles | Select-String -Pattern $rule.Pattern -CaseSensitive:$false
  if ($null -ne $matches -and $matches.Count -gt 0) {
    $warnings += ("Copy comercial hardcoded (" + $rule.Name + "): " + (($matches | ForEach-Object { $_.Path + ":" + $_.LineNumber }) -join "; "))
  }
}

$whatsappFile = "sections/whatsapp-float.liquid"
Check `
  (Test-Path $whatsappFile) `
  "Secao whatsapp-float existe." `
  "sections/whatsapp-float.liquid nao foi encontrada."

if (Test-Path $whatsappFile) {
  $whatsappContent = Get-Content $whatsappFile -Raw -Encoding UTF8

  $hasDisabledFallback = $whatsappContent -match "wa_link\s*=\s*'#'"
  Check `
    $hasDisabledFallback `
    "WhatsApp possui fallback seguro (wa_link = '#') quando sem numero." `
    "WhatsApp nao possui fallback seguro identificado (esperado wa_link = '#')."

  $hasPhoneConditional = (
    $whatsappContent -match "section\.settings\.whatsapp_number" -and
    $whatsappContent -match "if\s+section\.settings\.whatsapp_number\s*!=\s*blank" -and
    $hasDisabledFallback
  )
  Check `
    $hasPhoneConditional `
    "WhatsApp so gera link ativo quando o numero e configurado." `
    "WhatsApp nao possui condicional segura para numero vazio."

  $hasCustomizerWarning = $whatsappContent -match "Configure o n.mero de WhatsApp antes de publicar"
  Check `
    $hasCustomizerWarning `
    "Customizer contem aviso de configuracao antes de publicar." `
    "Nao foi encontrado aviso para configurar WhatsApp antes de publicar."

  $hasSettings = (
    $whatsappContent -match '"type"\s*:\s*"checkbox"' -and
    $whatsappContent -match '"type"\s*:\s*"text"' -and
    $whatsappContent -match '"type"\s*:\s*"color"' -and
    $whatsappContent -match '"type"\s*:\s*"select"'
  )
  Check `
    $hasSettings `
    "WhatsApp possui settings estruturados." `
    "WhatsApp nao parece conter todos os settings esperados."

  $hasDisabledState = $whatsappContent -match "aria-disabled=.true." -and $whatsappContent -match "tabindex=.-1."
  Check `
    $hasDisabledState `
    "Botao WhatsApp fica inacessivel via teclado/leitor de tela quando desabilitado." `
    "Botao WhatsApp nao trata estado desabilitado (aria-disabled/tabindex) quando sem numero."
}

$indexFile = "templates/index.json"
Check `
  (Test-Path $indexFile) `
  "Template da home existe." `
  "templates/index.json nao foi encontrado."

if (Test-Path $indexFile) {
  $indexContent = Get-Content $indexFile -Raw -Encoding UTF8

  $hasWhatsappOnHome = $indexContent -match '"type"\s*:\s*"whatsapp-float"'
  Check `
    $hasWhatsappOnHome `
    "WhatsApp esta registrado na home." `
    "WhatsApp nao esta registrado em templates/index.json."

  $hasPlaceholderMarker = $indexContent -match [regex]::Escape("PLACEHOLDER") -or $indexContent -match "produto em prepara" -or $indexContent -match "produto-em-preparacao"
  Check `
    $hasPlaceholderMarker `
    "Produto ainda esta marcado como placeholder (aviso preservado ate haver produto real)." `
    "Nao foi encontrado nenhum marcador de placeholder de produto em templates/index.json."
}

$themePushOrPublish = $diff | Select-String -Pattern "theme\s+push|theme\s+publish" -CaseSensitive:$false
if ($null -ne $themePushOrPublish) {
  $warnings += "Foram encontradas referencias a 'theme push'/'theme publish' no diff. Confirme que nao sao execucoes automatizadas indevidas."
}

$themeCheckAvailable = Get-Command shopify -ErrorAction SilentlyContinue
Check `
  ($null -ne $themeCheckAvailable) `
  "Shopify CLI disponivel." `
  "Shopify CLI nao esta disponivel no ambiente."

if ($null -ne $themeCheckAvailable) {
  Write-Host "`nExecutando shopify theme check...`n" -ForegroundColor Cyan

  & shopify theme check
  $themeCheckExitCode = $LASTEXITCODE

  Check `
    ($themeCheckExitCode -eq 0) `
    "shopify theme check finalizou sem erros." `
    "shopify theme check falhou com codigo $themeCheckExitCode."
}

Write-Host ""

if ($warnings.Count -gt 0) {
  Write-Host "AVISOS:" -ForegroundColor Yellow
  $warnings | ForEach-Object { Write-Host "- $_" -ForegroundColor Yellow }
  Write-Host ""
}

if ($failures.Count -gt 0) {
  Write-Host "VEREDITO: REPROVADO" -ForegroundColor Red
  Write-Host "Bloqueadores:" -ForegroundColor Red
  $failures | ForEach-Object { Write-Host "- $_" -ForegroundColor Red }
  exit 1
}

Write-Host "VEREDITO: APROVADO" -ForegroundColor Green
exit 0
