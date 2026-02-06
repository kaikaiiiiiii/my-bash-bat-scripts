<# : chooser.bat
@ECHO OFF
chcp 65001
powershell -noprofile "iex (${%~f0} | out-string)"
goto :EOF

:: end Batch portion / begin PowerShell hybrid chimera #>

do {
    echo "Select Proxy:"
    echo "1. 127.0.0.1:7890"
    echo "2. 127.0.0.1:7890 - download through proxy"
    echo "3. install package through proxy"

    $choice = Read-Host "Select"

    switch ($choice) {
        1 {
            scoop config proxy 127.0.0.1:7890
            scoop update
            scoop config rm proxy
            scoop update *
            scoop cleanup *
            scoop cache rm *
        }
        2 {
            scoop config proxy 127.0.0.1:7890
            scoop update
            scoop update *
            scoop config rm proxy
            scoop cleanup *
            scoop cache rm *
        }
        3 {
            $packageName = Read-Host "Input package name"
            scoop config proxy 127.0.0.1:7890
            scoop update
            scoop search $packageName
            scoop install $packageName
            scoop config rm proxy
        }
        default {
            echo "Error input."  
        }
    }
} until ($choice -eq 1 -or $choice -eq 2 -or $choice -eq 3)

timeout /t 10
