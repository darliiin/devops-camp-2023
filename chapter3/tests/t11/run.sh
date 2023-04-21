cd /tmp

mkcert localhost changelog

sudo chown -R nginx:nginx /tmp/localhost+1.pem
sudo chown -R nginx:nginx /tmp/localhost+1-key.pem

sudo kill $(sudo lsof -t -i :443)

cd -
sudo /usr/sbin/php-fpm8.1 --fpm-config "$(pwd)/php-fpm.conf" --php-ini "$(pwd)/php.ini" > /dev/null &
sudo nginx -c "$(pwd)/nginx.conf"

curl https://localhost/reports/fast
curl https://localhost/reports/slow
