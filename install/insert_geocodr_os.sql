INSERT INTO tiger.loader_platform(os, declare_sect, pgbin, wget, unzip_command, psql, path_sep, loader, environ_set_command, county_process_command)
SELECT 'geocodr', declare_sect, pgbin, wget, unzip_command, psql, path_sep, loader, environ_set_command, county_process_command
FROM tiger.loader_platform
WHERE os = 'sh';
