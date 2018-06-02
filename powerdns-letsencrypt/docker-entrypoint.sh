#!/bin/sh

/usr/bin/pdnsutil check-all-zones

/usr/sbin/pdns_server --api-key=$APIKEY
