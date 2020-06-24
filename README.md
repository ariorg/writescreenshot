# Write-Screenshot
Periodic screen capture in Powershell

## Description
Captures a screenshot of the current screen and stores it as jpg-file in the supplied directory. By default the file is named by the current date and time like so 2024-06-20_10.06.37.jpg.

## Examples

```powershell    
Write-Screenshot
```
Creates a screenshot file in the format 2024-06-20_10.06.37.jpg in the current directory.
```powershell    
Write-Screenshot C:\MyStuff\Screenshots
```
Creates a screenshot file C:\MyStuff\Screenshots\2024-06-20_10.06.37.jpg
```powershell    
Write-Screenshot -FolderPath /Screenshots -Filename screenshot10
```
Creates a screenshot file /Screenshots/screenshot10.jpg
```powershell    
Write-Screenhot -FolderPath /Screenshots -Interval 600 -Times 10
```
Creates screenshot every 10 minutes in /Screenshots as 2024-06-20_10.06.37.jpg,
2024-06-20_20.06.37.jpg, 024-06-30_10.06.37.jpg etc.

```powershell    
Write-Screenhot -FolderPath /Screenshots -Interval 60 -Forever
```
Creates screenshot, one every minutes in /Screenshots forever.
