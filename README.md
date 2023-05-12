# rust_docker_template
Rust Docker Template


# Build local
cargo build

# Run local
cargo run 


# Build container
docker build -t rust_docker_template .

# Run container
docker run --rm -p 3030:3030 --name server rust_docker_template


