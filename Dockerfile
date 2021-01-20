FROM golang:latest as builder

WORKDIR /build
COPY . .
RUN go get -v -t -d ./...
RUN CGO_ENABLED=0 go build -o prometheus-net-discovery .

FROM alpine:latest
WORKDIR /opt/net-discovery
RUN mkdir /opt/net-discovery/configs
ENV CONFIG_FILESDPATH=/opt/net-discovery/configs
ENV CONFIG_NETWORKS=192.168.1.1/24

COPY --from=builder /build/prometheus-net-discovery .

CMD ["./prometheus-net-discovery"]