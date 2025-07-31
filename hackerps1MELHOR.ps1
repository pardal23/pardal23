# Define search queries
$searchQueries = @(
    "site:santander.pt filetype:pdf",
    "site:santander.pt filetype:xlsx",
    "site:santander.pt filetype:docx",
    "site:santander.pt filetype:txt",
    "site:santander.pt filetype:login",
    "site:santander.pt filetype:documentos",
    "site:santander.pt filetype:tabelas-users",
    "site:santander.pt filetype:contactos"
)

# Output file for results
$outputFile = "search_results.csv"
"Query,URL" | Out-File -FilePath $outputFile -Encoding UTF8

# Loop through queries
foreach ($query in $searchQueries) {
    $escapedQuery = [uri]::EscapeDataString($query)
    $searchUrl = "https://www.google.com/search?q=$escapedQuery"

    try {
        # Simulate a request (replace with actual scraping logic)
        Write-Output "Searching for: $query"
        Start-Process $searchUrl

        # Example: Extract links from the page (pseudo-code)
        # $response = Invoke-WebRequest -Uri $searchUrl
        # $links = $response.Links | Where-Object { $_.href -match "\.(pdf|xlsx|docx|txt)$" }
        # $links | ForEach-Object { "$query,$($_.href)" | Out-File -FilePath $outputFile -Append -Encoding UTF8 }

        # Add delay to avoid rate limiting
        Start-Sleep -Seconds 5
    } catch {
        Write-Output "Error processing query: $query. Error: $_"
    }
}

Write-Output "Results saved to $outputFile"