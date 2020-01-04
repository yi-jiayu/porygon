FROM rustlang/rust:nightly-slim as build

RUN apt-get update && apt-get install -y libpq-dev

WORKDIR /usr/src/porygon

COPY . .

RUN cargo build --release

FROM debian:buster-slim

RUN apt-get update && apt-get install -y libpq5

COPY --from=build /usr/src/porygon/target/release/porygon /usr/local/bin/

ENTRYPOINT ["porygon"]