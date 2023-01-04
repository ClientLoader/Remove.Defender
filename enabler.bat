@echo off

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (
    goto UACPrompt
) else ( goto main )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\exec.vbs"
    set params = %*:"="
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\exec.vbs"

    "%temp%\exec.vbs"
    del "%temp%\exec.vbs"
    exit /B

:main
echo msgbox "This might take some time for all of this to fully finish, feel free to work on other stuff while it's running" > %tmp%\tmp.vbs
wscript %tmp%\tmp.vbs
del %tmp%\tmp.vbs

cd %temp%

takeown /f "%SYSTEMROOT%\System32\smartscreen.exe" /a

icacls "%SYSTEMROOT%\System32\smartscreen.exe" /reset

icacls "%SYSTEMROOT%\System32\smartscreen.exe" /setowner *S-1-5-80-956008885-3418522649-1831038044-1853292631-2271478464

reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableRegistryTools" /f

reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableTaskMgr" /f

reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableCMD" /f

reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRun" /f

sfc /scannow

DISM /Online /Cleanup-Image /StartComponentCleanup

DISM /Online /Cleanup-Image /RestoreHealth