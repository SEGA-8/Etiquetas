/*
 * =============================================================================================== *
 * Author           : SEGA   <simonabad@gmail.com>
 * Script Name      : Generador de etiquetas
 * Script Version   : 
 * Homepage         : http://www.autohotkey.com/
 *
 * Creation Date    : December 24, 2020
 * Modification Date: July 04, 2021
 *
 * Description      :
 * ------------------
 * This small program is a set of "tools" that i use regularly.
 *
 * -----------------------------------------------------------------------------------------------
 * License          :       Copyright ©2010-2021 SEGA <GPLv3>
 *
 *          This program is free software: you can redistribute it and/or modify
 *          it under the terms of the GNU General Public License as published by
 *          the Free Software Foundation, either version 3 of  the  License,  or
 *          (at your option) any later version.
 *
 *          This program is distributed in the hope that it will be useful,
 *          but WITHOUT ANY WARRANTY; without even the implied warranty  of
 *          MERCHANTABILITY or FITNESS FOR A PARTICULAR  PURPOSE.  See  the
 *          GNU General Public License for more details.
 *
 *          You should have received a copy of the GNU General Public License
 *          along with this program.  If not, see <http://www.gnu.org/licenses/gpl-3.0.txt>
 * -----------------------------------------------------------------------------------------------
 *
 */
 ;[Compiler]{
 	;@Ahk2Exe-SetMainIcon %A_ScriptDir%\res\Barcode.ico
 ;}
;[Directives]{
#NoEnv
#NoTrayIcon
#SingleInstance Force
; --
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetBatchLines, 20ms
CoordMode, Mouse, Window
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
OnExit, Exit
;}

;[Basic Script Info]{
global script := { base	:scriptobj
				  ,name			: "Generador de Etiquetas"
				  ,version		: "0.1.3.2"
				  ,author		: "SEGA"
				  ,email		: "simonabad@gmail.com"
				  ,Homepage		: "http://www.autohotkey.com/"
				  ,crtdate		: "December 24, 2020"
				  ,moddate		: "March 15, 2021"
				  ,conf			: "Settings.ini"}

;}

;[Variables]{
PtrLabelFile := A_ScriptDir "\PtrLabels.txt"
PtrLogFile := A_ScriptDir "\PtrLog.txt"
;offset control RadioButton
offset:= 5
;}

;[Main]{
;Gosub, Menu

;if FileExist(script.conf)
	Gosub, Iniread
;Else
;	Gosub, Settings

MainGui()

Return                      
;[End of Auto-Execute area]
;}

