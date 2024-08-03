FROM nginx:alpine

WORKDIR /usr/share/nginx/html/

COPY . .

EXPOSE 80
# CMD service nginx start
CMD ["nginx", "-g", "daemon off;"]
