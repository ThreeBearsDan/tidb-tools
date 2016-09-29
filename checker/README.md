## Checker

Checker is a tool for check the compatibility of an existed MySQL database with TiDB.

## How to use

```
Usage of checker:
  -L string
        log level: debug, info, warn, error, fatal (default "info")
  --host string
        MySQL host (default "127.0.0.1")
  --port int
        MySQL port (default 3306)
  --user string
        MySQL username (default "root")
  --password string
        MySQL password (default "")

cd checker
go build
./checker dbName tableNameList
```


## Example

```
# check all the tables in test database
./bin/checker --host 127.0.0.1 --port 3306 --user root --password 123 test

# check some tables in the test database
./bin/checker --host 127.0.0.1 --port 3306 --user root --password 123 test tbl1 tbl2
```

## Incompatible problems

We only check the following incompatible problems:
- Unsuported charset
TiDB Only support uft8, binary charset.
- Foreign Key
TiDB parse foreign key syntax but do not do the actual constrain checking. This will report a warning.

## License
Apache 2.0 license. See the [LICENSE](../LICENSE) file for details.
