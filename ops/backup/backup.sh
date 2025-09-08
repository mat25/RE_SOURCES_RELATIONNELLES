#!/usr/bin/env bash
set -euo pipefail
usage(){ echo "Usage: $0 [--dry-run] [--pg-url URL|--mysql-url URL] [--extra PATH]"; }
DRY=0; PG_URL=""; MY_URL=""; EXTRA=""; NOW=$(date +%F_%H%M)
while [[ $# -gt 0 ]]; do case $1 in
  --dry-run) DRY=1; shift;;
  --pg-url) PG_URL=$2; shift 2;;
  --mysql-url) MY_URL=$2; shift 2;;
  --extra) EXTRA=$2; shift 2;;
  *) usage; exit 1;; esac; done
OUT="backups/$NOW"; mkdir -p "$OUT"
log(){ echo "[$(date +%T)] $*"; }
if [[ -n $PG_URL ]]; then
  log "PostgreSQL dump"
  if [[ $DRY -eq 1 ]]; then echo "(dry-run) pg_dump $PG_URL > $OUT/db.dump" | tee "$OUT/pg.log"; else pg_dump -Fc "$PG_URL" > "$OUT/db.dump"; fi
fi
if [[ -n $MY_URL ]]; then
  log "MySQL dump"
  if [[ $DRY -eq 1 ]]; then echo "(dry-run) mysqldump $MY_URL > $OUT/db.sql" | tee "$OUT/mysql.log"; else mysqldump "$MY_URL" > "$OUT/db.sql"; fi
fi
if [[ -n $EXTRA ]]; then
  log "Archivage fichiers"
  if [[ $DRY -eq 1 ]]; then echo "(dry-run) tar czf $OUT/files.tgz $EXTRA" | tee "$OUT/files.log"; else tar czf "$OUT/files.tgz" "$EXTRA"; fi
fi
log "OK — artefacts dans $OUT"
