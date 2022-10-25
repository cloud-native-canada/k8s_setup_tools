# Readme

## Building the Docker images of the GoWebApp

```bash
git clone git@github.com:Cloud-Architects-Program/ycit019_2022.git
cd ycit019_2022/Mod8_assignment/gowebapp
```

Change the Dockerfile to:

```yaml
FROM golang:1.16.4 as build

ENV GO111MODULE=auto
ENV GOPATH=/go

COPY /code $GOPATH/src/gowebapp/
WORKDIR $GOPATH/src/gowebapp/
RUN go get && CGO_ENABLED=0 go build -o /go/bin/gowebapp

FROM gcr.io/distroless/static

USER nonroot:nonroot
LABEL maintainer "student@mcgill.ca"
LABEL gowebapp "v1"
ENV DB_PASSWORD=rootpasswd

EXPOSE 80
COPY --from=build --chown=nonroot:nonroot /go/bin/gowebapp /gowebapp
COPY --from=build --chown=nonroot:nonroot /go/src/gowebapp/config /config
COPY --from=build --chown=nonroot:nonroot /go/src/gowebapp/template /template
COPY --from=build --chown=nonroot:nonroot /go/src/gowebapp/static /static
ENTRYPOINT ["/gowebapp"]
```

Update config in `code/config/config.json` and change port to 9000:

```json
	"Server": {
		"Hostname": "",
		"UseHTTP": true,
		"UseHTTPS": false,
		"HTTPPort": 9000,
		"HTTPSPort": 9443,
		"CertFile": "tls/server.crt",
		"KeyFile": "tls/server.key"
	},
```

then build / tag / push

```bash
podman build -t cloud-native-canada/k8s_setup_tools:app .
podman tag localhost/cloud-native-canada/k8s_setup_tools:app ghcr.io/cloud-native-canada/k8s_setup_tools:app
docker push ghcr.io/cloud-native-canada/k8s_setup_tools:app
```