@echo off
setlocal enabledelayedexpansion

set github_repo_url=https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
set github_repo_name=sd-webui

set python_download_url=https://www.python.org/ftp/python/3.10.6/python-3.10.6-amd64.exe
set python_repo_name=python_3_10_6

set git_repo_name=PortableGit


powershell -Command "Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force"

if not exist "%python_repo_name%" (
	mkdir %python_repo_name%
	
	echo Download Python 3.10.6
	curl -o "%python_repo_name%\python_3.10.6.exe" "%python_download_url%"
	
	cls
	
	echo Download Python 3.10.6
	start /wait /b %python_repo_name%/python_3.10.6.exe PrependPath=1 CompileAll=1 TargetDir="%cd%\%python_repo_name%" /quiet
	
	start /wait /b %python_repo_name%/python.exe -m ensurepip
	cls
	start /wait /b %python_repo_name%/python.exe -m pip install requests
	cls
	start /wait /b %python_repo_name%/python.exe -m pip install PILLOW
	cls
)


git --version >nul 2>&1
if not %errorlevel% equ 0 (
	
	if not exist "%git_repo_name%" (
		
		if not exist "./utils/7z.exe" (
			echo 7z installation
			powershell -File "./utils/install-7z.ps1"
			
			cls
		)
	
		mkdir %git_repo_name%
		
		echo Git installation
		powershell -File "./utils/install-git.ps1"
		
		cls
		
		call %git_repo_name%/post-install.bat
		cd ../
		
		cls
	)
	
	if not exist "%github_repo_name%" (
		echo Download Stable Diffusion
		start /wait /b ./%git_repo_name%/bin/git.exe clone %github_repo_url% %github_repo_name%
		
		echo Download model
		powershell -File "./utils/install-model.ps1"
		cls
		
		echo Download Lora
		move ".\utils\Lora" ".\%github_repo_name%\models"*
		cls
		
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
		cd %github_repo_name%
		start /wait /b ../%git_repo_name%/bin/git.exe pull
		cd ../
	)
) else (

	if not exist "%github_repo_name%" (
		echo Download Stable Diffusion
		git clone %github_repo_url% %github_repo_name%
		
		echo Download model
		powershell -File "./utils/install-model.ps1"
		cls
		
		echo Download Lora
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
		cd %github_repo_name%
		git pull
		cd ../
	)
)
cls

set PYTHONUNBUFFERED=1

%cd%/%python_repo_name%/python.exe app.py

endlocal

exit