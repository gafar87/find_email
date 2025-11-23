@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ========================================
echo  Извлечение email адресов из документов
echo ========================================
echo.

REM Поиск Python
set PYTHON_CMD=
where python >nul 2>&1
if %errorlevel% == 0 (
    set PYTHON_CMD=python
    goto :found_python
)

where python3 >nul 2>&1
if %errorlevel% == 0 (
    set PYTHON_CMD=python3
    goto :found_python
)

where py >nul 2>&1
if %errorlevel% == 0 (
    set PYTHON_CMD=py
    goto :found_python
)

echo [ОШИБКА] Python не найден в системе!
echo.
echo Пожалуйста, установите Python 3.7 или выше:
echo 1. Скачайте с https://www.python.org/downloads/
echo 2. При установке обязательно отметьте "Add Python to PATH"
echo 3. После установки перезапустите этот файл
echo.
pause
exit /b 1

:found_python
echo [OK] Найден Python: %PYTHON_CMD%
%PYTHON_CMD% --version
echo.

REM Поиск pip
set PIP_CMD=
where pip >nul 2>&1
if %errorlevel% == 0 (
    set PIP_CMD=pip
    goto :found_pip
)

where pip3 >nul 2>&1
if %errorlevel% == 0 (
    set PIP_CMD=pip3
    goto :found_pip
)

REM Пытаемся использовать pip через python -m
%PYTHON_CMD% -m pip --version >nul 2>&1
if %errorlevel% == 0 (
    set PIP_CMD=%PYTHON_CMD% -m pip
    goto :found_pip
)

echo [ОШИБКА] pip не найден!
echo.
echo Попытка установить pip через Python...
%PYTHON_CMD% -m ensurepip --upgrade
if %errorlevel% == 0 (
    set PIP_CMD=%PYTHON_CMD% -m pip
    goto :found_pip
)

echo [ОШИБКА] Не удалось найти или установить pip
echo.
pause
exit /b 1

:found_pip
echo [OK] Найден pip
echo.

REM Установка зависимостей
echo ========================================
echo  Установка зависимостей...
echo ========================================
echo.

%PIP_CMD% install -r requirements.txt
if %errorlevel% neq 0 (
    echo.
    echo [ОШИБКА] Не удалось установить зависимости
    echo Попробуйте установить вручную:
    echo %PIP_CMD% install -r requirements.txt
    echo.
    pause
    exit /b 1
)

echo.
echo [OK] Зависимости установлены
echo.

REM Запуск программы
echo ========================================
echo  Запуск программы...
echo ========================================
echo.

%PYTHON_CMD% find_emails.py

if %errorlevel% neq 0 (
    echo.
    echo [ОШИБКА] Программа завершилась с ошибкой
    echo.
    pause
    exit /b 1
)

echo.
pause

