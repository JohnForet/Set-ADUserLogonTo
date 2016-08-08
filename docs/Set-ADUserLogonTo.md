---
external help file: Set-ADUserLogonTo-help.xml
online version: https://github.com/JohnForet/Set-ADUserLogonTo/blob/master/docs/Set-ADUserLogonTo.md
schema: 2.0.0
---

# Set-ADUserLogonTo
## SYNOPSIS
Set the userWorkstations attribute on an AD user.

## SYNTAX

### SetToNull
```
Set-ADUserLogonTo [-Identity <Object>] [-SetToNull] [-WhatIf] [-Confirm]
```

### ComputerList
```
Set-ADUserLogonTo [-Identity <Object>] -ComputerList <Object> [-MaximumComputers <Object>] [-WhatIf] [-Confirm]
```

## DESCRIPTION
Set the userWorkstations attribute on an AD user to restrict which computers they can logon to, or can blank the attribute allowing the user to logon to any computer. As part of the wildcard support in the ComputerList parameter, each computername is retrieved using an AD query, so the computer must exist in AD before it can be added to as a restriction on a user. At the moment, this function is destructive, meaning it doesnt keep any data that the userWorkstations may have held before running this command.

## EXAMPLES

### Example 1
```
PS C:\> Set-ADUserLogonTo -Identity fakeuser -ComputerList JSMITH-LT,WGATES-LT,CKNOX-DESKTOP
```

Sets userWorkstations attribute on "fakeuser" to the three computers `JSMITH-LT,WGATES-LT,CKNOX-DESKTOP`.
### Example 2
```
PS C:\> Set-ADUserLogonTo -Identity fakeuser -ComputerList *LT
```

Sets userWorkstations attribute on "fakeuser" to any computer that ends in `LT`.
### Example 3
```
PS C:\> Set-ADUserLogonTo -Identity fakeuser -ComputerList DC109*,AC102-DESKTOP
```

Sets userWorkstations attribute on "fakeuser" to any computer in that begins with `DC109`, and a computer named `AC102-DESKTOP`.
### Example 4
```
PS C:\> Set-ADUserLogonTo -Identity fakeuser -SetToNull
```

Blanks out the userWorkstations attribute on "fakeuser", allowing it to login to any computer.

## PARAMETERS

### -ComputerList
This parameter specifies which computers you'd like to restrict the user to logging into. This can be in the form of a wildcard query `"ROOMNAME*"`, a comma-delimted list of computers `"JSMITH-LT,WGATES-LT"`, or any combination of those two `"ROOMNAME*,JSMITH-LT,*DESKTOP*"`. A limitation included with the introduction of wildcard support here is that the computer must already exist in AD in order to add it via this function.

```yaml
Type: Object
Parameter Sets: ComputerList
Aliases:

Required: True
Position: Named
Default value:
Accept pipeline input: False
Accept wildcard characters: True
```

### -Confirm
If specified as $false, the command will make changes without prompting you first. Unless you need to make changes with Set-ADUserLogonTo in an automated fashion, I'd leave this parameter alone, as the prompt shows you which computers the command will set before applying it to the user.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value:
Accept pipeline input: False
Accept wildcard characters: False
```

### -Identity
the username of the user that you'd like to modify the logon restrictions on.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value:
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaximumComputers
This property is limited to 64 values in most AD environments, but it is possible to expand it to have more, with the caveat of it not being recommended by Microsoft. It's here as a parameter in the case that you've modified Active Directory to be able to handle more values in the userWorkstations attribute.
https://support.microsoft.com/en-us/kb/938458

```yaml
Type: Object
Parameter Sets: ComputerList
Aliases:

Required: False
Position: Named
Default value: 64
Accept pipeline input: False
Accept wildcard characters: False
```

### -SetToNull
If specified, will blank out the userWorkstations attribute on the user, allowing them to logon to any computer they like.

```yaml
Type: SwitchParameter
Parameter Sets: SetToNull
Aliases:

Required: True
Position: Named
Default value:
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
If specified, will output what the command will do without making any changes.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value:
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.Object


## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
