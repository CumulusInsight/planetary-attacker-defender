@echo off
setlocal
title Orbital Defense Command - Prototype 14

rem Resolve the project from this launcher, never from the current folder.
set "PROJECT_DIR=%~dp0."
set "GODOT_EXE=C:\Users\azwam\Projects\Godot_4.7\Godot_v4.7.2-stable_mono_win64\Godot_v4.7.2-stable_mono_win64.exe"
set "SCENE_FILE=%~dp0scene\prototype14_commanders_experience.tscn"

if not exist "%GODOT_EXE%" (
    echo ERROR: Godot 4.7.2 Mono could not be found.
    echo Expected: "%GODOT_EXE%"
    echo.
    pause
    exit /b 1
)

if not exist "%PROJECT_DIR%\project.godot" (
    echo ERROR: The Godot project configuration could not be found beside this launcher.
    echo Expected: "%PROJECT_DIR%\project.godot"
    echo.
    pause
    exit /b 1
)

if not exist "%SCENE_FILE%" (
    echo ERROR: The Prototype 14 scene could not be found.
    echo Expected: "%SCENE_FILE%"
    echo.
    pause
    exit /b 1
)

start "" /D "%PROJECT_DIR%" "%GODOT_EXE%" --path "%PROJECT_DIR%" "res://scene/prototype14_commanders_experience.tscn"
if errorlevel 1 (
    echo ERROR: Windows could not start Godot. Please check the installation above.
    echo.
    pause
    exit /b 1
)
exit /b 0
