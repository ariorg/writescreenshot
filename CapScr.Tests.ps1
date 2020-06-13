Describe "CapScr Test Group" {
    Context "The initial CapScr context" {
        It "CapScr should create a file" {
           $true | Should -Be $true 
        }
        It "should refuse a parameter" {
           "this" | Should -BeExactly "this" 
        }
        It "should show a skip" -Skip  {
           "this" | Should -BeExactly "this" 
        }
    }
}
