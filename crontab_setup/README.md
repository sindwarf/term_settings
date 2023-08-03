# Crontab
```bash
0 2 * * * ~/.term_settings/crontab_setup/run_rsync.sh >/dev/null 2>&1 (run at 2:00 am every day)
| | | | | |
| | | | | command
| | | | Day of week (0=Sunday)
| | | Month (0=none, 12=December)
| | Day (0-31) 
| Hour (0-23)
Minute (0-59)

* all values
, specifies separate values 
- range of values
/ divide a value into steps ("\*/2" every other value)
```

# How to write over your current crontab
```bash
crontab new_crontab_file
```

# How to add to crontab
```bash
crontab -e
```
