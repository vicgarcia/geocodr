UPDATE tiger.loader_platform
SET declare_sect =
'TMPDIR="${staging_fold}/temp/"
UNZIPTOOL=unzip
WGETTOOL="/usr/bin/wget"
export PGBIN=/usr/bin
export PGPORT=5432
export PGHOST=localhost
export PGUSER=geocodr
export PGPASSWORD=geocodr
export PGDATABASE=geocodr
PSQL=${PGBIN}/psql
SHP2PGSQL=${PGBIN}/shp2pgsql
cd ${staging_fold}'
WHERE os = 'geocodr';