MainGui(){
global
	Gui Main: New, +hWndhMainWnd
	Gui Main:Add, Tab3, x7 y8 w227 h158 +AltSubmit v_Tab, Serializer|Repair|Simples|Studer
	Gui Main:Tab, 1
	Gui Main:Add, GroupBox, x14 y32 w211 h124,
	Gui Main:Add, Text, x32 y48 w88 h20 +0x200, Siguente Etiqueta:
	Gui Main:Add, Text, x32 y88 w88 h20 +0x200, Marca de LED's:
	Gui Main:Add, Text, x32 y128 w88 h20 +0x200, Num de Etiquetas:
	Gui Main:Add, Edit, x125 y128 w28 h20 +Number Limit v_numEtq
	Gui Main:Add, Edit, x125 y48 w55 h20 +Number Limit hWndhEdtnumEtqSer v_numEtqAnt
	Gui Main:Add, Edit, x125 y88 w36 h20 +0x8 Limit v_pMarca, -N
	Gui Main:Add, Edit, x167 y88 w25 h20 +Number Limit v_marca
	Gui Main:Tab, 2
	Gui Main:Add, GroupBox, x14 y32 w211 h124,
	Gui Main:Add, Text, x32 y48 w88 h20 +0x200, Cabecera:
	Gui Main:Add, Text, x32 y88 w88 h20 +0x200, Numero inicial:
	Gui Main:Add, Text, x32 y128 w88 h20 +0x200, Num Etiquetas:
	Gui Main:Add, Edit, x111 y128 w25 h20 +Number v_numEtqRep
	Gui Main:Add, Edit, x111 y48 w22 h20 +0x8 v_cabRep, RB
	Gui Main:Add, Edit, x111 y88 w43 h20 +Number hWndhEdtnumEtqRep v_numIniRep
	Gui Main:Tab, 3
	Gui Main:Add, GroupBox, x14 y32 w211 h124,
	Gui Main:Add, Text, x32 y48 w88 h20 +0x200, Cabecera:
	Gui Main:Add, Text, x32 y88 w88 h20 +0x200, Número inicial:
	Gui Main:Add, Text, x32 y128 w88 h20 +0x200, Num Etiquetas:
	Gui Main:Add, Edit, x111 y48 w97 h20 +0x8 v_cabSimple
	Gui Main:Add, Edit, x111 y88 w43 h20 +Number  hWndhEdtNumIni v_numIni
	Gui Main:Add, Edit, x111 y128 w25 h20 +Number v_numEtqSpl
	Gui Main:Tab, 4
	Gui Main:Add, GroupBox, x14 y32 w211 h124,
	Gui Main:Add, Text, x32 y48 w88 h20 +0x200, Cabecera:
	Gui Main:Add, Text, x32 y88 w88 h20 +0x200, Numero inicial:
	Gui Main:Add, Text, x32 y128 w88 h20 +0x200, Num Etiquetas:
	Gui Main:Add, Edit, x111 y128 w25 h20 +Number v_numEtqRepSt
	Gui Main:Add, Edit, x111 y48 w22 h20 +0x8 v_cabRepSt, RS
	Gui Main:Add, Edit, x111 y88 w43 h20 +Number hWndhEdtnumEtqRepSt v_numIniRepSt
	Gui Main:Add, Checkbox, x148 y132 v_datamatrix, Datamatrix
	;Gui Main:Add, Checkbox, x148 y88 w72 h20 gActualizaEdit v_noPrint, No Imprimir
	Gui Main:Tab
	Gui Main:Add, Button, x7 y170 w225 h24 gImprimir, &Imprimir
	Gui Main:Add, Button, gSetup x212 y6 w20 h20, ...
	Gui Main:Add, StatusBar,, Fixalia Electronic Solutions.
	SB_SetParts(180)

	Gui Show, w240 h220, Generador de etiquetas
	Gosub, ActualizaFecha
	Gosub, LoadItemsMain
Return
}

