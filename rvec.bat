@echo off
setlocal enabledelayedexpansion

::Где искать конфиг.файлы
set conf_path=C:\rvec\conf
::Где лежит скрипт запуска
set start_path=C:\rvec\server\bin
::Какой редактор использовать, например "C:\Program Files\Sublime Text 2\sublime_text.exe"
set editor=notepad
::Шаблон конфиг.файла
set template_conf=C:\rvec\conf\template.rb
::Конфиг.файл по умолчанию
set default_conf_file=ems_dsp_zhul.rb
::Фильтр отображаемых конфиг.файлов, например ems_dsp_
set filter=

if [%1] == [/c] (
	echo all=%*
	if [%2] == [] (
		set conf_file=%default_conf_file%
	) else (
		set conf_file=%2
	)
	goto begin
)

if [%1] == [/f] (
	set filter=%2
)

set q=1
echo Found files:
for /f "tokens=*" %%i in ('dir /a /b /s "%conf_path%\%filter%*.rb"') do (
    echo !q!^) %%~nxi
    set /a q+=1
)
echo 0^) Exit
echo +^) If you want to create new file
echo.
	
set choice=0
set /p choice="Your choice:"

if !choice! == 0 Exit
if !choice! == + (
	%editor% %template_conf%
	Exit
)

set q=1
set conf_file=""
for /f "tokens=*" %%i in ('dir /a /b /s "%conf_path%\%filter%*.rb"') do (
	if !q! EQU %choice% (
		set conf_file=%%~nxi
	)
    set /a q+=1
)

:begin
echo.
echo Loading %conf_file%...
echo.

set RVEC_MEMORY_OPT=-J-Xms2048m -J-Xmx2048m
set JRUBY_HOME=C:\jruby-1.7.4
set JAVA_HOME=C:\Program Files\Java\jdk1.7.0_51
set PATH=C:\jruby-1.7.4\bin
call %start_path%\start.bat -C -A"Designer" -D"%conf_path%\%conf_file%" -U"su" -P"super user"