<#opçao 1 raspar links em profundidade opção 2 pesquisas profundas #>
<#Pardal23 crack profundidade 5#>
<#Pardal23 crack profundidade 5 EXTRATOR DE LINKS e junção links filho links pai#>

<#
.SYNOPSIS
    Script para pesquisa profunda em links ou pesquisa direta no navegador.
.DESCRIPTION
    Este script oferece duas opções:
    1. Pesquisa profunda recursiva em links (extrai links filhos de um link pai).
    2. Pesquisa direta no navegador usando um termo com * para aprofundar.
.NOTES
    Autor: [Seu Nome]
    Data: [Data]
    Versão: 2.0
#>

# Função para extrair links de uma página web
function Get-LinksFromWebPage {
    param (
        [string]$Url
    )
    try {
        $response = Invoke-WebRequest -Uri $Url -UseBasicParsing
        $links = $response.Links | Where-Object { $_.href -ne $null } | Select-Object -ExpandProperty href
        return $links
    } catch {
        Write-Error "Erro ao acessar a URL: $Url. Detalhes: $_"
        return $null
    }
}

# Função para pesquisa profunda recursiva
function Invoke-DeepSearch {
    param (
        [string]$ParentUrl,
        [int]$Depth = 1
    )
    if ($Depth -gt 5) {
        Write-Output "Profundidade máxima atingida para: $ParentUrl"
        return
    }

    Write-Output "Processando: $ParentUrl (Profundidade: $Depth)"
    $childLinks = Get-LinksFromWebPage -Url $ParentUrl

    if ($childLinks -eq $null -or $childLinks.Count -eq 0) {
        Write-Output "Nenhum link filho encontrado em: $ParentUrl"
        return
    }

    foreach ($link in $childLinks) {
        # Verifica se o link é absoluto ou relativo
        if (-not $link.StartsWith("http")) {
            $link = [System.Uri]::new([System.Uri]::new($ParentUrl), $link).AbsoluteUri
        }

        Write-Output "Link filho encontrado: $link"
        # Realiza a pesquisa recursiva
        Invoke-DeepSearch -ParentUrl $link -Depth ($Depth + 1)
    }
}

# Função para pesquisa direta no navegador
function Invoke-BrowserSearch {
    param (
        [string]$SearchTerm
    )
    try {
        # Substitui * por um termo de pesquisa amplo (ex: "site:example.com *")
        $searchQuery = $SearchTerm.Replace("*", "%20")  # Codifica espaços para URL
        $searchUrl = "https://www.google.com/search?q=$searchQuery"
        Start-Process $searchUrl
        Write-Output "Pesquisa no navegador iniciada: $searchUrl"
    } catch {
        Write-Error "Erro ao iniciar a pesquisa no navegador. Detalhes: $_"
    }
}

# Menu de opções
Write-Host "=== MENU DE OPÇÕES ==="
Write-Host "1. Pesquisa profunda recursiva (extrai links filhos)"
Write-Host "2. Pesquisa direta no navegador (use * para ampliar)"
$option = Read-Host "Escolha uma opção (1 ou 2)"

switch ($option) {
    "1" {
        $parentUrl = Read-Host "Digite a URL pai (ex: https://exemplo.com)"
        Invoke-DeepSearch -ParentUrl $parentUrl
    }
    "2" {
        $searchTerm = Read-Host "Digite o termo de pesquisa (use * para ampliar)"
        Invoke-BrowserSearch -SearchTerm $searchTerm
    }
    default {
        Write-Output "Opção inválida. Execute o script novamente."
    }
}
