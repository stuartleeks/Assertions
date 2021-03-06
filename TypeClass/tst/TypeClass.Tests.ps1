Import-Module $PSScriptRoot\..\src\TypeClass.psm1

Describe "Test-Value" {
    It "Given '<value>', which is a value, string, enum, scriptblock or array with a single item of those types it returns `$true" -TestCases @(
        @{ Value = 1 },
        @{ Value = 2 },
        @{ Value = 1.2 },
        @{ Value = 1.3 },
        @{ Value = "abc"},
        @{ Value = [System.DayOfWeek]::Monday},
        @{ Value = @("abc")},
        @{ Value = @(1)},
        @{ Value = {abc}}
    ) {  
        param($Value)
        Test-Value -Value $Value | Verify-True
    }

    It "Given `$null it returns `$false" {
        Test-Value -Value $null | Verify-False
    }

    It "Given reference type (not string) '<value>' it returns `$false" -TestCases @(
        @{ Value = @() },
        @{ Value = @(1,2) },
        @{ Value = @{} },
        @{ Value = [type] },
        @{ Value = (New-Object -TypeName Diagnostics.Process) }
    ) {  
        param($Value)
        Test-Value -Value $Value | Verify-False
    }
}

#number

Describe "Test-DecimalNumber" { 
    It "Given a number it returns `$true" -TestCases @(
        @{ Value = 1.1; },
        @{ Value = [double] 1.1; },
        @{ Value = [float] 1.1; },
        @{ Value = [single] 1.1; },
        @{ Value = [decimal] 1.1; }
    ) { 
        param ($Value)
        Test-DecimalNumber -Value $Value | Verify-True
    }

    It "Given a string it returns `$false" { 
        Test-DecimalNumber -Value "abc" | Verify-False
    }
}

Describe "Test-ScriptBlock" { 
    It "Given a scriptblock '{<value>}' it returns `$true" -TestCases @(
        @{ Value = {} },
        @{ Value = {abc} },
        @{ Value = { Get-Process -Name Idle } }
    ) {
        param ($Value)
        Test-ScriptBlock -Value $Value | Verify-True 
    }

    It "Given a value '<value>' that is not a scriptblock it returns `$false" -TestCases @(
        @{ Value = $null },
        @{ Value = 1 },
        @{ Value = 'abc' },
        @{ Value = [Type] }
    ) {
        param ($Value)
        Test-ScriptBlock -Value $Value | Verify-False 
    }
}

# -- KeyValue collections
Describe "Test-Hashtable" { 
    It "Given hashtable '<value>' it returns `$true" -TestCases @(
        @{Value = @{} }
        @{Value = @{Name="Jakub"} }
    ) { 
        param($Value)

        Test-Hashtable -Value $Value | Verify-True
    }

    It "Given a value '<value>' which is not a hashtable it returns `$false" -TestCases @(
        @{ Value = "Jakub" }
        @{ Value = 1..4 }
    ) { 
        param ($Value)

        Test-Hashtable -Value $Value | Verify-False
    }
}

Describe "Test-Dictionary" { 
    It "Given dictionary '<value>' it returns `$true" -TestCases @(
        @{ Value = New-Object "Collections.Generic.Dictionary[string,object]" }
        @{ Value= New-Dictionary @{Name="Jakub"} }
    ) { 
        param($Value)

        Test-Dictionary -Value $Value | Verify-True
    }

    It "Given a value '<value>' which is not a dictionary it returns `$false" -TestCases @(
        @{ Value = "Jakub" }
        @{ Value = 1..4 }
    ) { 
        param ($Value)

        Test-Dictionary -Value $Value | Verify-False
    }
}


# -- collection
Describe "Test-Collection" {
    It "Given a collection '<value>' of type '<type>' implementing IEnumerable it returns `$true" -TestCases @(
        @{ Value = "abc" }
        @{ Value = 1,2,3 }
        @{ Value = [Collections.Generic.List[Int]](1,2,3) }
    ) {
        param($Value)
        Test-Collection -Value $Value | Verify-True
    }

    It "Given an object '<value>' of type '<type>' that is not a collection it returns `$false" -TestCases @(
        @{ Value = 1 }
        @{ Value = New-Object -TypeName Diagnostics.Process }
    ) {
        param($Value)
        Test-Collection -Value $Value | Verify-False
    }
}