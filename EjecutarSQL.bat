@echo off
setlocal

set SERVER=DESKTOP-OPKFGCA
set DATABASE=TrackingBD
set AUTHORIZATION_PATH=H:\Proyectos\TrackingApp\TracikingAppDataBase\Authorization
set CODERESET_PATH=H:\Proyectos\TrackingApp\TracikingAppDataBase\CodeReset
set CONFIDENCECONTACTS_PATH=H:\Proyectos\TrackingApp\TracikingAppDataBase\ConfidenceContacts
set MAPS_PATH=H:\Proyectos\TrackingApp\TracikingAppDataBase\Maps
set USER_PATH=H:\Proyectos\TrackingApp\TracikingAppDataBase\User

echo === Ejecutando Estructura.sql ===
sqlcmd -S %SERVER% -d %DATABASE% -E -i "H:\Proyectos\TrackingApp\TracikingAppDataBase\Estructura.sql"

echo === Ejecutando scripts de Authorization ===
for %%f in (%AUTHORIZATION_PATH%\*.sql) do (
    echo Ejecutando %%f ...
    sqlcmd -S %SERVER% -d %DATABASE% -E -i "%%f"
)

for %%f in (%CODERESET_PATH%\*.sql) do (
    echo Ejecutando %%f ...
    sqlcmd -S %SERVER% -d %DATABASE% -E -i "%%f"
)

for %%f in (%CONFIDENCECONTACTS_PATH%\*.sql) do (
    echo Ejecutando %%f ...
    sqlcmd -S %SERVER% -d %DATABASE% -E -i "%%f"
)

for %%f in (%MAPS_PATH%\*.sql) do (
    echo Ejecutando %%f ...
    sqlcmd -S %SERVER% -d %DATABASE% -E -i "%%f"
)

for %%f in (%USER_PATH%\*.sql) do (
    echo Ejecutando %%f ...
    sqlcmd -S %SERVER% -d %DATABASE% -E -i "%%f"
)

echo === Ejecutando Data.sql ===
sqlcmd -S %SERVER% -d %DATABASE% -E -i "H:\Proyectos\TrackingApp\TracikingAppDataBase\Data.sql"

echo ========================================
echo Todos los scripts han sido ejecutados
echo ========================================

pause
endlocal
