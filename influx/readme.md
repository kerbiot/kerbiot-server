# Influx backup and restore

First time setup:

```sh
./install.sh
cp example.env .env
```

Fill out the `.env` file.

## Backup

```sh
./backup.sh
```

A `.zip` backup file will be created with current date and timestamp as name.

## Restore

```sh
./restore.sh 2022-09-16-18-27-14.zip
```
