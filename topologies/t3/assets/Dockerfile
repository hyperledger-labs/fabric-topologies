# This image is a microservice in golang for the Degree chaincode
FROM golang:1.17-alpine AS build

RUN mkdir /tmp/hl-fabric
COPY ./chaincode/assets-transfer-basic/chaincode-go /tmp/hl-fabric
WORKDIR /tmp/hl-fabric

# Build application
RUN go build -o assettransfer -v .

# Production ready image
# Pass the binary to the prod image
FROM alpine:3.11 as prod

COPY --from=build /tmp/hl-fabric/assettransfer /app/assettransfer

USER 1000

WORKDIR /app
CMD ./assettransfer