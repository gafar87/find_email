@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ========================================
echo  Автоматическая настройка Git
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
    echo Или выполните команды вручную после установки Git:
    echo    git config --global user.name "gafar87"
    echo    git config --global user.email "gafar0112@gmail.com"
    echo.
    pause
    exit /b 1
)

echo [OK] Git найден
git --version
echo.

REM Настройка Git с сохраненными данными
echo ========================================
echo  Настройка Git:
echo ========================================
echo.

echo Установка имени: gafar87
git config --global user.name "gafar87"
if %errorlevel% == 0 (
    echo [OK] Имя установлено
) else (
    echo [ОШИБКА] Не удалось установить имя
)
echo.

echo Установка email: gafar0112@gmail.com
git config --global user.email "gafar0112@gmail.com"
if %errorlevel% == 0 (
    echo [OK] Email установлен
) else (
    echo [ОШИБКА] Не удалось установить email
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


