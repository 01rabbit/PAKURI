#!/bin/bash
sudo -u postgres psql -q -d msf << _EOF
COPY (select address,os_name,os_sp,purpose,os_family,port,services.proto,
services.name,services.state,services.info from hosts,services where hosts.id = host_id )
 TO '/tmp/test.csv' with CSV DELIMITER ',' HEADER FORCE QUOTE *;
_EOF
mv /tmp/test.csv .
cat test.csv
