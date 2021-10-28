; Close the active window.
#x::
	WinGetTitle, Title, A
	PostMessage, 0x112, 0xF060,,, %Title%
	Return

; Terminal
#Enter::
	Run "C:\Program Files\WindowsApps\Microsoft.WindowsTerminal_1.10.2714.0_x64__8wekyb3d8bbwe\WindowsTerminal.exe"
	Return

; Browser
#b::
	Run "C:\Users\Public\Desktop\Firefox.lnk"
	Return

; Chat
#c::
	Run "C:\Program Files\WindowsApps\5319275A.WhatsAppDesktop_2.2140.12.0_x64__cv1g1gvanyjgm\app\WhatsApp.exe"
	Return

; Discord
#d::
	Run "C:\Users\mateo\Desktop\Discord.lnk"
	Return

; Music
#m::
	Run "C:\Program Files\WindowsApps\AppleInc.iTunes_12121.1.54014.0_x64__nzyj5cx40ttqa\iTunes.exe"
	Return

; Task Manager
#+m::
	Run "C:\Windows\System32\Taskmgr.exe"
	Return
