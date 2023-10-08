@echo off
setlocal enabledelayedexpansion

REM URL du référentiel GitHub que vous souhaitez cloner
set github_repo_url=https://github.com/AUTOMATIC1111/stable-diffusion-webui.git

REM Nom du dossier dans lequel vous souhaitez cloner le référentiel
set github_repo_name=sd-webui


REM URL du fichier Python que vous souhaitez télécharger
set python_download_url=https://www.python.org/ftp/python/3.10.6/python-3.10.6-amd64.exe

REM Chemin de destination pour le téléchargement de Python
set python_repo_name=python_3_10_6


set git_repo_name=PortableGit


REM Installer la version Python 3.10.6 de Python
if not exist "%python_repo_name%" (
	mkdir %python_repo_name%
	
	REM Téléchargez Python (version spécifique)
	echo Téléchargement de Python 3.10.6
	curl -o "%python_repo_name%\python_3.10.6.exe" "%python_download_url%"
	
	cls
	
	echo Téléchargement de Python 3.10.6
	start /wait /b %python_repo_name%/python_3.10.6.exe PrependPath=1 CompileAll=1 TargetDir="%cd%\%python_repo_name%" /quiet
	
	REM Supprimez le fichier d'installation de Python si vous le souhaitez
	del %python_repo_name%/python_3.10.6.exe
	
	REM Ensure pip
	start /wait /b %python_repo_name%/python.exe -m ensurepip
	start /wait /b %python_repo_name%/python.exe -m pip install requests
	start /wait /b %python_repo_name%/python.exe -m pip install PILLOW
	
	cls
)


REM Installe une version Portable de Git si l'utilisateur n'a pas Git d'installé
git --version >nul 2>&1
if not %errorlevel% equ 0 (
	REM Créer le répertoire pour Git
	
	if not exist "%git_repo_name%" (
		
		if not exist "./utils/7z.exe" (
			REM Télécharger 7z
			echo Installation de 7z
			powershell -File "./utils/install-7z.ps1"
			
			cls
		)
	
		mkdir %git_repo_name%
		
		REM Télécharge et Décompresse Git
		echo Installation de Git
		powershell -File "./utils/install-git.ps1"
		
		cls
		
		call %git_repo_name%/post-install.bat
		cd ../
		
		cls
	)
	
	REM Cloner le repo ou le Mettre à jour
	if not exist "%github_repo_name%" (
		REM Clonez le référentiel GitHub
		echo Telechargement de Stable Diffusion

		start /wait /b ./%git_repo_name%/bin/git.exe clone %github_repo_url% %github_repo_name%
		
		(
		echo @echo off
		echo set PYTHON=%cd%\python_3_10_6\python
		echo set GIT=%cd%\PortableGit\bin\git.exe
		echo set GIT_PYTHON_GIT_EXECUTABLE=%GIT%
		echo set VENV_DIR=
		echo set COMMANDLINE_ARGS=--no-download-sd-model --medvram --xformers --no-half-vae --nowebui --api --api-log --port 7878

		echo cd sd-webui

		echo call webui.bat
		) > process.bat
		
	) else (
		REM Mettre à jour Stable Diffusion
		cd %github_repo_name%
		start /wait /b ../%git_repo_name%/bin/git.exe pull
		cd ../
	)
) else (

	if not exist "%github_repo_name%" (
		REM Clonez le référentiel GitHub
		echo Téléchargement de Stable Diffusion
		git clone %github_repo_url% %github_repo_name%
		
		echo Téléchargement du modèle
		powershell -File "./utils/install-model.ps1"
		cls
		
		echo Téléchargement du Lora
		move ".\utils\Lora" ".\%github_repo_name%\models"
		cls
		
		(
		echo @echo off
		echo set PYTHON=%cd%\python_3_10_6\python
		echo set GIT=
		echo set VENV_DIR=
		echo set COMMANDLINE_ARGS=--no-download-sd-model --medvram --xformers --no-half-vae --nowebui --api --api-log --port 7878

		echo cd sd-webui

		echo call webui.bat
		) > process.bat
	) else (
		REM Mettre à jour Stable Diffusion
		cd %github_repo_name%
		git pull
		cd ../
	)
)
cls

set PYTHONUNBUFFERED=1

%cd%/%python_repo_name%/python.exe app.py

REM Désactivez l'extension delayedexpansion
endlocal

exit