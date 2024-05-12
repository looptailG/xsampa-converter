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

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

characterMappingFilePath := "CharacterMapping.tsv"
characterMapping := {}
characterMappingSortedKeys := []
keyList := ""
; Reading character mapping file.
Loop
{
	FileReadLine, currentLine, %characterMappingFilePath%, %A_Index%
	If ErrorLevel
	{
		; End of file.
		Break
	}
	
	currentLine := StrSplit(currentLine, "`t")
	key := currentLine[1]
	value := currentLine[2]
	characterMapping[key] := value
	keyList .= key . "`n"
}
keyList := Trim(keyList, "`n")
; Sort the keys in decreasing length order.  They have to be replaced in reverse
; length order so that the shorter keys don't replace parts of the string which
; are part of a longer key.
Sort, keyList, F reverseSortByLength
characterMappingSortedKeys := StrSplit(keyList, "`n")

reverseSortByLength(s1, s2)
{
	Return StrLen(s2) - StrLen(s1)
}
