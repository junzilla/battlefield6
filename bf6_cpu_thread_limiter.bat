@echo off
title 战地6-解决CPU占用率过高的问题-作者：Junzilla-版本：20251023
set "CPU_Cores=0"
set "CPU_Threads=0"
set "CPU_E=0"
set "UserCFGFileCDDir=%~dp0"
set "UserCFGFileName=user.cfg"
set "UserCFGFile=%UserCFGFileCDDir%%UserCFGFileName%"
for /f "tokens=*" %%a in ('powershell -Command "Get-CimInstance -ClassName Win32_Processor | Select-Object -ExpandProperty NumberOfCores"') do set "CPU_Cores=%%a"
for /f "tokens=*" %%a in ('powershell -Command "Get-CimInstance -ClassName Win32_Processor | Select-Object -ExpandProperty NumberOfLogicalProcessors"') do set "CPU_Threads=%%a"
if %CPU_Cores% == 0 goto error_0c
set /a "CPU_P=CPU_Threads-CPU_Cores"
set /a "CPU_E=CPU_Cores-CPU_P"
set /a "HT_Check=CPU_P*2+CPU_E"
if %HT_Check%==%CPU_Threads% (
    set "HT_Bool=1"
) else (
    set "HT_Bool=0"
)
set /a "CPU_Threads_Minus_2=CPU_Cores-2"
echo.
echo  解决在战地6中，CPU占用率过高的问题
echo.
echo  ===== 你的 CPU =====
echo   内核（大核心+小核心）数量：%CPU_Cores%
echo      大核心数量：%CPU_P%
echo      小核心数量：%CPU_E%
echo   逻辑处理器数量：%CPU_Threads%
if %HT_Bool% == 1 (
    echo   超线程：开启
) else (
    echo   超线程：关闭
)
echo  ====================
REM Create user.cfg
if exist "%UserCFGFile%" (
    if exist "%UserCFGFileCDDir%%UserCFGFileName%.bak" (
        del "%UserCFGFile%" /q /f
    ) else (
        rename "%UserCFGFileCDDir%%UserCFGFileName%" "%UserCFGFileName%.bak"
    )   
)
echo Thread.ProcessorCount %CPU_Cores% >> "%UserCFGFile%"
echo Thread.MaxProcessorCount %CPU_P% >> "%UserCFGFile%"
echo Thread.MinFreeProcessorCount 0 >> "%UserCFGFile%"
echo Thread.JobThreadPriority 0 >> "%UserCFGFile%"
echo GstRender.Thread.MaxProcessorCount 6 >> "%UserCFGFile%"
if exist "%UserCFGFile%" (
    echo.
    echo  ========================================================================
    echo   文件 user.cfg 创建成功！
    echo   Job threads 设置为：%CPU_Threads_Minus_2%
    echo.
    echo   请进入战地6，打开 [设置 - 图像 - 高级 - 性能叠加界面 - 额外]
    echo   左上角绿色字体的第三行和上述的 Job threads 是否一致，如果一致，则成功！
    echo  ========================================================================
    echo.
    ) else (
    echo.
    echo  ===============
    echo   文件 user.cfg 创建失败!
    echo  ===============
    echo.
)
pause
exit

:error_0c
cls
echo.
echo ===========================
echo 错误：从Power Shell读取到CPU核心数量为0
echo ===========================
echo.
echo.
pause
exit