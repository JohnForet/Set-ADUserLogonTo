Function Test-ADModule {
    [CmdletBinding()]
    Param()
    BEGIN {
        if (Get-Module -ListAvailable -Name ActiveDirectory) {
                return $true
        } else {
            Write-Error "ActiveDirectory Module is not available. Module may need to be installed from RSAT."
        }
    }
}

function Get-ADUserLogonTo{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true)]
        $Identity,
        [switch]$ReturnCount

    )
    BEGIN{
        Test-ADModule -ErrorAction Stop
        $user = Get-ADUser -Identity $Identity -Properties userWorkstations
    }
    PROCESS{
        if ($user.userWorkstations -notlike ""){
            $count = 0
            foreach($workstation in $user.userWorkstations.split(",")){
                $count += 1
                if(!$ReturnCount){
                    $object = New-Object –TypeName PSObject –Prop @{'ComputerName'=$workstation}
                    $object.PSObject.TypeNames.Insert(0,'Microsoft.ActiveDirectory.Management.ADUser.userWorkstations')
                    Write-Output $object
                }
            }
            if($ReturnCount){
                Write-Output $count
            }
        }
    }
}

function Set-ADUserLogonTo{
    [CmdletBinding(
        SupportsShouldProcess=$True,
        ConfirmImpact="High"
        )]
    Param(
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true)]
        [Parameter(ParameterSetName='ComputerList')]
        [Parameter(ParameterSetName='SetToNull')]
        $Identity,
        [Parameter(Mandatory=$true,
                   ParameterSetName='ComputerList')]
        $ComputerList,
        [Parameter(ParameterSetName='ComputerList')]
        $MaximumComputers = 64,
        [Parameter(Mandatory=$true,
                   ParameterSetName='SetToNull')]
        [switch]$SetToNull
    )
    BEGIN {
        Test-ADModule -ErrorAction Stop
    }
    PROCESS {
        if ($SetToNull) {
            if ($PSCmdlet.ShouldProcess($Identity,"Disabling logon restrictions")) {
                Set-ADUser -Identity $Identity -LogonWorkstations $null
            }
        }
        elseif ($ComputerList -ne $null) {
            $ComputerListArray = $ComputerList.split(",")
            $ConcatenatedQuery = $null
            foreach ($Name in $ComputerListArray) {
                $Query = (Get-ADComputer -Filter 'Name -like $Name').Name -join ','
                $ConcatenatedQuery += $Query.Insert(0,',')
            }
            $ConcatenatedQuery = $ConcatenatedQuery.TrimStart(",") #removes the unneccessary leading comma
            $SplitQuery = $ConcatenatedQuery.split(",")
            $SplitQueryLength = $SplitQuery.Length
            if ($SplitQueryLength -gt $MaximumComputers) {
                Write-Error -Message "Computer count has $SplitQueryLength entries. Count returned from query must have a value of $MaximumComputers or less. Attempted value was:`n$SplitQuery`n"
            }
            elseif ($SplitQueryLength -le $MaximumComputers) {
                if ($PSCmdlet.ShouldProcess($Identity,"Setting logon restrictions to the following $SplitQueryLength Computers:`n$SplitQuery`n")) {
                    Set-ADUser -Identity $Identity -LogonWorkstations $ConcatenatedQuery
                }
            }
        }
    }
}