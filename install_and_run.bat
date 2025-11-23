@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ========================================
echo  Извлечение email адресов из документов
echo ========================================
echo.

REM Поиск Python - пробуем разные варианты
set PYTHON_CMD=
set PYTHON_FOUND=0

echo Поиск Python в системе...
echo.

REM Вариант 1: python
where python >nul 2>&1
if %errorlevel% == 0 (
    python --version >nul 2>&1
    if %errorlevel% == 0 (
        set PYTHON_CMD=python
        set PYTHON_FOUND=1
        goto :python_found
    )
)

REM Вариант 2: python3
where python3 >nul 2>&1
if %errorlevel% == 0 (
    python3 --version >nul 2>&1
    if %errorlevel% == 0 (
        set PYTHON_CMD=python3
        set PYTHON_FOUND=1
        goto :python_found
    )
)

REM Вариант 3: py (Python Launcher для Windows)
where py >nul 2>&1
if %errorlevel% == 0 (
    py --version >nul 2>&1
    if %errorlevel% == 0 (
        set PYTHON_CMD=py
        set PYTHON_FOUND=1
        goto :python_found
    )
)

REM Вариант 4: Прямой путь к Python (стандартные места установки)
if exist "C:\Python3*\python.exe" (
    for /d %%i in ("C:\Python3*") do (
        if exist "%%i\python.exe" (
            set PYTHON_CMD=%%i\python.exe
            set PYTHON_FOUND=1
            goto :python_found
        )
    )
)

if exist "%LOCALAPPDATA%\Programs\Python\Python3*\python.exe" (
    for /d %%i in ("%LOCALAPPDATA%\Programs\Python\Python3*") do (
        if exist "%%i\python.exe" (
            set PYTHON_CMD=%%i\python.exe
            set PYTHON_FOUND=1
            goto :python_found
        )
    )
)

if exist "%ProgramFiles%\Python3*\python.exe" (
    for /d %%i in ("%ProgramFiles%\Python3*") do (
        if exist "%%i\python.exe" (
            set PYTHON_CMD=%%i\python.exe
            set PYTHON_FOUND=1
            goto :python_found
        )
    )
)

:python_found
if %PYTHON_FOUND% == 0 (
    echo [ОШИБКА] Python не найден в системе!
    echo.
    echo ========================================
    echo  ЧТО ДЕЛАТЬ:
    echo ========================================
    echo.
    echo 1. Установите Python с официального сайта:
    echo    https://www.python.org/downloads/
    echo.
    echo 2. ВАЖНО: При установке обязательно отметьте
    echo    галочку "Add Python to PATH" (внизу окна)
    echo.
    echo 3. После установки перезапустите этот файл
    echo.
    echo 4. Или откройте файл ИНСТРУКЦИЯ_ПО_УСТАНОВКЕ.txt
    echo    для подробных инструкций
    echo.
    pause
    exit /b 1
)

echo [OK] Найден Python: %PYTHON_CMD%
%PYTHON_CMD% --version
echo.

REM Поиск pip
echo Поиск pip...
set PIP_CMD=
set PIP_FOUND=0

REM Вариант 1: pip
where pip >nul 2>&1
if %errorlevel% == 0 (
    pip --version >nul 2>&1
    if %errorlevel% == 0 (
        set PIP_CMD=pip
        set PIP_FOUND=1
        goto :pip_found
    )
)

REM Вариант 2: pip3
where pip3 >nul 2>&1
if %errorlevel% == 0 (
    pip3 --version >nul 2>&1
    if %errorlevel% == 0 (
        set PIP_CMD=pip3
        set PIP_FOUND=1
        goto :pip_found
    )
)

REM Вариант 3: pip через python -m
%PYTHON_CMD% -m pip --version >nul 2>&1
if %errorlevel% == 0 (
    set PIP_CMD=%PYTHON_CMD% -m pip
    set PIP_FOUND=1
    goto :pip_found
)

REM Пытаемся установить pip
echo [INFO] pip не найден, пытаюсь установить...
%PYTHON_CMD% -m ensurepip --upgrade --default-pip >nul 2>&1
if %errorlevel% == 0 (
    %PYTHON_CMD% -m pip --version >nul 2>&1
    if %errorlevel% == 0 (
        set PIP_CMD=%PYTHON_CMD% -m pip
        set PIP_FOUND=1
        goto :pip_found
    )
)

:pip_found
if %PIP_FOUND% == 0 (
    echo [ОШИБКА] pip не найден и не может быть установлен автоматически
    echo.
    echo Попробуйте установить зависимости вручную:
    echo %PYTHON_CMD% -m pip install -r requirements.txt
    echo.
    pause
    exit /b 1
)

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
    echo.
    echo Попробуйте установить вручную:
    echo %PIP_CMD% install -r requirements.txt
    echo.
    echo Или установите каждую библиотеку отдельно:
    echo %PIP_CMD% install python-docx openpyxl PyPDF2 python-pptx xlrd
    echo.
    pause
    exit /b 1
)

echo.
echo [OK] Все зависимости успешно установлены!
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
    echo Попробуйте запустить вручную:
    echo %PYTHON_CMD% find_emails.py
    echo.
    pause
    exit /b 1
)

echo.
echo Программа завершена.
pause

