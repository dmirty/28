#!/bin/sh

PG_DIR="/var/lib/pgsql/11"
PG_DATA_DIR="$PG_DIR/data"
PG_BACKUP_DIR="$PG_DIR/backups"
PG_BASE_BACKUP_DIR="$PG_BACKUP_DIR/base"
PG_ARCHIVE_BACKUP_DIR="$PG_BACKUP_DIR/archive"
DATE="/bin/date"
DATE_TIME_PREFIX=`$DATE +%Y%m%d%H%M%S`
PG_BASE_BACKUP_FILE="$DATE_TIME_PREFIX.tar"
PSQL="sudo -u postgres psql"
TAR="/bin/tar"
CHMOD="/bin/chmod"
TOUCH="/bin/touch"
RM="/bin/rm"
BZIP2="/usr/bin/bzip2"
MKDIR="/bin/mkdir"
ECHO="/bin/echo"

if [[ -f $PG_DIR/backup_in_progress ]]; then
  $ECHO "Error: Backup in progress."
  exit 1
fi

if [[ ! -d $PG_BASE_BACKUP_DIR ]]; then
  $ECHO "Directory $PG_BASE_BACKUP_DIR doesn't exists. Trying create it."
  $MKDIR -p $PG_BASE_BACKUP_DIR
  $CHMOD 0700 $PG_BASE_BACKUP_DIR
fi

$TOUCH $PG_DIR/backup_in_progress
$PSQL -c "SELECT pg_start_backup('$PG_BASE_BACKUP_DIR/$DATE_TIME_PREFIX');"
$TAR cvf $PG_BASE_BACKUP_DIR/$PG_BASE_BACKUP_FILE $PG_DATA_DIR
$PSQL -c "SELECT pg_stop_backup();"
$TAR rf $PG_BASE_BACKUP_DIR/$PG_BASE_BACKUP_FILE $PG_ARCHIVE_BACKUP_DIR
$CHMOD 0600 $PG_BASE_BACKUP_DIR/$PG_BASE_BACKUP_FILE
$BZIP2 -9 $PG_BASE_BACKUP_DIR/$PG_BASE_BACKUP_FILE
$RM -f $PG_ARCHIVE_BACKUP_DIR/*
$RM -f $PG_DIR/backup_in_progress

exit 0
