# nodejs on docker

di windows cmd
```
docker run -it --rm -v "%cd%":/app -w /app node:lts-alpine blablbalbla.js
```

di windows powershell
```
docker run -it --rm -v $pwd\:/usr/src/app -w /usr/src/app node:lts-alpine blablbalbla.js
```

di linux dan di mac
```
docker run -it --rm -v "$PWD":/app -w /app node:lts-alpine blablbalbla.js
```