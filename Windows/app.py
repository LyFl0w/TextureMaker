import sys
import os
import requests
import base64
import io
import subprocess
import threading
from PIL import Image
from datetime import date


def remove_green_background(image, tolerance=100):
    image = image.convert("RGBA")

    width, height = image.size

    for x in range(width):
        for y in range(height):
            r, g, b, a = image.getpixel((x, y))

            if g > r and g > b and (g - r) >= tolerance and (g - b) >= tolerance:
                image.putpixel((x, y), (0, 0, 0, 0))

    return image


def generate_image(payload_data: [str], filename="", lora_type="item"):
    if filename is None or filename == "":
        filename = "_".join(payload_data)

    prompt = f"{', '.join(payload_data)}, "
    if lora_type == "item":
        prompt += "<lora:Minecraft-Textures-LoRA-V1.0:1>"

    payload = {
        "prompt": prompt,
        "sd_model_checkpoint": "v2-1_512-ema-pruned.safetensors [df955bdf6b]",
        "steps": 20,
        "cfg_scale": 7,
        "width": 256,
        "height": 256,
        "CLIP_stop_at_last_layers": 2
    }

    # print(payload)

    response = requests.post(url='http://127.0.0.1:7878/sdapi/v1/txt2img', json=payload).json()

    image = remove_green_background(Image.open(io.BytesIO(base64.b64decode(response['images'][0]))))
    image = image.resize((64, 64), Image.Resampling.NEAREST)

    path = os.path.join('output', str(date.today()))
    if not os.path.exists(path):
        os.makedirs(path)

    image.save(f"{os.path.join(path, filename)}.png")


def stderr():
    while True:
        err_line = process.stderr.readline()

        if not err_line:
            print("exit")
            sys.exit(-1)

        print(err_line.decode(encoding='ascii'), end='')


if __name__ == '__main__':
    process = subprocess.Popen(["process.bat"], shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                               stdin=subprocess.PIPE)

    stderr_thread = threading.Thread(target=stderr)
    stderr_thread.daemon = True
    stderr_thread.start()

    while stderr_thread.is_alive():
        line = process.stdout.readline()

        if not line:
            print("exit")
            sys.exit(-1)

        line = line.decode()
        print(line, end='')

        if "Model loaded in" in line or "POST /sdapi/v1/txt2img HTTP/1.1" in line:
            try:
                generate_image(input("\nPrompt: ").split(", "))
            except KeyboardInterrupt:
                sys.exit(-1)

    