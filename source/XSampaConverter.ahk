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

characterMapping := Map()
characterMappingKeys := ""
characterMappingSortedKeys := []

; Reading character mapping file.
fileContents := FileRead("CharacterMapping.tsv")
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

; Free memory.
characterMappingKeys := ""

RCtrl::
{
	ih := InputHook("V", "{Tab}{Enter}")
	ih.Start()
	ih.Wait()
	inputString := ih.Input
	
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

reverseSortByLength(s1, s2, *)
{
	Return StrLen(s2) - StrLen(s1)
}
