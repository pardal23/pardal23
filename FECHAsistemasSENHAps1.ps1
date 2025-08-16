<#fechar sistemas de link com senha#>

<#CRIAR SENHA NUM LINK PAI QUALQUER fechando o link com senha#>

# Caminho onde será salvo o hash da senha (pode ser ajustado)
$senhaPath = "$env:APPDATA\senha_protegida.txt"

# Caminho onde será salvo o link/caminho do sistema protegido
$alvoPath = "$env:APPDATA\sistema_protegido.txt"

function Generate-RandomPassword {
    param (
        [int]$Length = 12
    )

    $validChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*()"
    $password = -join (1..$Length | ForEach-Object {
        $bytes = New-Object 'System.Byte[]' 1
        (New-Object System.Security.Cryptography.RNGCryptoServiceProvider).GetBytes($bytes)
        $validChars[$bytes[0] % $validChars.Length]
    })

    return $password
}

function Criar-Protecao {
    Write-Host "`n=== MODO DE CONFIGURAÇÃO ===`n"

    # Caminho para o sistema a proteger
    $sistema = Read-Host "Digite o caminho completo do sistema ou app a ser protegido (ex: C:\Program Files\App\App.exe)"

    # Salvar o caminho
    $sistema | Out-File -FilePath $alvoPath -Encoding UTF8

    # Definir ou gerar senha
    $resp = Read-Host "Deseja criar sua própria senha? (s/n)"
    if ($resp -eq 's') {
        $senha = Read-Host "Digite sua senha" -AsSecureString
    } else {
        $senhaGerada = Generate-RandomPassword
        Write-Host "Senha gerada: $senhaGerada"
        $senha = ConvertTo-SecureString $senhaGerada -AsPlainText -Force
    }

    # Criptografar e salvar
    $senha | ConvertFrom-SecureString | Out-File -FilePath $senhaPath

    Write-Host "`nConfiguração concluída com sucesso!"
}

function Verificar-Senha {
    if (!(Test-Path $senhaPath) -or !(Test-Path $alvoPath)) {
        Write-Host "Sistema ainda não foi configurado. Executando configuração inicial..."
        Criar-Protecao
        return
    }

    $senhaArmazenada = Get-Content $senhaPath | ConvertTo-SecureString
    $senhaInserida = Read-Host "Digite a senha para abrir o sistema protegido" -AsSecureString

    # Comparar
    if (([System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($senhaArmazenada))) -eq
        ([System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($senhaInserida)))) {

        Write-Host "`nSenha correta! Abrindo o sistema protegido..."

        # Executar o sistema protegido
        $sistema = Get-Content $alvoPath
        Start-Process $sistema
    } else {
        Write-Host "`nSenha incorreta! Acesso negado."
    }
}

# Execução principal
Verificar-Senha
