@ECHO OFF
CLS
COLOR 0A
TITLE Nginx PHP(CGI) MySQL 管理脚本 1.0
GOTO MENU_CHECKFILES

:MENU
	CLS 
	ECHO. 
	ECHO.  Nginx PHP(CGI) MySQL 管理脚本 1.0 ================================
	ECHO. 
	ECHO.  启动 [1] Nginx   [5] PHP(CGI)   [A] MySQL   [E] All
	ECHO. 
	ECHO.  关闭 [2] Nginx   [6] PHP(CGI)   [B] MySQL   [F] All
	ECHO.  
	ECHO.  重启 [3] Nginx   [7] PHP(CGI)   [C] MySQL   [G] All
	ECHO.
	ECHO.  查看 [4] Nginx   [8] PHP(CGI)   [D] MySQL   [H] All
	ECHO.
	ECHO.  [9] 退 出                       
	ECHO. 
	ECHO.  ==================================================================
	tasklist /nh|FIND /i "nginx.exe">nul
	IF NOT ERRORLEVEL 1 ECHO.  Nginx 正在运行 <nul
	tasklist /nh|FIND /i "php-cgi.exe">nul
	IF NOT ERRORLEVEL 1 ECHO.  PHP(CGI) 正在运行
	tasklist /nh|FIND /i "mysqld.exe">nul
	IF NOT ERRORLEVEL 1 ECHO.  MySQL 正在运行
	SET /p =. < nul
	SET /p =请输入操作序号后回车:<nul
	SET /p id= 
    IF "%id%"=="1" GOTO :cmd_startnginx
    IF "%id%"=="2" GOTO :cmd_stopnginx
    IF "%id%"=="3" GOTO :cmd_restartnginx
    IF "%id%"=="4" GOTO :cmd_statusnginx
	IF "%id%"=="5" GOTO :cmd_startphp-cgi
    IF "%id%"=="6" GOTO :cmd_stopphp-cgi
    IF "%id%"=="7" GOTO :cmd_restartphp-cgi
    IF "%id%"=="8" GOTO :cmd_statusphp-cgi
	IF "%id%"=="A" GOTO :cmd_startmysql
	IF "%id%"=="B" GOTO :cmd_stopmysql
	IF "%id%"=="C" GOTO :cmd_restartmysql
	IF "%id%"=="D" GOTO :cmd_statusmysql
	IF "%id%"=="E" GOTO :cmd_start
	IF "%id%"=="F" GOTO :cmd_stop
	IF "%id%"=="G" GOTO :cmd_restart
	IF "%id%"=="H" GOTO :cmd_status
    IF "%id%"=="9" EXIT 
	PAUSE
GOTO :MENU

:cmd_startnginx 
    CALL :start_nginx
    GOTO :MENU

:cmd_stopnginx
    CALL :shutdown_nginx
    GOTO :MENU 
    
:cmd_restartnginx
    CALL :shutdown_nginx
    CALL :start_nginx
    GOTO :MENU
    
:cmd_statusnginx
	ECHO.        映像名称   PID    线程   优先级 CPU             创建时间
    CALL :status_nginx
	ECHO.  请按任意键继续...
	PAUSE >nul
    GOTO :MENU
	
:cmd_startphp-cgi
    CALL :start_php-cgi
    GOTO :MENU

:cmd_stopphp-cgi
    CALL :shutdown_php-cgi
    GOTO :MENU 
    
:cmd_restartphp-cgi
    CALL :shutdown_php-cgi
    CALL :start_php-cgi
    GOTO :MENU
    
:cmd_statusphp-cgi
	ECHO.        映像名称   PID    线程   优先级 CPU             创建时间
    CALL :status_php-cgi
	ECHO.  请按任意键继续...
	PAUSE >nul
    GOTO :MENU
	
:cmd_startmysql
    CALL :start_mysql
    GOTO :MENU

:cmd_stopmysql
    CALL :shutdown_mysql
    GOTO :MENU 
    
:cmd_restartmysql
    CALL :shutdown_mysql
    CALL :start_mysql
    GOTO :MENU
    
:cmd_statusmysql
	ECHO.        映像名称   PID    线程   优先级 CPU             创建时间
    CALL :status_mysql
	ECHO.  请按任意键继续...
	PAUSE >nul
    GOTO :MENU
	
:cmd_start
    CALL :start_nginx
	CALL :start_php-cgi
	CALL :start_mysql
    GOTO :MENU

:cmd_stop
    CALL :shutdown_nginx
	CALL :shutdown_php-cgi
	CALL :shutdown_mysql
    GOTO :MENU 
    
:cmd_restart
    CALL :shutdown_nginx
    CALL :start_nginx
	CALL :shutdown_php-cgi
    CALL :start_php-cgi
	CALL :shutdown_mysql
    CALL :start_mysql
    GOTO :MENU
    
:cmd_status
	ECHO.        映像名称   PID    线程   优先级 CPU             创建时间
    CALL :status_nginx
	CALL :status_php-cgi
	CALL :status_mysql
	ECHO.  请按任意键继续...
	PAUSE >nul
    GOTO :MENU

:MENU_CHECKFILES
	CALL :checksystemos
    CALL :checkfiles
    GOTO :MENU

:start_nginx
    ECHO.
    ECHO.  正在启动 Nginx......
    IF EXIST nginx.exe (
        RunHiddenConsole.exe nginx.exe
    )
	tasklist /nh|FIND /i "nginx.exe">nul
	IF NOT ERRORLEVEL 1 ECHO.  Nginx 已经启动 <nul
    CALL :sleep
GOTO :EOF

