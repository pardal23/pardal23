<#pesquisa ultra avançada google craqueado#>

<#
.SYNOPSIS
    Ferramenta gráfica para Google Dorking + Criador de HTML local.
.DESCRIPTION
    Pesquisa avançada em Google com dorks e salva HTMLs localmente.
.NOTES
    Desenvolvido para fins educativos.
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- Janela principal ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "Google Dork Pentest GUI + HTML Saver"
$form.Size = New-Object System.Drawing.Size(500, 700)
$form.StartPosition = "CenterScreen"
$form.TopMost = $true

# --- Campo: Domínio ---
$labelDomain = New-Object System.Windows.Forms.Label
$labelDomain.Location = New-Object System.Drawing.Point(20, 20)
$labelDomain.Size = New-Object System.Drawing.Size(450, 20)
$labelDomain.Text = "Digite o domínio (ex: exemplo.com):"
$form.Controls.Add($labelDomain)

$textBoxDomain = New-Object System.Windows.Forms.TextBox
$textBoxDomain.Location = New-Object System.Drawing.Point(20, 45)
$textBoxDomain.Size = New-Object System.Drawing.Size(440, 25)
$form.Controls.Add($textBoxDomain)

# --- Campo: Seleção de Dorks ---
$labelDork = New-Object System.Windows.Forms.Label
$labelDork.Location = New-Object System.Drawing.Point(20, 80)
$labelDork.Size = New-Object System.Drawing.Size(450, 20)
$labelDork.Text = "Selecione o tipo de pesquisa:"
$form.Controls.Add($labelDork)

$dorkBox = New-Object System.Windows.Forms.ComboBox
$dorkBox.Location = New-Object System.Drawing.Point(20, 105)
$dorkBox.Size = New-Object System.Drawing.Size(440, 25)
$dorkBox.DropDownStyle = 'DropDownList'
$dorkBox.Items.AddRange(@(
    "🗂️ Arquivos e documentos (pdf, doc, txt...)",
    "📁 Index of (listagem de diretórios)",
    "🔑 Vazamentos de senhas (txt)",
    "🔐 Painéis de login/admin",
    "📹 Câmeras IP públicas",
    "🧬 Git repositories expostos",
    "💾 Backups e bancos de dados"
))
$dorkBox.SelectedIndex = 0
$form.Controls.Add($dorkBox)

# --- Botão: Pesquisar ---
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(180, 140)
$button.Size = New-Object System.Drawing.Size(100, 35)
$button.Text = "Pesquisar"

$button.Add_Click({
    $domain = $textBoxDomain.Text.Trim()
    $dorkIndex = $dorkBox.SelectedIndex

    if (-not [string]::IsNullOrWhiteSpace($domain)) {
        switch ($dorkIndex) {
            0 { $query = "site:$domain (email OR contact OR login OR user OR table OR document) (filetype:pdf OR filetype:doc OR filetype:xls OR filetype:ppt OR filetype:txt OR filetype:csv)" }
            1 { $query = "intitle:`"index of`" site:$domain" }
            2 { $query = "site:$domain (password OR senha) filetype:txt" }
            3 { $query = "inurl:admin OR inurl:login site:$domain" }
            4 { $query = "inurl:view/index.shtml" }
            5 { $query = "inurl:.git site:$domain" }
            6 { $query = "site:$domain (ext:sql OR ext:db OR ext:bak)" }
            default { $query = "site:$domain" }
        }

        $encodedQuery = [System.Web.HttpUtility]::UrlEncode($query)
        $url = "https://www.google.com/search?q=$encodedQuery"

        # Log
        $log = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $query"
        Add-Content -Path "$PSScriptRoot\dorks_log.txt" -Value $log

        # Abrir no navegador
        try {
            Start-Process $url
            [System.Windows.Forms.MessageBox]::Show("Pesquisa iniciada para '$domain'.", "Sucesso", "OK", "Information")
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Erro ao abrir o navegador. URL gerada: $url", "Erro", "OK", "Error")
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("Por favor, insira um domínio válido.", "Aviso", "OK", "Warning")
    }
})
$form.Controls.Add($button)

# -------------------------------------
# === BLOCO: INSERIR E SALVAR HTML ===
# -------------------------------------

# Label para salvar HTML
$labelHTML = New-Object System.Windows.Forms.Label
$labelHTML.Location = New-Object System.Drawing.Point(20, 190)
$labelHTML.Size = New-Object System.Drawing.Size(450, 20)
$labelHTML.Text = "Insira o conteúdo HTML a ser salvo:"
$form.Controls.Add($labelHTML)

# TextBox multiline para HTML
$textBoxHTML = New-Object System.Windows.Forms.TextBox
$textBoxHTML.Location = New-Object System.Drawing.Point(20, 215)
$textBoxHTML.Size = New-Object System.Drawing.Size(440, 200)
$textBoxHTML.Multiline = $true
$textBoxHTML.ScrollBars = "Vertical"
$form.Controls.Add($textBoxHTML)

# Label para nome do arquivo
$labelNomeArq = New-Object System.Windows.Forms.Label
$labelNomeArq.Location = New-Object System.Drawing.Point(20, 425)
$labelNomeArq.Size = New-Object System.Drawing.Size(200, 20)
$labelNomeArq.Text = "Nome do arquivo (sem .html):"
$form.Controls.Add($labelNomeArq)

# Campo para nome do arquivo
$textBoxFileName = New-Object System.Windows.Forms.TextBox
$textBoxFileName.Location = New-Object System.Drawing.Point(230, 422)
$textBoxFileName.Size = New-Object System.Drawing.Size(230, 25)
$form.Controls.Add($textBoxFileName)

# Botão para salvar HTML
$saveButton = New-Object System.Windows.Forms.Button
$saveButton.Location = New-Object System.Drawing.Point(180, 460)
$saveButton.Size = New-Object System.Drawing.Size(100, 35)
$saveButton.Text = "Salvar HTML"

$saveButton.Add_Click({
    $htmlContent = $textBoxHTML.Text
    $fileName = $textBoxFileName.Text.Trim()

    if (-not [string]::IsNullOrWhiteSpace($htmlContent) -and -not [string]::IsNullOrWhiteSpace($fileName)) {
        # Caminho da pasta cegonha
        $docsPath = [Environment]::GetFolderPath("MyDocuments")
        $targetFolder = Join-Path $docsPath "cegonha"

        # Cria pasta se não existir
        if (-not (Test-Path $targetFolder)) {
            New-Item -ItemType Directory -Path $targetFolder | Out-Null
        }

        # Gera nome do arquivo com timestamp
        $finalPath = Join-Path $targetFolder "$fileName.html"

        # Salva o conteúdo HTML
        Set-Content -Path $finalPath -Value $htmlContent -Encoding UTF8

        [System.Windows.Forms.MessageBox]::Show("Arquivo HTML salvo em:`n$finalPath", "Sucesso", "OK", "Information")
    } else {
        [System.Windows.Forms.MessageBox]::Show("Preencha o conteúdo HTML e o nome do arquivo.", "Aviso", "OK", "Warning")
    }
})
$form.Controls.Add($saveButton)

# Exibe tudo
$form.ShowDialog()

