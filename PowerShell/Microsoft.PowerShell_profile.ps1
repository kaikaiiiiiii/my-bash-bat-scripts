function wakeFang {
    param (
        [int]$total = 100,
        [int]$delayMs = 50
    )

    $mac = "A8:A1:59:82:09:DF"
    $broadcast = "255.255.255.255"
    $port = 9

    $macBytes = $mac -split "[:-]" | ForEach-Object {
        [byte]("0x$_")
    }

    $packet = (,[byte]0xFF * 6) + ($macBytes * 16)

    $udp = [System.Net.Sockets.UdpClient]::new()
    $udp.Connect($broadcast, $port)

    for ($i = 1; $i -le $total; $i++) {
        [void]$udp.Send($packet, $packet.Length)

        if ($i % 10 -eq 0) {
            Write-Host "$i/$total Wake Calls"
        }

        Start-Sleep -Milliseconds $delayMs
    }

    $udp.Close()
}


function agp {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $commitMessage = "update $timestamp"
    
    Write-Host "正在添加所有更改..." -ForegroundColor Yellow
    git add .
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "添加文件失败！" -ForegroundColor Red
        return
    }
    
    Write-Host "正在提交更改: $commitMessage" -ForegroundColor Yellow
    git commit -am $commitMessage
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "提交失败！" -ForegroundColor Red
        return
    }
    
    Write-Host "正在推送到远程仓库..." -ForegroundColor Yellow
    git push
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ 所有操作完成！" -ForegroundColor Green
    } else {
        Write-Host "推送失败！" -ForegroundColor Red
    }
}