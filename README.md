# XSampa Converter
Autohotkey script for typing IPA characters using their XSampa counterpart.


## Usage
- Run the file `XSampaConverter.ahk`.  The following tray icon will appear, indicating that the script is running, but currently not performing any action: ![InactiveIcon](https://github.com/looptailG/xsampa-converter/assets/99362337/c2124d65-618e-4b18-8e2c-ba5df9b4b353)
- When you need to convert a XSampa string, activate the script by pressing `F8`.  The tray icon will change to the following one, indicating that the script is waiting for a string to convert: 
![ActiveIcon](https://github.com/looptailG/xsampa-converter/assets/99362337/91f1dfe2-7b8d-40cf-966c-b93ef9f81a49)
- Type the XSampa string you need to convert, and then press either `Tab` or `Enter`.
- The script will convert the XSampa string you typed to the corresponding IPA characters.  At this point the tray icon will change again to the following one: ![InactiveIcon](https://github.com/looptailG/xsampa-converter/assets/99362337/c2124d65-618e-4b18-8e2c-ba5df9b4b353)

If you want to cancel the conversion after you pressed `F8`, you can do so by pressing `Esc`.

If you need a reminder about the XSampa characters, you can press `F1` to have the script show a pop-up window with the most commonly used ones.


## Installing
You need to have `AutoHotkey v2` installed in order to run this script.

- Download the file `XSampaConverter_x.y.z.zip`, where `x.y.z` is the version of the plugin.  You can find the latest version [here](https://github.com/looptailG/xsampa-converter/releases/latest).
- Extract the folder `XSampaConverter`.  This folder contains the script `XSampaConverter.ahk`.

The script needs the contents of the other files in this folder in order to run correctly, so you have to run the file `XSampaConverter.ahk` from inside this folder.
