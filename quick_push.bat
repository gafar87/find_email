@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ========================================
echo  Быстрая отправка на GitHub
echo ========================================
echo.

REM Проверка Git
where git >nul 2>&1
if %errorlevel% neq 0 (
    echo [ОШИБКА] Git не установлен!
    pause
    exit /b 1
)

echo Текущее состояние:
echo.
git status --short
echo.

REM Проверка удаленного репозитория
git remote get-url origin >nul 2>&1
if %errorlevel% == 0 (
    echo Найден удаленный репозиторий:
    git remote get-url origin
    echo.
    echo Отправка коммитов...
    git push -u origin main
    if %errorlevel% == 0 (
        echo.
        echo [OK] Коммиты успешно отправлены на GitHub!
    ) else (
        echo.
        echo [ОШИБКА] Не удалось отправить
        echo Проверьте настройки доступа
    )
) else (
    echo [INFO] Удаленный репозиторий не настроен
    echo.
    echo Для настройки выполните:
    echo    git remote add origin https://github.com/ВАШ_USERNAME/НАЗВАНИЕ_РЕПОЗИТОРИЯ.git
    echo    git push -u origin main
    echo.
    echo Или запустите: push_to_remote.bat
    echo.
    echo Подробная инструкция в файле: НАСТРОЙКА_GITHUB.txt
)

echo.
pause

