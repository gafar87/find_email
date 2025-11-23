@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ========================================
echo  Отправка коммитов в удаленный репозиторий
echo ========================================
echo.

REM Проверка наличия Git
where git >nul 2>&1
if %errorlevel% neq 0 (
    echo [ОШИБКА] Git не установлен в системе!
    echo.
    pause
    exit /b 1
)

REM Проверка наличия удаленного репозитория
git remote -v >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Удаленный репозиторий не настроен
    echo.
    echo ========================================
    echo  НАСТРОЙКА УДАЛЕННОГО РЕПОЗИТОРИЯ:
    echo ========================================
    echo.
    echo 1. Создайте репозиторий на GitHub/GitLab/Bitbucket
    echo.
    echo 2. Скопируйте URL репозитория (например):
    echo    https://github.com/username/repository.git
    echo    ИЛИ
    echo    git@github.com:username/repository.git
    echo.
    set /p REPO_URL="Введите URL удаленного репозитория: "
    if "!REPO_URL!"=="" (
        echo [ОШИБКА] URL не введен
        pause
        exit /b 1
    )
    
    echo.
    echo Добавление удаленного репозитория...
    git remote add origin "!REPO_URL!"
    if %errorlevel% neq 0 (
        echo [ОШИБКА] Не удалось добавить удаленный репозиторий
        echo Возможно, он уже существует. Попробуйте:
        echo    git remote set-url origin "!REPO_URL!"
        pause
        exit /b 1
    )
    echo [OK] Удаленный репозиторий добавлен
    echo.
)

REM Показываем текущие удаленные репозитории
echo ========================================
echo  Текущие удаленные репозитории:
echo ========================================
git remote -v
echo.

REM Проверяем текущую ветку
for /f "tokens=*" %%i in ('git branch --show-current') do set CURRENT_BRANCH=%%i
echo Текущая ветка: !CURRENT_BRANCH!
echo.

REM Показываем коммиты, которые будут отправлены
echo ========================================
echo  Коммиты для отправки:
echo ========================================
git log origin/!CURRENT_BRANCH!..HEAD --oneline 2>nul
if %errorlevel% neq 0 (
    echo (первая отправка)
)
echo.

REM Отправка
echo ========================================
echo  Отправка коммитов...
echo ========================================
echo.

git push -u origin !CURRENT_BRANCH!
if %errorlevel% neq 0 (
    echo.
    echo [ОШИБКА] Не удалось отправить коммиты
    echo.
    echo Возможные причины:
    echo - Неверный URL репозитория
    echo - Нет прав доступа
    echo - Требуется аутентификация
    echo.
    echo Для GitHub используйте Personal Access Token вместо пароля
    echo.
    pause
    exit /b 1
)

echo.
echo [OK] Коммиты успешно отправлены в удаленный репозиторий!
echo.
pause

