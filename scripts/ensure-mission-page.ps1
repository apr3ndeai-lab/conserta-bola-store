param(
  [string]$EnvFile = 'C:\Projetos\conserta-bola-store-agent\.env'
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $EnvFile)) {
  throw "Arquivo de ambiente não encontrado: $EnvFile"
}

Get-Content -LiteralPath $EnvFile | ForEach-Object {
  $line = $_.Trim()
  if (-not $line -or $line.StartsWith('#')) { return }
  $parts = $line -split '=', 2
  if ($parts.Count -eq 2) {
    [Environment]::SetEnvironmentVariable($parts[0].Trim(), $parts[1].Trim(), 'Process')
  }
}

$store = $env:SHOPIFY_STORE_DOMAIN
$clientId = $env:SHOPIFY_CLIENT_ID
$clientSecret = $env:SHOPIFY_CLIENT_SECRET
$apiVersion = $env:SHOPIFY_API_VERSION

if (-not $store -or -not $clientId -or -not $clientSecret -or -not $apiVersion) {
  throw 'As variáveis SHOPIFY_STORE_DOMAIN, SHOPIFY_CLIENT_ID, SHOPIFY_CLIENT_SECRET e SHOPIFY_API_VERSION são obrigatórias.'
}

$tokenResponse = Invoke-RestMethod -Method Post -Uri "https://$store/admin/oauth/access_token" -ContentType 'application/json' -Body (@{
  client_id = $clientId
  client_secret = $clientSecret
  grant_type = 'client_credentials'
} | ConvertTo-Json)

$headers = @{
  'X-Shopify-Access-Token' = $tokenResponse.access_token
  'Content-Type' = 'application/json'
}

function Invoke-ShopifyGraphQL {
  param(
    [Parameter(Mandatory = $true)][string]$Query,
    [hashtable]$Variables = @{}
  )

  $body = @{ query = $Query; variables = $Variables } | ConvertTo-Json -Depth 12
  $result = Invoke-RestMethod -Method Post -Uri "https://$store/admin/api/$apiVersion/graphql.json" -Headers $headers -Body $body
  if ($result.errors) {
    throw ($result.errors | ConvertTo-Json -Depth 8 -Compress)
  }
  return $result.data
}

$scopeData = Invoke-ShopifyGraphQL -Query 'query { currentAppInstallation { launchUrl app { id handle title } accessScopes { handle } } }'
$scopes = @($scopeData.currentAppInstallation.accessScopes.handle)
if ('write_content' -notin $scopes -and 'write_online_store_pages' -notin $scopes) {
  [pscustomobject]@{
    status = 'permission_required'
    launchUrl = $scopeData.currentAppInstallation.launchUrl
    appHandle = $scopeData.currentAppInstallation.app.handle
    grantedScopes = $scopes
  } | ConvertTo-Json -Depth 8
  exit 2
}

$lookup = Invoke-ShopifyGraphQL -Query @'
query FindMissionPage($query: String!) {
  pages(first: 10, query: $query) {
    nodes { id title handle isPublished templateSuffix }
  }
}
'@ -Variables @{ query = 'handle:missao' }

$existing = @($lookup.pages.nodes) | Where-Object { $_.handle -eq 'missao' } | Select-Object -First 1
$pageInput = @{
  title = 'Missão'
  handle = 'missao'
  body = '<p>Conheça a missão, a visão e o compromisso do Conserta Bola com o reparo responsável de bolas esportivas.</p>'
  isPublished = $true
  templateSuffix = 'missao'
}

if ($existing) {
  $data = Invoke-ShopifyGraphQL -Query @'
mutation UpdateMissionPage($id: ID!, $page: PageUpdateInput!) {
  pageUpdate(id: $id, page: $page) {
    page { id title handle isPublished templateSuffix }
    userErrors { code field message }
  }
}
'@ -Variables @{ id = $existing.id; page = $pageInput }
  $payload = $data.pageUpdate
  $action = 'updated'
}
else {
  $data = Invoke-ShopifyGraphQL -Query @'
mutation CreateMissionPage($page: PageCreateInput!) {
  pageCreate(page: $page) {
    page { id title handle isPublished templateSuffix }
    userErrors { code field message }
  }
}
'@ -Variables @{ page = $pageInput }
  $payload = $data.pageCreate
  $action = 'created'
}

if ($payload.userErrors.Count -gt 0) {
  throw ($payload.userErrors | ConvertTo-Json -Depth 8 -Compress)
}

[pscustomobject]@{
  action = $action
  page = $payload.page
} | ConvertTo-Json -Depth 8
