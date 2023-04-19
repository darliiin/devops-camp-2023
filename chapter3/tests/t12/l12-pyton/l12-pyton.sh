cd /tmp
mkcert localhost changelog
cp ~/Документы/l12-pyton/50x.html .

cd -
uwsgi --ini app.ini
sudo nginx -c "$(pwd)/nginx.conf"
