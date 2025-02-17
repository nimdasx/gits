# Vue on Docker Mac / Linux

init dan install
```
docker run -it --rm -v "$PWD":/app -w /app node:lts-alpine npm init vue@latest
cd <your-project-name>
docker run -it --rm -v "$PWD":/app -w /app node:lts-alpine npm install
```
run
```
docker run -p 5173:5173 -it --rm -v "$PWD":/app -w /app node:lts-alpine npm run dev -- --host
```
atau edit vite.config.js, tambahkan
```
server: {
    host: true
  }
```
run
```
docker run -p 5173:5173 -it --rm -v "$PWD":/app -w /app node:lts-alpine npm run dev
```

ulang ulang terus
```
docker run -it --rm -v "$PWD":/app -w /app -p 5173:5173 node:lts-alpine npm run dev -- --host
docker run -it --rm -v "$PWD":/app -w /app              node:lts-alpine npm run build
docker run -it --rm -v "$PWD":/app -w /app -p 4173:4173 node:lts-alpine npm run preview -- --host
```
