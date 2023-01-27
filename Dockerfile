# builder stage : 다음 FROM 전까지 빌드 파일을 만드는 stage
# stage 이름을 builder라고 명시

FROM node:alpine as builder

WORKDIR '/usr/src/app'

COPY package.json ./

RUN npm install

COPY ./ ./

RUN npm run build

# run stage : builder stage에서 받은 빌드 파일로 운영 가능하게끔 구성하는 stage
# 여기서는 웹 브라우저의 요청에 따라 정적 파일을 제공할 수 있게, Nginx에 파일을 제공한다.

FROM nginx
EXPOSE 80
COPY --from=builder /usr/src/app/build /usr/share/nginx/html

# --from=builder : 가져올 파일의 출처, 즉 가져올 파일이 있는 스테이지를 명시
# /usr/src/app/build : npm run build 시 이 디렉토리에 빌드 파일이 저장된다.
# /usr/share/nginx/html : 빌드 파일을 Nginx의 디렉토리로 복사한다.
