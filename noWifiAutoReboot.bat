ping 192.168.0.1
IF ERRORLEVEL 1 (echo %DATE% %TIME% >> reboot.log & SHUTDOWN -R -T 00)