Settings:
;global
	If (WinExist("ahk_id " . hSettWnd)) {
        Gui SettingsDlg: Show
    }Else{
		Gui SettingsDlg: New, +hWndhSettWnd +DelimiterSpace +AlwaysOnTop
		;SetWindowIcon(hFontDlg, IconLib, 20)

		Gui SettingsDlg:Add, GroupBox, x7 y1 w106 h90, Label
		Gui SettingsDlg:Add, Text, x15 y18 w35 h20 +0x200, Width:
		Gui SettingsDlg:Add, Text, x15 y40 w35 h20 +0x200, Height:
		Gui SettingsDlg:Add, Text, x15 y62 w35 h20 +0x200, Gap:
		Gui SettingsDlg:Add, Edit, x51 y18 w55 h20 hWndhEdtwidth v_width, 67.75 mm
		Gui SettingsDlg:Add, Edit, x51 y40 w55 h20 hWndhEdtheight v_height, 5 mm
		Gui SettingsDlg:Add, Edit, x51 y62 w55 h20 hWndhEdtgap v_gap, 3 mm, 0 mm
		Gui SettingsDlg:Add, GroupBox, x118 y1 w115 h70, Coordinates
		Gui SettingsDlg:Add, Text, x124 y18 w16 h20 +0x200, X1:
		Gui SettingsDlg:Add, Text, x124 y40 w16 h20 +0x200, Y1:
		Gui SettingsDlg:Add, Edit, x141 y18 w32 h20 hWndhEdtxpos_0 v_xPos_0, 170
		Gui SettingsDlg:Add, Edit, x141 y40 w32 h20 hWndhEdtypos_0 v_yPos_0, 20
		Gui SettingsDlg:Add, Text, x178 y18 w16 h20 +0x200, X2:
		Gui SettingsDlg:Add, Text, x178 y40 w16 h20 +0x200, Y2:
		Gui SettingsDlg:Add, Edit, x195 y18 w32 h20 hWndhEdtxpos_1 v_xPos_1, 435
		Gui SettingsDlg:Add, Edit, x195 y40 w32 h20 hWndhEdtypos_1 v_yPos_1, 20
		Gui SettingsDlg:Add, GroupBox, x7 y92 w106 h68, Printer
		Gui SettingsDlg:Add, Text, x15 y108 w40 h20 +0x200, Speed:
		Gui SettingsDlg:Add, Edit, x60 y108 w20 h20 +0x1 hWndhEdtspeed v_speed, 2
		Gui SettingsDlg:Add, Text, x15 y130 w40 h20 +0x200, Density:
		Gui SettingsDlg:Add, Edit, x60 y130 w20 h20 +0x1 hWndhEdtdensity v_density, 6
		Gui SettingsDlg:Add, GroupBox, x118 y72 w115 h88, Print direction
		Gui SettingsDlg:Add, Radio, hWndhRdirection v_direction x129 y91 w64 h16, Normal
		Gui SettingsDlg:Add, Radio, w64 h16, Inverse
		Gui SettingsDlg:Add, Radio, w64 h16 +Disabled, Mirror
		Gui SettingsDlg:Add, GroupBox, x7 y160 w226 h42, Misc	
		Gui SettingsDlg:Add, Text, x15 y173 w47 h20 +0x200, Delay ms:
		Gui SettingsDlg:Add, Edit, x63 y174 w30 h20 hWndhEdtdelay v_delay, 100
		Gui SettingsDlg:Add, Text, x103 y173 w40 h20 +0x200, Date:
		Gui SettingsDlg:Add, Edit, x131 y174 w50 h20 hWndhEdtdate v_date, 2100008
		Gui SettingsDlg:Add, Checkbox, x185 y174 w42 h20 hWndhCbxAutoFecha gActualizaEditAutoFecha v_autoFecha, Auto
		Gui SettingsDlg:Add, Button, gSaveSettings x68 y206 w80 h23, &Save
		Gui SettingsDlg:Add, Button, gCancel x152 y206 w80 h23, &Cancel
		Gui SettingsDlg:Show, w240 h235, Settings

		Gosub, LoadItemsSettings
		;pause
	}
	Return
;}

LoadItemsMain:
	;ControlSetText,, %width%, ahk_id %hEdtwidth%
	;MainWindow
	StStr:= "`t" . numEtqAnt
	SB_SetText(StStr,2)
	GuiControl, Text, %hEdtnumEtqSer%, %numEtqAnt%
	GuiControl, Text, %hEdtnumEtqRep%, %numEtqRep%
	GuiControl, Text, %hEdtnumEtqRepSt%, %numEtqRepSt%

Return

LoadItemsSettings:
	;SettingsDlgWindow
	GuiControl, Text, %hEdtwidth%, %width%
	GuiControl, Text, %hEdtheight%, %height%
	GuiControl, Text, %hEdtgap%, %gap%
	GuiControl, Text, %hEdtspeed%, %speed%
	GuiControl, Text, %hEdtdensity%, %density%
	GuiControl, Text, %hEdtdelay%, %delay%
	GuiControl, Text, %hEdtdate%, %date%
	if (autoFecha)
		GuiControl, +Disabled, %hEdtdate%
	GuiControl, , %hCbxAutoFecha%, %autoFecha%
	GuiControl, Text, %hEdtxPos_0%, %xPos_0%
	GuiControl, Text, %hEdtyPos_0%, %yPos_0%
	GuiControl, Text, %hEdtxPos_1%, %xPos_1%
	GuiControl, Text, %hEdtyPos_1%, %yPos_1%
	RadioBtn := "Button" . ( offset + direction )
	GuiControl,,%RadioBtn%,1
