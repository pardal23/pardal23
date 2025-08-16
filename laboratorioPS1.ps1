admin*+**+****=**
admin*+**+
tabelas*+**+****=**
base-dados*+**+****=**
login*+**+****=**
contactos*+**+****=**

<#LABORATORIO PS1#>

#google*         → "Buscar por: exploits linux 2024"
#google*         → "Buscar por: filetype:pdf hacking tutorial"
#google*         → "Buscar por: site:github.com inurl:payload"


#EXEMPLO PESQUISAS WEB HACK


# PentestCommandConsole.ps1
# Terminal simbólico para automação de dorks e buscas éticas

function Invoke-PentestCommand {
    param([string]$command)

    switch ($command) {
        "admin*+**+****=**" {
            Write-Host "[Exploração Simulada] Iniciando scan de permissões em endpoint 'admin'..." -ForegroundColor Yellow
            Start-Process "https://www.google.com/search?q=inurl:admin+login"
        }
        "tabelas*+**+****=**" {
            Write-Host "[Busca Simulada] Procurando dumps de tabelas vulneráveis..." -ForegroundColor Green
            Start-Process "https://www.google.com/search?q=filetype:sql+password+dump"
        }
        "base-dados*+**+****=**" {
            Write-Host "[Info Simulada] Mapeando base de dados pública..." -ForegroundColor Cyan
            Start-Process "https://www.google.com/search?q=intext:mysql+error+site:.gov"
        }
        "login*+**+****=**" {
            Write-Host "[Busca Simulada] Procurando páginas de login expostas..." -ForegroundColor Magenta
            Start-Process "https://www.google.com/search?q=inurl:login+site:.edu"
        }
        "contactos*+**+****=**" {
            Write-Host "[Busca Simulada] Coletando contatos públicos expostos..." -ForegroundColor Blue
            Start-Process "https://www.google.com/search?q=intext:%40gmail.com+filetype:xls+OR+filetype:csv"
        }
        "google*" {
            Write-Host "`n[🔎 Pesquisa Ultra Avançada] Digite o termo a ser pesquisado na web:" -ForegroundColor Cyan
            $searchTerm = Read-Host "Buscar por"
            if ($searchTerm) {
                $encodedQuery = [System.Web.HttpUtility]::UrlEncode($searchTerm)
                $url = "https://www.google.com/search?q=$encodedQuery"
                Start-Process $url
            }
        }
        default {
            Write-Host "Comando desconhecido. Tente novamente." -ForegroundColor Red
        }
    }
}

# Loop principal
do {
    Clear-Host
    Write-Host "=== PENTEST COMMAND CONSOLE ===" -ForegroundColor Cyan
    Write-Host "Digite um comando simbólico (ou 'sair' para fechar)"
    Write-Host ""
    Write-Host "Exemplos:"
    Write-Host "  admin*+**+****=**"
    Write-Host "  tabelas*+**+****=**"
    Write-Host "  base-dados*+**+****=**"
    Write-Host "  login*+**+****=**"
    Write-Host "  contactos*+**+****=**"
    Write-Host "  google*  →  [pesquisa avançada personalizada]"
    Write-Host ""

    $inputCommand = Read-Host "Comando"
    if ($inputCommand -eq "sair") { break }

    Invoke-PentestCommand -command $inputCommand
    Write-Host ""
    Pause
} while ($true)