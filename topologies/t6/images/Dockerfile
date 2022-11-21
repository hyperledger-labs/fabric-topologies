FROM hyperledger/fabric-ca:1.5
RUN apk upgrade --update-cache --available && \
    apk add openssl && \
    rm -rf /var/cache/apk/*