Return

Menu:
	Menu, Tray,DeleteAll
	;Menu, Tray, Icon, res/Barcode.ico
	Menu, Tray, Tip, % script.name
	Menu, Tray,NoStandard
	Menu, Tray, Click, 1
	Menu, Tray,Add,% "Settings..", Settings
	Menu, Tray, Default, Settings..
	Menu, Tray, add
	Menu, Tray,Add,E&xit,Exit
Return

ActualizaFecha:
	strF:= SubStr(A_now, 3, 2)
	strFecha:= strF . "000"
	strFechaNumEtq:= strF . "000000"
	strF:= SubStr(A_now, 5, 2)
	strFecha:= strFecha . strF
	If (AutoFecha){
		date:= strFecha
	}
Return

ActualizaEditAutoFecha:
	Gui, %a_gui%: Submit, NoHide
	If (_autoFecha){
		Gosub, ActualizaFecha
		GuiControl, Disable, %hEdtdate%
		GuiControl, Text, %hEdtdate%, %strFecha%
	}
	Else
		GuiControl, Enable, %hEdtdate%
Return

;ActualizaEdit:
;	Gui, %a_gui%: Submit, NoHide
;	If (_noPrint){
;		GuiControl, Disable, %hEdtNumIni%
;	}
;	Else
;		GuiControl, Enable, %hEdtNumIni%
;Return

Iniread:
If !FileExist(script.conf){
	MsgBox, 0x1030, Atención, No existe archivo de configuración.`nSe creará por defecto., 8
	Gosub, ActualizaFecha
	printer:= "\\FIXALIA003.FIXALIA.LOCAL\TA210"
	width:= "100 mm"
	height:= "5 mm"
	gap:= "3 mm, 0 mm"
	speed:= "2"
	density:= "6"
	direction:= "1"
	delay:= "150"
	date:= strFecha ;"aa000mm"
	autoFecha:= False
	numEtqAnt:= strFechaNumEtq ;"aa000000"
	numEtqRep:= "000000"
	numEtqRepSt:= "000000"
	xPos_0:= "290"
	yPos_0:= "20"
	xPos_1:= "558"
	yPos_1:= "20"
	xPosD_0:= "450"
	xPosD_1:= "718"
	yPosD_0:= "17"
	yPosD_1:= "17"
	ini:= "`;" . script.name . "`n"
	ini:= ini . "`;Configuración inicial de la Impresora.`n"
	ini:= ini . "`n"
	ini:= ini . "`;printer`t`tRuta y nombre de la impresora de etiquetas, configurada como sólo texto.`n"
	ini:= ini . "`;ptrLabelFile`t`tNombre del archivo de etiquetas en formato de texto plano .txt`n"
	ini:= ini . "`;size`t`t`tTamaño de la etiqueta. Por defecto: 100 mm, 5 mm,`n"
	ini:= ini . "`;gap`t`t`tDistancia entre eqtiquetas. Por defecto: 3mm, 0 mm.`n"
	ini:= ini . "`;speed`t`t`tVelocidad de impresión. Por defecto: 2`n"
	ini:= ini . "`;density`t`tDensidad de impresión. Por defecto: 6`n"
	ini:= ini . "`;direction`t`tDirección de impresión. Por defecto: 1`n"
	ini:= ini . "`;delay`t`t`tTiempo de espera entre impresiones, aumentar en caso de que se repitan las etiquetas.`n"
	ini:= ini . "`;date`t`t`tFecha que aparece en lado derecho de la etiqueta.`n"
	ini:= ini . "`;autoFecha`t`tActualiza automáticamente la fecha de la etiqueta.`n"
	ini:= ini . "`;xPos yPos`t`tCoordenadas de ipresion en las etiquetas.`n"
	ini:= ini . "`n"
	FileAppend, %ini%, % script.conf
	ini:= ""
	Gosub, Iniwrite
}

	IniRead, printer, % script.conf, Settings, printer
	IniRead, width, % script.conf, Settings, width
	IniRead, height, % script.conf, Settings, height
	IniRead, gap, % script.conf, Settings, gap
	IniRead, speed, % script.conf, Settings, speed
	IniRead, density, % script.conf, Settings, density
	IniRead, direction, % script.conf, Settings, direction
	IniRead, delay, % script.conf, Settings, delay
	IniRead, date, % script.conf, Settings, date
	IniRead, autoFecha, % script.conf, Settings, autoFecha
	IniRead, xPos_0, % script.conf, Settings, xPos_0
	IniRead, yPos_0, % script.conf, Settings, yPos_0
	IniRead, xPos_1, % script.conf, Settings, xPos_1
	IniRead, yPos_1, % script.conf, Settings, yPos_1
	IniRead, xPosD_0, % script.conf, Settings, xPosD_0
	IniRead, yPosD_0, % script.conf, Settings, yPosD_0
	IniRead, xPosD_1, % script.conf, Settings, xPosD_1
	IniRead, yPosD_1, % script.conf, Settings, yPosD_1
	IniRead, numEtqAnt, % script.conf, Label, numEtqSer
	IniRead, numEtqRep, % script.conf, Label, numEtqRep
	IniRead, numEtqRepSt, % script.conf, Label, numEtqRepSt

