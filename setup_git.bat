@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ========================================
echo  Настройка Git (имя и email)
echo ========================================
echo.

REM Проверка наличия Git
where git >nul 2>&1
if %errorlevel% neq 0 (
    echo [ОШИБКА] Git не установлен в системе!
    echo.
    echo ========================================
    echo  УСТАНОВКА GIT:
    echo ========================================
    echo.
    echo 1. Скачайте Git с официального сайта:
    echo    https://git-scm.com/download/win
    echo.
    echo 2. Установите Git (используйте настройки по умолчанию)
    echo.
    echo 3. После установки перезапустите этот скрипт
    echo.
    echo Или настройте Git вручную после установки:
    if exist "git_settings.txt" (
        echo    git config --global user.name "gafar87"
        echo    git config --global user.email "gafar0112@gmail.com"
    ) else (
        echo    git config --global user.name "Ваше Имя"
        echo    git config --global user.email "your.email@example.com"
    )
    echo.
    pause
    exit /b 1
)

echo [OK] Git найден
git --version
echo.

REM Показываем текущие настройки
echo ========================================
echo  Текущие настройки:
echo ========================================
git config --global user.name 2>nul
if %errorlevel% neq 0 (
    echo Имя: не настроено
) else (
    echo Имя: 
    git config --global user.name
)

git config --global user.email 2>nul
if %errorlevel% neq 0 (
    echo Email: не настроено
) else (
    echo Email: 
    git config --global user.email
)
echo.

REM Читаем сохраненные настройки из файла (если есть)
set SAVED_NAME=
set SAVED_EMAIL=
if exist "git_settings.txt" (
    for /f "tokens=2" %%a in ('findstr /c:"Имя:" git_settings.txt') do set SAVED_NAME=%%a
    for /f "tokens=2" %%a in ('findstr /c:"Email:" git_settings.txt') do set SAVED_EMAIL=%%a
)

REM Запрашиваем новые настройки
echo ========================================
echo  Введите новые настройки:
echo ========================================
echo.

if not "!SAVED_NAME!"=="" (
    echo [INFO] Найдены сохраненные настройки: !SAVED_NAME! / !SAVED_EMAIL!
    echo.
    set /p USE_SAVED="Использовать сохраненные настройки? (Y/N, по умолчанию Y): "
    if /i "!USE_SAVED!"=="N" (
        set USE_SAVED=
    ) else (
        set USE_SAVED=Y
    )
    echo.
)

if /i "!USE_SAVED!"=="Y" (
    set GIT_NAME=!SAVED_NAME!
    set GIT_EMAIL=!SAVED_EMAIL!
    echo [INFO] Используются сохраненные настройки
) else (
    if not "!SAVED_NAME!"=="" (
        set /p GIT_NAME="Введите ваше имя [по умолчанию: !SAVED_NAME!]: "
        if "!GIT_NAME!"=="" set GIT_NAME=!SAVED_NAME!
    ) else (
        set /p GIT_NAME="Введите ваше имя (или нажмите Enter чтобы оставить текущее): "
    )
    
    if not "!SAVED_EMAIL!"=="" (
        set /p GIT_EMAIL="Введите ваш email [по умолчанию: !SAVED_EMAIL!]: "
        if "!GIT_EMAIL!"=="" set GIT_EMAIL=!SAVED_EMAIL!
    ) else (
        set /p GIT_EMAIL="Введите ваш email (или нажмите Enter чтобы оставить текущее): "
    )
)

if not "!GIT_NAME!"=="" (
    git config --global user.name "!GIT_NAME!"
    echo [OK] Имя установлено: !GIT_NAME!
) else (
    echo [INFO] Имя не изменено
)
echo.

if not "!GIT_EMAIL!"=="" (
    git config --global user.email "!GIT_EMAIL!"
    echo [OK] Email установлен: !GIT_EMAIL!
) else (
    echo [INFO] Email не изменен
)
echo.

REM Показываем итоговые настройки
echo ========================================
echo  Итоговые настройки:
echo ========================================
echo.
echo Имя: 
git config --global user.name
echo Email: 
git config --global user.email
echo.

echo [OK] Настройка Git завершена!
echo.
pause

