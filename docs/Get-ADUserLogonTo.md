---
external help file: Set-ADUserLogonTo-help.xml
online version: https://github.com/JohnForet/Set-ADUserLogonTo/blob/master/docs/Get-ADUserLogonTo.md
schema: 2.0.0
---

# Get-ADUserLogonTo
## SYNOPSIS
Outputs the computers a user is restricted to logging into via the userWorkstations attribute in AD

## SYNTAX

```
Get-ADUserLogonTo [-Identity] <Object> [-ReturnCount]
```

## DESCRIPTION
Queries a user's userWorkstations attribute in AD, and can return either the computers that user is restricted to logging into via that attribute, or just how many computers are contained with that attribute.

## EXAMPLES

### Example 1
```
PS C:\> Get-ADUserLogonTo -Identity testuser
```

Returns the computers, if any, that testuser is restricted to logging into via the userWorkstations attribute.
### Example 2
```
PS C:\> Get-ADUserLogonTo -Identity testuser -ReturnCount
```

Returns how many computers, if there are any, that testuser is restricted to logging into via the userWorkstations attribute.

## PARAMETERS

### -Identity
the username of the user to query

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value:
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ReturnCount
If specified, instead of returning the computers the user is restricted to logging into, returns how many computers the user is restricted to logging into.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

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
