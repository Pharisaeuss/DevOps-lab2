FROM alpine

WORKDIR /home/SUITE
COPY ./suite .
RUN apk add libstdc++
RUN apk add libc6-compat

ENTRYPOINT ["./suite"]
