# OPEN SERVER PROGRAMADO - http://localhost:8080

Add-Type -AssemblyName System.Web

$port = 8080
$listener = [System.Net.HttpListener]::new()
$listener.Prefixes.Add("http://*:$port/")
$listener.Start()
Write-Host "`n🟢 Servidor Pardal 23 rodando em: http://localhost:$port"

# Criar pasta para salvar HTMLs
$docPath = [Environment]::GetFolderPath("MyDocuments")
$saveFolder = Join-Path $docPath "PardalUploads"
if (-not (Test-Path $saveFolder)) {
    New-Item -ItemType Directory -Path $saveFolder | Out-Null
}

while ($true) {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response

    if ($request.HttpMethod -eq "GET") {
        $html = @"
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Pardal 23 - Salvar HTML</title>
</head>
<body style="font-family: sans-serif; padding: 40px; text-align: center;">
    <h1>🕊️ Pardal 23</h1>
    <p>Digite seu código HTML abaixo para salvar como arquivo</p>
    <form method="POST">
        <textarea name="inputData" rows="15" cols="80" placeholder="Cole aqui seu código HTML..."></textarea><br><br>
        <input type="submit" value="Salvar como .html">
    </form>
</body>
</html>
"@
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($html)
        $response.ContentType = "text/html"
        $response.ContentLength64 = $buffer.Length
        $response.OutputStream.Write($buffer, 0, $buffer.Length)
        $response.OutputStream.Close()
    }

    elseif ($request.HttpMethod -eq "POST") {
        # Ler conteúdo postado
        $reader = New-Object IO.StreamReader($request.InputStream, $request.ContentEncoding)
        $body = $reader.ReadToEnd()
        $reader.Close()

        # Extrair o valor do textarea (inputData)
        $parsed = [System.Web.HttpUtility]::ParseQueryString($body)
        $inputData = $parsed["inputData"]

        if (![string]::IsNullOrWhiteSpace($inputData)) {
            # Criar nome único
            $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
            $filename = "pagina_$timestamp.html"
            $filepath = Join-Path $saveFolder $filename

            # SALVAR o arquivo como HTML
            Set-Content -Path $filepath -Value $inputData -Encoding UTF8

            # Resposta HTML
            $resHtml = "<html><body><h2>✅ Arquivo salvo!</h2><p><strong>$filename</strong></p><a href='/'>🔙 Voltar</a></body></html>"
        }
        else {
            $resHtml = "<html><body><h2>⚠️ Nenhum conteúdo HTML foi enviado.</h2><a href='/'>🔙 Voltar</a></body></html>"
        }

        $buffer = [System.Text.Encoding]::UTF8.GetBytes($resHtml)
        $response.ContentType = "text/html"
        $response.ContentLength64 = $buffer.Length
        $response.OutputStream.Write($buffer, 0, $buffer.Length)
        $response.OutputStream.Close()
    }
}
