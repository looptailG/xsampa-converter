; Autohotkey script for typing IPA characters using their XSampa counterpart.
; Copyright (C) 2024 Alessandro Culatti
;
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <https://www.gnu.org/licenses/>.

#Requires AutoHotkey v2.0

config := Map()

characterMapping := Map()
characterMappingKeys := ""
characterMappingSortedKeys := []

; Read config file.
fileContents := FileRead("Config.tsv")
fileContents := StrSplit(fileContents, "`n")
For _, currentLine in fileContents
{
	currentLine := StrSplit(currentLine, "`t")
	If (currentLine.length = 2)
	{
		key := Trim(currentLine[1], " `t`n`r")
		value := Trim(currentLine[2], " `t`n`r")
		config[key] := value
	}
}

; Read character mapping file.
fileContents := FileRead(config["characterMappingFilePath"])
fileContents := StrSplit(fileContents, "`n")
For _, currentLine in fileContents
{
	currentLine := StrSplit(currentLine, "`t")
	If (currentLine.length = 2)
	{
		key := Trim(currentLine[1], " `t`n`r")
		value := Trim(currentLine[2], " `t`n`r")
		characterMapping[key] := value
		characterMappingKeys .= key . "`n"
	}
}
Trim(characterMappingKeys, "`n")

; Sort the keys in decreasing length order.  They have to be replaced in
; decreasing length order so that the shorter keys don't replace some of the
; characters which are part of a longer key.
characterMappingKeys := Sort(characterMappingKeys, , reverseSortByLength)
characterMappingSortedKeys := StrSplit(characterMappingKeys, "`n")

; Build help GUI.
width := config["columnWidth"]
height := config["rowHeight"]
helpGui := Gui(, "XSampa Converter", )
helpGui.AddText("X" . width . " Y0 W" . width . " Center", "Bilabial")
helpGui.AddText("X" . (2 * width) . " Y0 W" . width . " Center", "Labiodental")
helpGui.AddText("X" . (3 * width) . " Y0 W" . width . " Center", "Dental")
helpGui.AddText("X" . (4 * width) . " Y0 W" . width . " Center", "Alveolar")
helpGui.AddText("X" . (5 * width) . " Y0 W" . width . " Center", "Post-alveolar")
helpGui.AddText("X" . (6 * width) . " Y0 W" . width . " Center", "Retroflex")
helpGui.AddText("X" . (7 * width) . " Y0 W" . width . " Center", "Palatal")
helpGui.AddText("X" . (8 * width) . " Y0 W" . width . " Center", "Velar")
helpGui.AddText("X" . (9 * width) . " Y0 W" . width . " Center", "Uvular")
helpGui.AddText("X" . (10 * width) . " Y0 W" . width . " Center", "Pharyngeal")
helpGui.AddText("X" . (11 * width) . " Y0 W" . width . " Center", "Epiglottal")
helpGui.AddText("X" . (12 * width) . " Y0 W" . width . " Center", "Glottal")

helpGui.AddText("X0 Y" . height . " W" . width . " Right", "Nasal")
helpGui.AddText("X0 Y" . (2 * height) . " W" . width . " Right", "Plosive")
helpGui.AddText("X0 Y" . (3 * height) . " W" . width . " Right", "Fricative")
helpGui.AddText("X0 Y" . (4 * height) . " W" . width . " Right", "Approximant")
helpGui.AddText("X0 Y" . (5 * height) . " W" . width . " Right", "Trill")
helpGui.AddText("X0 Y" . (6 * height) . " W" . width . " Right", "Tap")
helpGui.AddText("X0 Y" . (7 * height) . " W" . width . " Right", "Lat. Fric.")
helpGui.AddText("X0 Y" . (8 * height) . " W" . width . " Right", "Lat. Approx.")
helpGui.AddText("X0 Y" . (9 * height) . " W" . width . " Right", "Lat. Flap")

; Free memory.
fileContents := ""
characterMappingKeys := ""

Hotkey config["replaceStringHotkey"], replaceXSampaString
Hotkey config["displayHelpHotkey"], displayHelp

replaceXSampaString(thisHotkey)
{
	ih := InputHook("V", config["endInputKeys"])
	ih.Start()
	ih.Wait()
	inputString := ih.Input
	
	If (ih.EndKey != config["cancelKey"])
	{
		; Delete the string written by the user.
		nCharacters := StrLen(inputString) + 1
		Loop(nCharacters)
		{
			SendInput("{Backspace}")
		}
		
		; Replace XSampa strings with IPA characters.
		For _, xsampaString in characterMappingSortedKeys
		{
			If (xsampaString)
			{
				ipaCharacter := CharacterMapping[xsampaString]
				inputString := StrReplace(inputString, xsampaString, ipaCharacter, "On")
			}
		}
		SendInput(inputString)
	}
}

displayHelp(thisHotkey)
{
	helpGui.Show()
}

reverseSortByLength(s1, s2, *)
{
	Return StrLen(s2) - StrLen(s1)
}
