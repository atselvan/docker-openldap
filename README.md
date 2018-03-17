# OpenLDAP Docker Image

Docker container for OpenLDAP.

## Build the image

```sh
docker build -t allanselvan/openldap:latest .
```

## Run the container

```sh
docker run --name openldap -d -p 10389:10389 \
-e LDAP_HOST={your ldap host} \
-e LDAP_PORT=10389 \
-e LDAP_BASE_DN=(basedn of your ldap) \
-e LDAP_PASSWORD={ldap bind password} \
allanselvan/openldap:latest
```

### With Persistent Data

```sh
docker run --name openldap -d -p 10389:10389 \
-e LDAP_HOST={your ldap host} \
-e LDAP_PORT=10389 \
-e LDAP_BASE_DN=(basedn of your ldap) \
-e LDAP_PASSWORD={ldap bind password} \
-v /local/path::/data/openldap \
allanselvan/openldap:latest
```