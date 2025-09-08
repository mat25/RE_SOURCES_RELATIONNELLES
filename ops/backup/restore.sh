#!/usr/bin/env bash
set -euo pipefail
usage(){ echo "Usage: $0 <backup_dir> [--pg-url URL|--mysql-url URL]"; }
DIR=${1:-}; [[ -d $DIR ]] || { usage; exit 1; }
PG_URL=""; MY_URL=""; shift || true
while [[ $# -gt 0 ]]; do case $1 in
  --pg-url) PG_URL=$2; shift 2;;
  --mysql-url) MY_URL=$2; shift 2;;
  *) usage; exit 1;; esac; done
if [[ -f $DIR/db.dump && -n $PG_URL ]]; then pg_restore -d "$PG_URL" "$DIR/db.dump"; fi
if [[ -f $DIR/db.sql && -n $MY_URL ]]; then mysql "$MY_URL" < "$DIR/db.sql"; fi
if [[ -f $DIR/files.tgz ]]; then tar xzf "$DIR/files.tgz" -C .; fi
echo "Restauration OK depuis $DIR"