return


Iniwrite:
	IniWrite, %printer%, % script.conf, Settings, printer
	IniWrite, %width%, % script.conf, Settings, width
	IniWrite, %height%, % script.conf, Settings, height
	IniWrite, %gap%, % script.conf, Settings, gap
	IniWrite, %speed%, % script.conf, Settings, speed
	IniWrite, %density%, % script.conf, Settings, density
	IniWrite, %direction%, % script.conf, Settings, direction
	IniWrite, %delay%, % script.conf, Settings, delay
	IniWrite, %date%, % script.conf, Settings, date
	IniWrite, %autoFecha%, % script.conf, Settings, autoFecha
	IniWrite, %xPos_0%, % script.conf, Settings, xPos_0
	IniWrite, %yPos_0%, % script.conf, Settings, yPos_0
	IniWrite, %xPos_1%, % script.conf, Settings, xPos_1
	IniWrite, %yPos_1%, % script.conf, Settings, yPos_1
	IniWrite, %xPosD_0%, % script.conf, Settings, xPosD_0
	IniWrite, %yPosD_0%, % script.conf, Settings, yPosD_0
	IniWrite, %xPosD_1%, % script.conf, Settings, xPosD_1
	IniWrite, %yPosD_1%, % script.conf, Settings, yPosD_1
	FileAppend, `n, % script.conf
	IniWrite, %numEtqAnt%, % script.conf, Label, numEtqSer
	IniWrite, %numEtqRep%, % script.conf, Label, numEtqRep
	IniWrite, %numEtqRepSt%, % script.conf, Label, numEtqRepSt
Return



Setup:
	Gui, Submit, NoHide  ; Save each control's contents to its associated variable.
	Gosub, Settings
Return

SaveSettings:
	Gui, %a_gui%: Submit, NoHide
	Gui, Destroy

	width:= _width
	height:= _height
	gap:= _gap
	speed:= _speed
	density:= _density
	direction:= _direction - 1
	etiqueta_0:= _etiqueta_0
	etiqueta_1:= _etiqueta_1
	delay:= _delay
	date:= _date
	autoFecha:= _autoFecha
	xPos_0:= _xPos_0
	yPos_0:= _yPos_0
	xPos_1:= _xPos_1
	yPos_1:= _yPos_1
	numEtqSer:= _numEtqAnt

	if FileExist(script.conf)
	  Gosub, Iniwrite
	Else
	  Gosub, Iniread
	
	Gui Main: Show
	;Reload
Return

Imprimir:
	Gui, %a_gui%: Submit, NoHide

	StrEtq:= "SIZE " . width . ", " . height . "`n"
	StrEtq:= StrEtq . "GAP " . gap . "`n"
	StrEtq:= StrEtq . "SPEED " . speed . "`n"
	StrEtq:= StrEtq . "DENSITY " . density . "`n"
	StrEtq:= StrEtq . "DIRECTION " . direction . "`n"
	StrEtq:= StrEtq . "CLS" . "`n"
	strParam_0:= "TEXT " . xPos_0 . ", " . yPos_0 . ", ""0"", 0, 8, 8, "
	strParam_1:= "TEXT " . xPos_1 . ", " . yPos_1 . ", ""0"", 0, 8, 8, "
	strDmatrix_0:= "DMATRIX " . xPosD_0 . ", " . yPosD_0 . ", 64, 16, X3, a1, "
	strDmatrix_1:= "DMATRIX " . xPosD_1 . ", " . yPosD_1 . ", 64, 16, X3, a1, "
	
	If (_Tab < 2){
		
		If (_numEtq <= 1)
			_numEtq:= 2
		nEtq:= Round(_numEtq / 2)

		If (_marca != ""){
			strFechaMarca:= """/" . date . _pMarca . _marca
		}Else{
			strFechaMarca:= """/" . date
		}
		etiqueta_0:= _numEtqAnt
		etiqueta_1:= _numEtqAnt + 1
		StrEtqSt:= "SET COUNTER @0 +2`n" . "SET COUNTER @1 +2`n" . "@0=""" etiqueta_0 """`n" . "@1=""" etiqueta_1 """`n"
		StrEtqTmp:= StrEtqSt . StrEtq . strParam_0 . "@0+" . strFechaMarca . """`n"
		StrEtqTmp:= StrEtqTmp . strParam_1 . "@1+" . strFechaMarca . """`n"
		StrEtqTmp:= StrEtqTmp . "PRINT " . nEtq . "`n"
		writeFileEtq(StrEtqTmp,ptrLabelFile)
		Sleep, delay
		RunWait %ComSpec% /c copy "%ptrLabelFile%" "%printer%" ;> "%PtrLogFile%"
		numEtqAnt:= _numEtqAnt + _numEtq + Mod(_numEtq, 2)
		StStr:= "`t" . numEtqAnt
		SB_SetText(StStr,2)
		Gosub, loadItemsMain
		IniWrite, %numEtqAnt%, % script.conf, Label, numEtqSer

	}Else If (_Tab < 3){

		If (_numEtqRep <= 1)
			_numEtqRep:= 2
		nEtq:= Round(_numEtqRep / 2)
		StrCabecera:= _cabRep
		etiqueta_0:= _numIniRep + 1000000
		etiqueta_1:= etiqueta_0 + 1
		strEtiqueta_0:= SubStr(etiqueta_0, -5)
		strEtiqueta_1:= SubStr(etiqueta_1, -5)
		StrEtqSt:= "SET COUNTER @0 +2`n" . "SET COUNTER @1 +2`n" . "@0=""" strEtiqueta_0 """`n" . "@1=""" strEtiqueta_1 """`n"
		StrEtqTmp:= StrEtqSt . StrEtq . strParam_0 . """" . StrCabecera . """+@0" . "`n"
		StrEtqTmp:= StrEtqTmp . strParam_1 . """" . StrCabecera . """+@1" . "`n"
		StrEtqTmp:= StrEtqTmp . "PRINT " . nEtq . "`n"
		writeFileEtq(StrEtqTmp,ptrLabelFile)
		Sleep, delay
		RunWait %ComSpec% /c copy "%ptrLabelFile%" "%printer%" ;> "%PtrLogFile%"
		etiqueta_0+= _numEtqRep + Mod(_numEtqRep, 2)
		numEtqRep:= SubStr(etiqueta_0, -5)
		Gosub, loadItemsMain
		IniWrite, %numEtqRep%, % script.conf, Label, numEtqRep
		StrCabecera:= ""

	}Else If (_Tab < 4){
		if (_numEtqSpl <= 1)
			_numEtqSpl:= 2
		nEtq:= Round(_numEtqSpl / 2)
		StrCabecera:= _cabSimple

		If (_numIni == ""){
			StrEtqTmp:= StrEtq . strParam_0 . """" . StrCabecera . """`n"
			StrEtqTmp:= StrEtqTmp . strParam_1 . """" . StrCabecera . """`n"
			StrEtqTmp:= StrEtqTmp . "PRINT 1," . nEtq . "`n"
			writeFileEtq(StrEtqTmp,ptrLabelFile)
			Sleep, delay
			RunWait %ComSpec% /c copy "%ptrLabelFile%" "%printer%" ;> "%PtrLogFile%"
		}Else{
			
			etiqueta_0:= _numIni + 1000000
			etiqueta_1:= etiqueta_0 + 1
			strEtiqueta_0:= SubStr(etiqueta_0, -5)
			strEtiqueta_1:= SubStr(etiqueta_1, -5)
			StrEtqSt:= "SET COUNTER @0 +2`n" . "SET COUNTER @1 +2`n" . "@0=""" strEtiqueta_0 """`n" . "@1=""" strEtiqueta_1 """`n"
			StrEtqTmp:= StrEtqSt . StrEtq . strParam_0 . """" . StrCabecera . """+@0" . "`n"
			StrEtqTmp:= StrEtqTmp . strParam_1 . """" . StrCabecera . """+@1" . "`n"
			StrEtqTmp:= StrEtqTmp . "PRINT " . nEtq . "`n"
			writeFileEtq(StrEtqTmp,ptrLabelFile)
			Sleep, delay
			RunWait %ComSpec% /c copy "%ptrLabelFile%" "%printer%" ;> "%PtrLogFile%"
			
		}
		StrCabecera:= ""
		;StrEtq:= ""
	}Else{

		If (_numEtqRepSt <= 1)
			_numEtqRepSt:= 2
		nEtq:= Round(_numEtqRepSt / 2)

		StrCabecera:= _cabRepSt
		etiqueta_0:= _numIniRepSt + 1000000
		etiqueta_1:= etiqueta_0 + 1
		strEtiqueta_0:= SubStr(etiqueta_0, -5)
		strEtiqueta_1:= SubStr(etiqueta_1, -5)
		StrEtqSt:= "SET COUNTER @0 +2`n" . "SET COUNTER @1 +2`n" . "@0=""" strEtiqueta_0 """`n" . "@1=""" strEtiqueta_1 """`n"
		StrEtqTmp:= StrEtqSt . StrEtq . strParam_0 . """" . StrCabecera . """+@0" . "`n"
		If (_datamatrix)
			StrEtqTmp:= StrEtqTmp . strDmatrix_0 . """" . StrCabecera . """+@0" . "`n"
		StrEtqTmp:= StrEtqTmp . strParam_1 . """" . StrCabecera . """+@1" . "`n"
		If (_datamatrix)
			StrEtqTmp:= StrEtqTmp . strDmatrix_1 . """" . StrCabecera . """+@1" . "`n"
		StrEtqTmp:= StrEtqTmp . "PRINT " . nEtq . "`n"
		writeFileEtq(StrEtqTmp,ptrLabelFile)
		Sleep, delay
		RunWait %ComSpec% /c copy "%ptrLabelFile%" "%printer%" ;> "%PtrLogFile%"
		etiqueta_0+= _numEtqRepSt + Mod(_numEtqRepSt, 2)
		numEtqRepSt:= SubStr(etiqueta_0, -5)
		Gosub, loadItemsMain
		IniWrite, %numEtqRepSt%, % script.conf, Label, numEtqRepSt
		StrCabecera:= ""
		
	}
	StrEtq:= ""
Return

writeFileEtq(strEtq,tempF:=""){
	;global
	file := FileOpen(tempF, "w `n")
	if !IsObject(file){
		MsgBox, 16, Etiquetas, Can't open "%tempF%" for writing, exiting.
		return
	}
	file.Write(strEtq)
	file.Close()
	return 1
}

SettingsDlgGuiClose:
Cancel:
	Gui SettingsDlg: Cancel
		If (WinExist("ahk_id " . hMainWnd)) {
        Gui Main: Show
    }
Return

MainGuiClose:
Exit:
    ExitApp