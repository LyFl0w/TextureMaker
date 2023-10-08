$ProgressPreference = 'SilentlyContinue'

$modelSDUrl = "https://huggingface.co/stabilityai/stable-diffusion-2-1-base/resolve/main/v2-1_512-ema-pruned.safetensors"

$downloadPath = "./sd-webui/models/Stable-diffusion/v2-1_512-ema-pruned.safetensors"

Invoke-WebRequest -Uri $modelSDUrl -OutFile $downloadPath

Write-Host "SD 2.5 model successfully downloaded!"