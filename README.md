## Docker Golang image container example

[Dockerfile reference](https://docs.docker.com/engine/reference/builder/)

### Construir imagen

```bash
 docker build -t docker-go -f Dockerfile .
```

### Crear contenedor

```bash
mkdir -p ~/docker/volumes/go-docker
docker run -d -p 2777:1919 -v ~/docker/volumes/go-docker:/app/logs docker-go
```

### local logs

```bash
tail -f ~/docker/volumes/go-docker/trace.log
```

### ejecutar myApp

```bash
curl http://localhost:2777
```

based in tutorial: [Building Docker Containers for Go Applications](https://www.callicoder.com/docker-golang-image-container-example/)
