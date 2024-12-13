FROM alpine AS build

RUN apk add --no-cache build-base automake autoconf git
RUN git clone --branch branchHTTPservMulti https://github.com/Pharisaeuss/DevOps-lab2.git /repo

WORKDIR /repo
COPY . .

RUN aclocal
RUN automake --add-missing
RUN autoreconf --install
RUN ./configure
RUN make

FROM alpine AS final-stage 
COPY --from=build /repo/suite /usr/local/bin/suite

ENTRYPOINT ["/usr/local/bin/suite"]
