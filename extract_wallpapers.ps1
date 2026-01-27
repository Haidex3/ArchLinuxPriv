$REPKG = ".\RePKG.exe"
$DEST  = "C:\Users\hairo\OneDrive\Documentos\Git\ArchLinuxPriv\Images"

New-Item -ItemType Directory -Force -Path $DEST | Out-Null

Get-ChildItem -Filter "*.scene.pkg" | ForEach-Object {

    $pkg  = $_.FullName
    $name = $_.BaseName

    Write-Host "Procesando $name ..."

    if (Test-Path "output") {
        Remove-Item -Recurse -Force "output"
    }

    & $REPKG extract $pkg -t --overwrite | Out-Null

    $materials = "output\materials"

    if (Test-Path $materials) {

        $image = Get-ChildItem $materials -Recurse -Include *.jpg,*.png |
                 Sort-Object Length -Descending |
                 Select-Object -First 1

        if ($image) {
            $destFile = Join-Path $DEST ($name + $image.Extension)
            Copy-Item $image.FullName $destFile -Force
            Write-Host "  Imagen copiada -> $destFile"
        }
        else {
            Write-Host "  No se encontro imagen valida"
        }
    }
    else {
        Write-Host "  No existe output/materials"
    }
}

Write-Host ""
Write-Host "Proceso terminado."
