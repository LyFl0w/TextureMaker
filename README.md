# Texture Maker

Texture Maker is a Python program that utilizes the Stable Diffusion API (webui) and a LoRa available on [this repository](https://github.com/Jack-Bagel/Minecraft-Lora-Training) to generate 64x64 textures for Minecraft.

## How It Works

The application operates as follows:

1. The `launcher` script launches a Python program that allows the user to create an image with text.
2. The text and image are sent to the Stable Diffusion API, which returns a texture in 256x256 with a green background.
3. The Python program retrieves this texture, removes the green background, and saves it in the `output` folder.

**Important Note:** There may be issues when removing colors if the image you want to generate contains green. For instance, if you enter "green flower," it could pose problems. In such cases, it is recommended to generate a flower you like with a color like red or blue and then colorize it green using a filter in an image editing application.

## Installation

1. Download the `launcher` script corresponding to your operating system from the "Releases" section on GitHub.
2. Run the script (`launcher.bat` on Windows or `launcher.bash` on Linux).
3. Follow the steps provided in the launcher.
4. If you don't have a dedicated graphics card, in the process file (`process.bat` on Windows or `process.bash` on Linux) inside the section `set COMMANDLINE_ARGS=` add `--precision full --no-half --skip-torch-cuda-test`, this is a file generated when executing the launcher script. But i don't recommande to use this program without dedicated graphics card because that can cause a lot of issues.
5. If it still doesn't work try deleting the `--xformers` argument in the same file.

**Note:** During the first launch, there may be substantial downloads, so please be prepared for this process to take some time.

## Limitations

- Texture generation is currently limited to 2D items. This means it does not include textures for blocks or mobs.

**Future Enhancements:** In the future, we plan to add a LoRa model for blocks. If you are interested in contributing to the project, feel free to add a LoRa for blocks or improve the existing [LoRA](https://github.com/Jack-Bagel/Minecraft-Lora-Training) for item texture.

If you encounter any issues during installation or usage of the application, feel free to open an issue on [GitHub](https://github.com/your-username/your-project/issues).


## License

This project is distributed under the GNU GENERAL PUBLIC LICENSE Version 3. You can review the complete license in the [LICENSE](LICENSE) file.
