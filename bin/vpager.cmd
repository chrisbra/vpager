@echo off
REM See https://github.com/skywind3000/vim-terminal-help/blob/master/tools/utils/drop.cmd
setlocal EnableDelayedExpansion

if "%1" NEQ "-e" GOTO help
if "%2" == "" GOTO help
if "%VIM_EXE%" == "" GOTO missing

REM Get absolute name
for /f "delims=" %%i in ("%2") do set "NAME=%%~fi"
REM echo fullpath: %NAME%

if "%NVIM_LISTEN_ADDRESS%" == "" GOTO vim
goto neovim

:vim
call "%VIM_EXE%" --servername "%VIM_SERVERNAME%" --remote-expr "drop '%NAME%'"
goto end

:neovim
call "nvr" --servername "%VIM_SERVERNAME%" --remote-expr "drop '%NAME%'"
goto end

:nonvr
echo missing nvr, please install neovim-remote
goto end

:help
echo usage: vpager -e {filename}
goto end

:missing
echo please call inside a terminal in vim/neovim
goto end

:end

