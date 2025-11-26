@echo off
setlocal
title 完美平台和eNSP冲突修复工具 - by qiuxtao
color 0A

:: ==============================
:: 自动获取管理员权限
:: ==============================
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo 正在请求管理员权限...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

:: ==============================
:: 配置区域
:: ==============================
set "TARGET_PROCESS=完美世界竞技平台.exe"
set "TARGET_SERVICE=MessageTransfer"
set "ENSP_PATH=C:\Program Files\Huawei\eNSP\eNSP_Client.exe"

:: ==============================
:: 检测进程并询问
:: ==============================
echo.
echo [1/3] 正在检测完美世界竞技平台进程...

tasklist | find /i "%TARGET_PROCESS%" >nul
if %errorlevel%==0 (
    echo.
    echo ================================================================
    echo  检测到完美平台正在运行。
    echo  为了避免冲突，建议关闭进程。
    echo ================================================================
    echo.
    
    :: 设置默认值为 Y，如果用户直接回车，变量保持为 Y
    set "KillProcess=Y"
    set /p "KillProcess=是否关闭完美平台进程? [Y/n] (默认Y，直接回车即可): "
    
    :: 判断用户输入 (不区分大小写)
    if /i "!KillProcess!"=="N" (
        goto UserSelectedNo
    ) else (
        :: 这里的逻辑是：除非用户明确输入 N，否则都执行关闭（包括 Y 或 回车）
        goto KillIt
    )
) else (
    echo [状态] 未检测到完美平台主程序，继续下一步。
    goto CheckService
)

:UserSelectedNo
echo.
echo [操作] 你选择了“否”。
echo        为避免完美反作弊出现问题，脚本将跳过服务停止操作。
goto EndOps

:KillIt
echo.
echo [操作] 正在结束完美平台进程...
taskkill /F /IM "%TARGET_PROCESS%"
echo 进程清理完毕。

:: ==============================
:: 4. 处理冲突服务 MessageTransfer
:: ==============================
:CheckService
echo.
echo [2/3] 正在检查冲突服务: %TARGET_SERVICE%

sc query "%TARGET_SERVICE%" | find "RUNNING" >nul
if %errorlevel%==0 (
    echo.
    echo [状态] 服务正在运行，准备停止...
    net stop "%TARGET_SERVICE%"
    echo.
    echo [成功] 服务已停止！eNSP 环境已准备就绪。
) else (
    echo.
    echo [状态] 服务未运行或已停止。无需操作。
)

:: ==============================
:: 5. 启动 eNSP 询问 (脚本结束部分)
:: ==============================
:EndOps
echo.
echo ----------------------------------------
echo.
echo [3/3] 准备启动 eNSP

if not exist "%ENSP_PATH%" (
    echo [错误] 未找到 eNSP 主程序，路径可能不正确：
    echo %ENSP_PATH%
    echo.
    echo 按任意键退出...
    pause >nul
    exit
)

:: 询问是否启动 eNSP，默认为 Y
set "StartENSP=Y"
set /p "StartENSP=是否立即启动 eNSP? [Y/n] (默认Y，直接回车即可): "

if /i "%StartENSP%"=="N" (
    :: 如果选 N，直接退出
    exit
)

:: 默认情况（Y 或者 回车），启动程序
echo.
echo [操作] 正在启动 eNSP，脚本即将退出...
start "" "%ENSP_PATH%"
exit