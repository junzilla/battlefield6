@echo off
title ս��6-���CPUռ���ʹ��ߵ�����-���ߣ�Junzilla-�汾��20251023
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
echo  �����ս��6�У�CPUռ���ʹ��ߵ�����
echo.
echo  ===== ��� CPU =====
echo   �ںˣ������+С���ģ�������%CPU_Cores%
echo      �����������%CPU_P%
echo      С����������%CPU_E%
echo   �߼�������������%CPU_Threads%
if %HT_Bool% == 1 (
    echo   ���̣߳�����
) else (
    echo   ���̣߳��ر�
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
    echo   �ļ� user.cfg �����ɹ���
    echo   Job threads ����Ϊ��%CPU_Threads_Minus_2%
    echo.
    echo   �����ս��6���� [���� - ͼ�� - �߼� - ���ܵ��ӽ��� - ����]
    echo   ���Ͻ���ɫ����ĵ����к������� Job threads �Ƿ�һ�£����һ�£���ɹ���
    echo  ========================================================================
    echo.
    ) else (
    echo.
    echo  ===============
    echo   �ļ� user.cfg ����ʧ��!
    echo  ===============
    echo.
)
pause
exit

:error_0c
cls
echo.
echo ===========================
echo ���󣺴�Power Shell��ȡ��CPU��������Ϊ0
echo ===========================
echo.
echo.
pause
exit