:shutdown_nginx
    ECHO. 
    ECHO.  正在关闭 Nginx......
    Process.exe -k nginx.exe>nul
	tasklist /nh|FIND /i "nginx.exe">nul
	IF ERRORLEVEL 1 ECHO.  Nginx 已经关闭 <nul
    CALL :sleep
GOTO :EOF

:status_nginx
    Process.exe  -c | findstr "nginx.exe"
GOTO :EOF

:start_php-cgi
	ECHO.
	ECHO.  正在启动 PHP(CGI)
	IF EXIST php/php-cgi.exe (
        RunHiddenConsole.exe php/php-cgi.exe -b 127.0.0.1:9000 -c php/php.ini
    )
	tasklist /nh|FIND /i "php-cgi.exe">nul
	IF NOT ERRORLEVEL 1 ECHO.  PHP(CGI) 已经启动 <nul
    CALL :sleep
GOTO :EOF

:shutdown_php-cgi
	ECHO. 
    ECHO.  正在关闭 PHP(CGI)......
    Process.exe -k php-cgi.exe>nul
	tasklist /nh|FIND /i "php-cgi.exe">nul
	IF ERRORLEVEL 1 ECHO.  PHP(CGI) 已经关闭 <nul
    CALL :sleep
GOTO :EOF

:status_php-cgi
    Process.exe -c | findstr "php-cgi.exe"
GOTO :EOF

:start_mysql
	ECHO.
	ECHO.  正在启动 MySQL
	IF EXIST mysql/bin/mysqld.exe (
        RunHiddenConsole.exe mysql\bin\mysqld --defaults-file=mysql\my.ini --standalone --console
    )
    tasklist /nh|FIND /i "mysqld.exe">nul
	IF NOT ERRORLEVEL 1 ECHO.  MySQL 已经启动 <nul
    CALL :sleep
GOTO :EOF

:shutdown_mysql
	ECHO. 
    ECHO.  正在关闭 MySQL......
    Process.exe -k mysqld.exe>nul
	tasklist /nh|FIND /i "mysqld.exe">nul
	IF ERRORLEVEL 1 ECHO.  MySQL 已经关闭 <nul
    CALL :sleep
GOTO :EOF

:status_mysql
    Process.exe -c | findstr "mysqld.exe"
GOTO :EOF

:checkfiles
    ECHO.
    ECHO.  正在检查必需文件......
    IF NOT EXIST nginx.exe (
        ECHO nginx.exe 不存在
        PAUSE
        EXIT
    )
    IF NOT EXIST Process.exe (
        ECHO Process.exe 不存在
        PAUSE
        EXIT
    )
    IF NOT EXIST RunHiddenConsole.exe (
        ECHO RunHiddenConsole.exe 不存在
        PAUSE
        EXIT
    )
	IF NOT EXIST php/php-cgi.exe (
        ECHO php/php-cgi.exe 不存在
        PAUSE
        EXIT
    )
	IF NOT EXIST php/php.ini (
        ECHO php/php.ini 不存在
        PAUSE
        EXIT
    )
	IF NOT EXIST mysql/bin/mysqld.exe (
        ECHO mysql/bin/mysqld.exe 不存在
        PAUSE
        EXIT
    )
	IF NOT EXIST mysql/my.ini (
        ECHO mysql/my.ini 不存在
        PAUSE
        EXIT
    )
    ECHO.  必需文件检查完成
    CALL :sleep
GOTO :EOF

:checksystemos
	VER|FIND "5.0" >nul
	IF NOT ERRORLEVEL 1 GOTO :win2000
	VER|FIND "5.1" >nul
	IF NOT ERRORLEVEL 1 GOTO :winxp
	VER|FIND "5.2" >nul
	IF NOT ERRORLEVEL 1 GOTO :win2003
	VER|FIND "6.0" >nul
	IF NOT ERRORLEVEL 1 GOTO :winvista
	VER|FIND "6.1" >nul
	IF NOT ERRORLEVEL 1 GOTO :win7
	VER|FIND "6.2" >nul
	IF NOT ERRORLEVEL 1 GOTO :win8
	VER|FIND "6.3" >nul
	IF NOT ERRORLEVEL 1 GOTO :win8.1
	VER|FIND "6.4" >nul
	IF NOT ERRORLEVEL 1 GOTO :win10
	VER|FIND "10" >nul
	IF NOT ERRORLEVEL 1 GOTO :win10
	(GOTO :unknown)
GOTO :EOF
:win2000
	ECHO.  Windows 2000
	CALL :checksystembit
GOTO :EOF
:winxp
	ECHO.  Windows xp
	CALL :checksystembit
GOTO :EOF
:win2003
	ECHO.  Windows Server 2003(Windows Server 2003R2)
	CALL :checksystembit
GOTO :EOF
:winvista
	ECHO.  Windows Vista(Windows Server 2008)
	CALL :checksystembit
GOTO :EOF
:win7
	ECHO.  Windows 7(Windows Server 2008R2)
	CALL :checksystembit
GOTO :EOF
:win8
	ECHO.  Windows 8(Windows Server 2012)
	CALL :checksystembit
GOTO :EOF
:win8.1
	ECHO.  Windows 8.1(Windows Server 2012R2)
	CALL :checksystembit
GOTO :EOF
:win10
	ECHO.  Windows 10
	CALL :checksystembit
GOTO :EOF
:unknown
	ECHO.  Unknown OS.
	CALL :checksystembit
GOTO :EOF

:checksystembit
	IF /i "%PROCESSOR_IDENTIFIER:~0,3%"=="X86" (GOTO :X86) ELSE (GOTO :X64)
GOTO :EOF
:X86
	ECHO.  32 位
GOTO :EOF
:X64
	ECHO.  64 位
GOTO :EOF

:sleep
    PING -n 2 127.0.0.1 >nul
GOTO :EOF