# openerp 6.1 ubuntu 14.04
```
catatan  
jangan install python-werkzeug dari apt, error gak iso print pdf

apt-get install python-dateutil python-feedparser python-gdata python-ldap \
    python-libxslt1 python-lxml python-mako python-openid python-psycopg2 \
    python-pybabel python-pychart python-pydot python-pyparsing python-reportlab \
    python-simplejson python-tz python-vatnumber python-vobject python-webdav \
    python-xlwt python-yaml python-zsi

sudo vim /etc/postgresql/9.3/main/postgresql.conf
listen_addresses = '*'

sudo -u postgres psql postgres
\password postgres
q
\q

sudo vim /etc/postgresql/9.3/main/pg_hba.conf
host    all     all     0.0.0.0/0       password

sudo -i -u postgres
psql
CREATE ROLE openerp WITH LOGIN SUPERUSER PASSWORD 'medis';
\q

https://files.pythonhosted.org/packages/a1/1c/02e6127ec997c08266b03d7fd340ba7675dafe0e28886a569664fd019e56/Werkzeug-0.8.3.tar.gz
sudo pip install Werkzeug-0.8.3.tar.gz

https://github.com/wkhtmltopdf/obsolete-downloads/releases/download/linux/wkhtmltopdf-0.11.0_rc1-static-amd64.tar.bz2
extract dan taruh binary wkhtml to pdf ke /usr/local/bin 
```