FROM node:20-alpine

RUN apk add --no-cache python3 make g++ git

WORKDIR /myStrapi

COPY package.json package-lock.json* ./

RUN npm install

COPY . .

EXPOSE 1337

CMD ["npm", "run", "develop"]
