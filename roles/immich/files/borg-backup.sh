#!/bin/sh

# Paths
UPLOAD_LOCATION="/opt/immich/library"
BACKUP_PATH="/mnt/immich_backup"
REMOTE_HOST="root@chadpi"
REMOTE_BACKUP_PATH="/mnt/immich_backup"


### Local

# Backup Immich database
docker exec -t immich_postgres pg_dumpall --clean --if-exists --username=postgres > "$UPLOAD_LOCATION"/database-backups/immich-database.sql
# For deduplicating backup programs such as Borg or Restic, compressing the content can increase backup size by making it harder to deduplicate. If you are using a different program or still prefer to compress, you can use the following command instead:
# docker exec -t immich_postgres pg_dumpall --clean --if-exists --username=postgres | /usr/bin/gzip --rsyncable > "$UPLOAD_LOCATION"/database-backup/immich-database.sql.gz

### Append to local Borg repository
borg create "$BACKUP_PATH/immich_borg::{now}" "$UPLOAD_LOCATION" --exclude "$UPLOAD_LOCATION"/thumbs/ --exclude "$UPLOAD_LOCATION"/encoded-video/
borg prune --keep-weekly=4 --keep-monthly=3 "$BACKUP_PATH"/immich_borg
borg compact "$BACKUP_PATH"/immich_borg


### Append to remote Borg repository
borg create "$REMOTE_HOST:$REMOTE_BACKUP_PATH/immich_borg::{now}" "$UPLOAD_LOCATION" --exclude "$UPLOAD_LOCATION"/thumbs/ --exclude "$UPLOAD_LOCATION"/encoded-video/
borg prune --keep-weekly=4 --keep-monthly=3 "$REMOTE_HOST:$REMOTE_BACKUP_PATH"/immich_borg
borg compact "$REMOTE_HOST:$REMOTE_BACKUP_PATH"/immich_borg
