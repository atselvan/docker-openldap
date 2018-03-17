#!/bin/bash
#
# Start Openldap

# Variables

echo "Configuring OpenLDAP"
./sbin/slappasswd -s $LDAP_PASSWORD > encrypted-pass.txt
ENCRYPTED_PASSWORD=`cat encrypted-pass.txt`
rm -rf encrypted-pass.txt
sed -i s/\$LDAP_BASE_DN/$LDAP_BASE_DN/g ./etc/openldap/slapd.conf
sed -i s/\$LDAP_PASSWORD/$ENCRYPTED_PASSWORD/g ./etc/openldap/slapd.conf
./sbin/slaptest -f ./etc/openldap/slapd.conf -F ./etc/openldap/slapd.d -u

echo "Starting OpenLDAP"
./libexec/slapd -h "ldap://$LDAP_HOST:$LDAP_PORT" -d -1