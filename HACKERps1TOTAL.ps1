<#FAZER ABRIR O GOOGLE EM STRING e PESQUISAR EM PESQUISAS AVANÇADAS do google#>
<#PS1 fussa tudo HACKEANDO#>


<#
.SYNOPSIS
    Transforma URLs base em strings especiais e pesquisa no navegador padrão.
.DESCRIPTION
    Este script pega uma URL base, converte em uma string especial (hash SHA256) e pesquisa essa string no navegador padrão.
.PARAMETER BaseUrl
    A URL base que será transformada e pesquisada.
.EXAMPLE
    .\TransformAndSearch.ps1 -BaseUrl "https://partidochega.pt/"
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$BaseUrl
)

# Função para gerar hash SHA256 de uma string
function Get-StringHash {
    param (
        [string]$InputString
    )
    $sha256 = [System.Security.Cryptography.SHA256]::Create()
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($InputString)
    $hashBytes = $sha256.ComputeHash($bytes)
    $hashString = [System.BitConverter]::ToString($hashBytes) -replace '-', ''
    return $hashString.ToLower()
}

# Gerar hash da URL base
$specialString = Get-StringHash -InputString $BaseUrl
Write-Host "URL base: $BaseUrl"
Write-Host "String especial (SHA256): $specialString"

# Pesquisar a string especial no navegador padrão
$searchUrl = "https://www.google.com/search?q=$specialString"
Write-Host "Pesquisando no navegador: $searchUrl"
Start-Process $searchUrl
