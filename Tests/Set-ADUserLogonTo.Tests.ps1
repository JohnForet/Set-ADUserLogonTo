﻿$ModuleName = "Set-ADUserLogonTo"
$RootPath = (Get-Item -Path $PSScriptRoot).Parent.FullName
$ModuleManifest = "$RootPath\$ModuleName.psd1"

Get-Module $ModuleName | Remove-Module
Import-Module $ModuleManifest

InModuleScope $ModuleName {
    Describe Test-ADModule {
        It "returns true when ad module is present"{
            Mock Get-Module {return $true}
            Test-ADModule | Should Be $true
            {Test-ADModule -ErrorAction:Stop} | Should Not Throw
        }
        It "throws an error when ad module is not present"{
            Mock Get-Module{return $false}
            {Test-ADModule -ErrorAction:Stop} | Should Throw
        }
    }
    Describe Get-ADUserLogonTo {
        It "throws an error when AD module isnt available"{
            Mock Get-Module {return $false}
            {Get-ADUserLogonTo -Identity FakeUser} | Should Throw
        }
        Mock Get-Module {return $true}
        Function Get-ADUser {} 
        Mock Get-ADUser {[PSCustomObject]@{userWorkstations = "COMPUTER1","COMPUTER2"}}
        It "has a workstation count of 2"{
            Get-ADUserLogonTo -Identity PlaceHolder -ReturnCount | Should Be '2'
        }
        It "has the correct workstations outputted" {
            (Get-ADUserLogonTo -Identity PlaceHolder).ComputerName -contains "COMPUTER1" | Should Be $true
            (Get-ADUserLogonTo -Identity PlaceHolder).ComputerName -contains "COMPUTER2" | Should Be $true
            (Get-ADUserLogonTo -Identity PlaceHolder).ComputerName -contains "FAKECOMPUTER" | Should Be $false
        }
    }
    Describe Set-ADUserLogonTo {
        It "throws an error when AD module isnt available" {
            Mock Get-Module {return $false}
            {Set-ADUserLogonTo -Identity FakeUser} | Should Throw
        }
        Mock Get-Module {return $true}
        Function Get-ADComputer {
            Param(
                $Identity
            )
        }
        Mock Get-ADComputer {
            [pscustomobject]@{
                Name = $Identity
            }
        }
        Function Set-ADUser {
            Param(
                $Identity,
                $LogonWorkstations
            )
        }
        Mock Set-ADUser {
            [pscustomobject]@{
                Name = $Identity
                LogonWorkstations = $LogonWorkstations
            }
        }
        It "sets logonworkstations to null" {
            (Set-ADUserLogonTo -Identity PlaceHolder -Confirm:$false -SetToNull).LogonWorkstations | Should BeNullOrEmpty
        }
        It "sets logon workstions to two computers" {
            (Set-ADUserLogonTo -Identity PlaceHolder -Confirm:$false -ComputerList "COMPUTER1","COMPUTER2").LogonWorkstations | Should Not BeNullOrEmpty
            (Set-ADUserLogonTo -Identity PlaceHolder -Confirm:$false -ComputerList "COMPUTER1","COMPUTER2").LogonWorkstations | Should BeLike "*COMPUTER1*"
            (Set-ADUserLogonTo -Identity PlaceHolder -Confirm:$false -ComputerList "COMPUTER1","COMPUTER2").LogonWorkstations | Should BeLike "*COMPUTER2*"
            (Set-ADUserLogonTo -Identity PlaceHolder -Confirm:$false -ComputerList "COMPUTER1","COMPUTER2").LogonWorkstations | Should Not BeLike "*FAKECOMPUTER*"
        }
        It "works when given the default max of 64 computers" {
            $complist = ""
            1..64 | ForEach-Object{$complist += "COMPUTER$_,"}
            $complist = $complist.TrimEnd(",")
            (Set-ADUserLogonTo -Identity PlaceHolder -Confirm:$false -ComputerList $complist).LogonWorkstations | Should BeLike "*COMPUTER1,*"
            (Set-ADUserLogonTo -Identity PlaceHolder -Confirm:$false -ComputerList $complist).LogonWorkstations | Should BeLike "*COMPUTER64*"
            {Set-ADUserLogonTo -Identity PlaceHolder -Confirm:$false -ComputerList $complist -ErrorAction:Stop} | Should Not Throw
        }
        It "throws when given computers beyond the default 64" {
            $complist = ""
            1..65 | ForEach-Object{$complist += "COMPUTER$_,"}
            $complist = $complist.TrimEnd(",")
            {Set-ADUserLogonTo -Identity PlaceHolder -Confirm:$false -ComputerList $complist -ErrorAction:Stop} | Should Throw
        }
        It "is be able to set the computers to the user supplied max" {
            $complist = ""
            1..200 | ForEach-Object{$complist += "COMPUTER$_,"}
            $complist = $complist.TrimEnd(",")           
            (Set-ADUserLogonTo -Identity PlaceHolder -Confirm:$false -ComputerList $complist -MaximumComputers 200).LogonWorkstations | Should BeLike "*COMPUTER1,*"
            (Set-ADUserLogonTo -Identity PlaceHolder -Confirm:$false -ComputerList $complist -MaximumComputers 200).LogonWorkstations | Should BeLike "*COMPUTER200*"
            {Set-ADUserLogonTo -Identity PlaceHolder -Confirm:$false -ComputerList $complist -MaximumComputers 200 -ErrorAction:Stop} | Should Not Throw
        }
        It "throws when given computers beyond the user supplied max" {
            $complist = ""
            1..201 | ForEach-Object{$complist += "COMPUTER$_,"}
            $complist = $complist.TrimEnd(",")
            {Set-ADUserLogonTo -Identity PlaceHolder -Confirm:$false -ComputerList $complist -MaximumComputers 200 -ErrorAction:Stop} | Should Throw
        }
    }
}

Get-Module $ModuleName | Remove-Module