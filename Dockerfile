# build environment
FROM node:13.12.0-alpine as build
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY package.json ./


RUN npm install 
COPY . ./
RUN npm run build

# production environment
FROM nginx:stable-alpine
COPY --from=build /app/build /usr/share/nginx/html
# new
COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf

FROM ubuntu:20.04

RUN apt update -y \
    && apt-get install software-properties-common -y \
    && apt-add-repository -r ppa:certbot/certbot \
    && apt-get update -y \
    && apt-get install python3-certbot-nginx -y \
    && apt-get clean



STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]