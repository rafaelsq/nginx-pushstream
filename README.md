# Nginx &amp; PushStream

```
$ docker build --tag=rafaelsq/nginx-pushstream:latest .
$ docker run --rm -p 80:80 -v ./nginx.conf:/etc/nginx/nginx.conf rafaelsq/nginx-pushstream:latest
```
