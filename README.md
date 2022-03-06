# DailiesChecker

WoW Classic TBC addon for displaying the various statuses of the dailies on your curren toon.

This addon does not know beforehand which rotating daily is the current one (eg. the daily heroic). It will know whether or not you're missing it, and it will display the proper daily once you've taken it.

### Main slash command:
```
/dcheck or /dch
```

### Slash command standard options:
```
/dcheck - shows the default list, which is the 'dl' list
/dcheck d - shows the done list: turned-in dailies, and completed but not yet turned-in dailies
/dcheck ql - shows the quest log list: completed but not yet turned-in dailies, and accepted dailies
/dcheck dl - shows the done & quest log list: turned-in dailies, completed but not yet turned-in dailies, and accepted dailies
/dcheck m - shows the missing list: dailies that have not been taken
/dcheck a - shows a list of all the dailies
/dcheck h - shows help text
```

### Slash command extra options:
Can also print out statuses by category.
Available categories: dungeons, professions, skettis, ogrila, netherwing, shattsun, pvp

Format:
```
/dcheck [category] [action] 
```

Example:
```
/dcheck pvp - shows a list of 'dl' dailies that are in the "pvp" category
/dcheck dungeons d - shows a list of turned-in dailies that are in the "dungeons" category
```
