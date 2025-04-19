# This Dockerfile sets up a Python environment with multiple versions (3.7-3.13) using `uv` under a non-root user.
# It installs the necessary Python versions, sets the PATH, and installs `tox` for testing workflows.

FROM python:3.13-slim-bookworm
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Define user variable and Python versions variable
ARG CI_USER=ciuser
ARG PYTHON_VERSIONS="3.7 3.8 3.9 3.10 3.11 3.12 3.13 3.14"

# Create a non-root user and configure the environment
RUN useradd -m -s /bin/bash $CI_USER

# Switch to non-root user
USER $CI_USER
WORKDIR /home/$CI_USER

# Install multiple Python versions using `uv` as the non-root user
RUN uv python install $PYTHON_VERSIONS --preview --install-dir /home/$CI_USER/.local/bin

# Install tox-uv
RUN uv tool install tox --with tox-uv

# Set PATH
ENV PATH="/home/$CI_USER/.local/bin:${PATH}"

CMD [ "tox" ]
