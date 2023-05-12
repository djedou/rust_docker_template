################
##### Builder (check latest version on rust and put it here)
FROM rust:1.69.0-slim as builder

WORKDIR /usr/src

# Create blank project
RUN USER=root cargo new rust_docker_template

# We want dependencies cached, so copy those first.
COPY Cargo.toml Cargo.lock /usr/src/rust_docker_template/

# Set the working directory
WORKDIR /usr/src/rust_docker_template

## Install target platform (Cross-Compilation) --> Needed for Alpine
RUN rustup target add x86_64-unknown-linux-musl

# This is a dummy build to get the dependencies cached.
RUN cargo build --target x86_64-unknown-linux-musl --release

# Now copy in the rest of the sources
COPY src /usr/src/rust_docker_template/src/

## Touch main.rs to prevent cached release build
RUN touch /usr/src/rust_docker_template/src/main.rs

# This is the actual application build.
RUN cargo build --target x86_64-unknown-linux-musl --release

################
##### Runtime
FROM alpine:latest AS runtime 

# Copy application binary from builder image
COPY --from=builder /usr/src/rust_docker_template/target/x86_64-unknown-linux-musl/release/rust_docker_template /usr/local/bin

EXPOSE 3030

# Run the application
CMD ["/usr/local/bin/rust_docker_template"]