ARG VERSION=3.9

FROM alpine:$VERSION as build

WORKDIR /app

COPY . /app

RUN apk update && apk add cabal ghc musl-dev wget zlib-dev
RUN cabal update && cabal install --only-dependencies
RUN ghc --make -o application /app/src/Main.hs

FROM alpine:$VERSION

WORKDIR /app

COPY --from=build /app/application /app

RUN apk add libffi gmp

ENV DATABASE_FILE quiver.db

EXPOSE 80

CMD ./application
