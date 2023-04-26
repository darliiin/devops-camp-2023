# start nginx container
docker run --rm --publish 8080:80 --name nginx -d nginx
# start tcpdump
docker run --rm -it --net=container:nginx alpine sh -c "apk add -q tcpdump && tcpdump -i any tcp port 80"

