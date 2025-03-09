#!/bin/bash
set -e

# Change directory to the project root where the Dockerfile is located.
cd "$(dirname "$0")/.."

# Build the Docker image using the Dockerfile in the project root.
docker build -t multi-python-tox .

# Run the container:
# - Mount the tests directory into /home/ciuser/tests in the container.
# - Override the CMD to run tox with the configuration file located in tests/tox.ini.
docker run --rm \
  -v "$(pwd)/tests:/home/ciuser/tests" \
  -e TOX_WORK_DIR=/home/ciuser/.tox \
  multi-python-tox tox -c tests/tox.ini
