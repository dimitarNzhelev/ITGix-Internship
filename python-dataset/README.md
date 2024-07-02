The log.txt file is created from a cronjob
to do it run:

```
crontab -e
* * * * * echo "Test" >> /path/to/repository/python-dataset/log.txt
```
