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
helpGui.AddText("X" . width . " Y" . height . " W" . width . " Center", "m")
helpGui.AddText("X" . (2 * width) . " Y" . height . " W" . width . " Center", "F")
helpGui.AddText("X" . (4 * width) . " Y" . height . " W" . width . " Center", "n")
helpGui.AddText("X" . (6 * width) . " Y" . height . " W" . width . " Center", "n``")
helpGui.AddText("X" . (7 * width) . " Y" . height . " W" . width . " Center", "J")
helpGui.AddText("X" . (8 * width) . " Y" . height . " W" . width . " Center", "N")
helpGui.AddText("X" . (9 * width) . " Y" . height . " W" . width . " Center", "N\")

helpGui.AddText("X0 Y" . (2 * height) . " W" . width . " Right", "Plosive")
helpGui.AddText("X" . width . " Y" . (2 * height) . " W" . width . " Center", "p  b")
helpGui.AddText("X" . (2 * width) . " Y" . (2 * height) . " W" . width . " Center", "p_d  b_d")
helpGui.AddText("X" . (4 * width) . " Y" . (2 * height) . " W" . width . " Center", "t  d")
helpGui.AddText("X" . (6 * width) . " Y" . (2 * height) . " W" . width . " Center", "t``  d``")
helpGui.AddText("X" . (7 * width) . " Y" . (2 * height) . " W" . width . " Center", "c  J\")
helpGui.AddText("X" . (8 * width) . " Y" . (2 * height) . " W" . width . " Center", "k  g")
helpGui.AddText("X" . (9 * width) . " Y" . (2 * height) . " W" . width . " Center", "q  G\")
helpGui.AddText("X" . (11 * width) . " Y" . (2 * height) . " W" . width . " Center", ">\")
helpGui.AddText("X" . (12 * width) . " Y" . (2 * height) . " W" . width . " Center", "?")

helpGui.AddText("X0 Y" . (3 * height) . " W" . width . " Right", "Fricative")
helpGui.AddText("X" . width . " Y" . (3 * height) . " W" . width . " Center", "p\  B")
helpGui.AddText("X" . (2 * width) . " Y" . (3 * height) . " W" . width . " Center", "f  v")
helpGui.AddText("X" . (3 * width) . " Y" . (3 * height) . " W" . width . " Center", "T  D")
helpGui.AddText("X" . (4 * width) . " Y" . (3 * height) . " W" . width . " Center", "s  z")
helpGui.AddText("X" . (5 * width) . " Y" . (3 * height) . " W" . width . " Center", "S  Z")
helpGui.AddText("X" . (6 * width) . " Y" . (3 * height) . " W" . width . " Center", "s``  z``")
helpGui.AddText("X" . (7 * width) . " Y" . (3 * height) . " W" . width . " Center", "C  j\")
helpGui.AddText("X" . (8 * width) . " Y" . (3 * height) . " W" . width . " Center", "x  G")
helpGui.AddText("X" . (9 * width) . " Y" . (3 * height) . " W" . width . " Center", "X  R")
helpGui.AddText("X" . (10 * width) . " Y" . (3 * height) . " W" . width . " Center", "X\  ?\")
helpGui.AddText("X" . (11 * width) . " Y" . (3 * height) . " W" . width . " Center", "H\  <\")
helpGui.AddText("X" . (12 * width) . " Y" . (3 * height) . " W" . width . " Center", "h  h\")

helpGui.AddText("X0 Y" . (4 * height) . " W" . width . " Right", "Approximant")
helpGui.AddText("X" . width . " Y" . (4 * height) . " W" . width . " Center", "B_o")
helpGui.AddText("X" . (2 * width) . " Y" . (4 * height) . " W" . width . " Center", "v\")
helpGui.AddText("X" . (4 * width) . " Y" . (4 * height) . " W" . width . " Center", "r\")
helpGui.AddText("X" . (6 * width) . " Y" . (4 * height) . " W" . width . " Center", "r\``")
helpGui.AddText("X" . (7 * width) . " Y" . (4 * height) . " W" . width . " Center", "j")
helpGui.AddText("X" . (8 * width) . " Y" . (4 * height) . " W" . width . " Center", "M\")

helpGui.AddText("X0 Y" . (5 * height) . " W" . width . " Right", "Trill")
helpGui.AddText("X" . width . " Y" . (5 * height) . " W" . width . " Center", "B\")
helpGui.AddText("X" . (4 * width) . " Y" . (5 * height) . " W" . width . " Center", "r")
helpGui.AddText("X" . (9 * width) . " Y" . (5 * height) . " W" . width . " Center", "R\")

helpGui.AddText("X0 Y" . (6 * height) . " W" . width . " Right", "Tap / Flap")
helpGui.AddText("X" . (4 * width) . " Y" . (6 * height) . " W" . width . " Center", "4")
helpGui.AddText("X" . (6 * width) . " Y" . (6 * height) . " W" . width . " Center", "r``")

helpGui.AddText("X0 Y" . (7 * height) . " W" . width . " Right", "Lat. Fric.")
helpGui.AddText("X" . (4 * width) . " Y" . (7 * height) . " W" . width . " Center", "K  K\")

helpGui.AddText("X0 Y" . (8 * height) . " W" . width . " Right", "Lat. Approx.")
helpGui.AddText("X" . (4 * width) . " Y" . (8 * height) . " W" . width . " Center", "l")
helpGui.AddText("X" . (6 * width) . " Y" . (8 * height) . " W" . width . " Center", "l``")
helpGui.AddText("X" . (7 * width) . " Y" . (8 * height) . " W" . width . " Center", "L")
helpGui.AddText("X" . (8 * width) . " Y" . (8 * height) . " W" . width . " Center", "L\")

helpGui.AddText("X0 Y" . (9 * height) . " W" . width . " Right", "Lat. Flap")
helpGui.AddText("X" . (4 * width) . " Y" . (9 * height) . " W" . width . " Center", "l\")

helpGui.AddText("X" . width . " Y" . (11 * height) . " W" . width . " Center", "Front")
helpGui.AddText("X" . (2 * width) . " Y" . (11 * height) . " W" . width . " Center", "Central")
helpGui.AddText("X" . (3 * width) . " Y" . (11 * height) . " W" . width . " Center", "Back")

helpGui.AddText("X0 Y" . (12 * height) . " W" . width . " Right", "Close")
helpGui.AddText("X" . width . " Y" . (12 * height) . " W" . width . " Center", "i  y")
helpGui.AddText("X" . (2 * width) . " Y" . (12 * height) . " W" . width . " Center", "1  }")
helpGui.AddText("X" . (3 * width) . " Y" . (12 * height) . " W" . width . " Center", "M  u")

helpGui.AddText("X" . width . " Y" . (13 * height) . " W" . width . " Center", "I  Y")
helpGui.AddText("X" . (2 * width) . " Y" . (13 * height) . " W" . width . " Center", "I\  U\")
helpGui.AddText("X" . (3 * width) . " Y" . (13 * height) . " W" . width . " Center", "U")

helpGui.AddText("X0 Y" . (14 * height) . " W" . width . " Right", "Close-Mid")
helpGui.AddText("X" . width . " Y" . (14 * height) . " W" . width . " Center", "e  2")
helpGui.AddText("X" . (2 * width) . " Y" . (14 * height) . " W" . width . " Center", "@\  8")
helpGui.AddText("X" . (3 * width) . " Y" . (14 * height) . " W" . width . " Center", "7  o")

helpGui.AddText("X" . width . " Y" . (15 * height) . " W" . width . " Center", "e_o  2_o")
helpGui.AddText("X" . (2 * width) . " Y" . (15 * height) . " W" . width . " Center", "@")
helpGui.AddText("X" . (3 * width) . " Y" . (15 * height) . " W" . width . " Center", "7_o  o_o")

helpGui.AddText("X0 Y" . (16 * height) . " W" . width . " Right", "Open-Mid")
helpGui.AddText("X" . width . " Y" . (16 * height) . " W" . width . " Center", "E  9")
helpGui.AddText("X" . (2 * width) . " Y" . (16 * height) . " W" . width . " Center", "3  3\")
helpGui.AddText("X" . (3 * width) . " Y" . (16 * height) . " W" . width . " Center", "V  O")

helpGui.AddText("X" . width . " Y" . (17 * height) . " W" . width . " Center", "{")
helpGui.AddText("X" . (2 * width) . " Y" . (17 * height) . " W" . width . " Center", "6")

helpGui.AddText("X0 Y" . (18 * height) . " W" . width . " Right", "Open")
helpGui.AddText("X" . width . " Y" . (18 * height) . " W" . width . " Center", "a  &")
helpGui.AddText("X" . (2 * width) . " Y" . (18 * height) . " W" . width . " Center", "a_`"")
helpGui.AddText("X" . (3 * width) . " Y" . (18 * height) . " W" . width . " Center", "A  Q")

helpGui.AddText("X" . (7 * width) . " Y" . (11 * height) . " W" . (3 * width) . " Right", "Voiceless labialized velar approximant")
helpGui.AddText("X" . (10 * width) . " Y" . (11 * height) . " W" . width . " Center", "W")

helpGui.AddText("X" . (7 * width) . " Y" . (12 * height) . " W" . (3 * width) . " Right", "Voiced labialized velar approximant")
helpGui.AddText("X" . (10 * width) . " Y" . (12 * height) . " W" . width . " Center", "w")

helpGui.AddText("X" . (7 * width) . " Y" . (13 * height) . " W" . (3 * width) . " Right", "Voiced labialized palatal approximant")
helpGui.AddText("X" . (10 * width) . " Y" . (13 * height) . " W" . width . " Center", "H")

helpGui.AddText("X" . (7 * width) . " Y" . (14 * height) . " W" . (3 * width) . " Right", "Voiceless alveo-palatal fricative")
helpGui.AddText("X" . (10 * width) . " Y" . (14 * height) . " W" . width . " Center", "s\")

helpGui.AddText("X" . (7 * width) . " Y" . (15 * height) . " W" . (3 * width) . " Right", "Voiced alveo-palatal fricative")
helpGui.AddText("X" . (10 * width) . " Y" . (15 * height) . " W" . width . " Center", "z\")

helpGui.AddText("X" . (7 * width) . " Y" . (16 * height) . " W" . (3 * width) . " Right", "Voiced palatal-velar fricative")
helpGui.AddText("X" . (10 * width) . " Y" . (16 * height) . " W" . width . " Center", "x\")

helpGui.AddText("X" . (7 * width) . " Y" . (17 * height) . " W" . (3 * width) . " Right", "Implosive")
helpGui.AddText("X" . (10 * width) . " Y" . (17 * height) . " W" . width . " Center", "_<")

helpGui.AddText("X" . (7 * width) . " Y" . (18 * height) . " W" . (3 * width) . " Right", "Ejective")
helpGui.AddText("X" . (10 * width) . " Y" . (18 * height) . " W" . width . " Center", "_>")

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
