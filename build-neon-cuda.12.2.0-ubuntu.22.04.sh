set -e
set -x
cd neon\:cuda.12.2.0.ubuntu.22.04
docker build -t neon:cuda.12.2.0.ubuntu.22.04 .
