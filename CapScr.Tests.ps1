Describe "CapScr Test Group" {
    BeforeAll {
        . .\CapScr.ps1
        Push-Location
        Set-Location $TestDrive
    }

    AfterAll {
        Pop-Location
    }

    Context 'Write-Screenshot path and filename parameter handling' {
        
        BeforeAll {
            Set-Variable someDate ([DateTime]"07/06/2015 05:00:10") -Option Constant
            Set-Variable dateFilenameFormat "yyyy-MM-dd_HH.mm.ss" -Option Constant 
            Set-Variable screenShotFilename "$($someDate.toString($dateFilenameFormat)).jpg" -Option Constant
            Set-Variable someFolder  (Join-Path $TestDrive '/AnyFolder/SomeOtherFolder') -Option Constant

            mock -CommandName 'Get-Date' –MockWith {
                param($Format)

                $Format | Should -Be $dateFilenameFormat
                return $someDate.toString($Format)
            }

        }

        It 'Should create datetime-named file in current dir if path not supplied' {
            $screenShotFilename | Should -Not -Exist
            Write-Screenshot
            $screenShotFilename | Should -Exist
        }

        It 'Should create date-named file in the supplied folder' {
            Set-Variable fullPath -Option Constant -Value (Join-Path $someFolder $screenShotFilename)
            $fullPath | Should -Not -Exist
            Write-Screenshot $someFolder
            $fullPath | Should -Exist
        }

        It 'Should create filename.jpg file if Filename parameter is provided' {
            Set-Variable someFilename "SomeFilename" -Option Constant
            
            $someFilename | Should -Not -Exist
            Write-Screenshot -Filename $someFilename
            "$someFilename.jpg" | Should -Exist
        }
    }

    Context 'Write-Screenshot path and filename parameter handling' {
        BeforeAll {
            mock -CommandName 'Start-Sleep' –MockWith { }
        }

        It 'should accept -WatchInterval and -Times parameters' {
            Write-Screenshot -WatchInterval 12 -Times 1
         }

        It 'should call StartSleep with -WatchInterval and -Times times' -Skip {
            Set-Variable sleepSecs 10 -Option Constant
            Set-Variable howOften 3 -Option Constant

            Write-Screenshot -WatchInterval $sleepSecs -Times $howOften

            Assert-MockCalled Start-Sleep -Exactly $howOften -ExclusiveFilter { $Seconds -eq $sleepSecs }
        }
        
    }
}
