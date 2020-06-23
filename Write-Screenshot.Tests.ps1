Describe "Write-Screenshot Tests" {
    BeforeAll {
        . .\Write-Screenshot.ps1
        Push-Location
        Set-Location $TestDrive
        Set-Variable dateFilenameFormat "yyyy-MM-dd_HH.mm.ss" -Option Constant 
        Set-Variable isRunningUnderTest -Value True -Scope Script
    }

    AfterAll {
        Set-Variable isRunningUnderTest -Value False -Scope Script
        Pop-Location
    }

    Context 'Write-Screenshot FolderPath and Filename parameter handling' {
        
        BeforeAll {
            Set-Variable someDate ([DateTime]"07/06/2023 05:00:10") -Option Constant
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

    Context 'Write-Screenshot -Times, -Interval and -Forever parameter handling' {
        BeforeAll {
            mock -CommandName 'Start-Sleep' –MockWith { }
        }

        It 'Should accept -Interval and -Times parameters' {
            Write-Screenshot -Interval 3 -Times 2
         }

        It 'Should call Start-Sleep (Times-1) times with correct Interval' {
            Set-Variable sleepSecs 10 -Option Constant
            Set-Variable times 3 -Option Constant

            Write-Screenshot -Interval $sleepSecs -Times $times
            Assert-MockCalled Start-Sleep -Exactly ($times-1) -ExclusiveFilter { $Seconds -eq $sleepSecs }
        }

        It 'Should create Times number of screenshot' {
            Set-Variable times 3 -Option Constant
            Set-Variable folder '.\sshots' -Option Constant
            $anyDate = ([DateTime]"07/06/2024 05:00:10")
            $timesCalled = 0;

            mock -CommandName 'Get-Date' –MockWith {
                $Format | Should -Be $dateFilenameFormat
                return $anyDate.AddSeconds($script:timesCalled++).toString($Format)
            }

            Write-Screenshot -FolderPath $folder -Times $times
            (Get-ChildItem $folder | Measure-Object).Count | Should -Be $times
        }
        It 'Should accept -Forever parameter' -Skip {
            $global:isTestingForever = $true
            Write-Screenshot -Forever
            $global:isTestingForever = $true
        }
    }
}
