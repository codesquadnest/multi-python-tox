# Multi-Python Tox Testing with Docker and uv

This repository demonstrates how to set up a Docker-based testing environment that installs multiple Python versions
(3.7–3.14) using [uv](https://github.com/astral-sh/uv) and runs tests on all these versions via
[tox](https://tox.readthedocs.io/) with the [tox-uv](https://github.com/astral-sh/uv) plugin.

## Project Overview

The project includes:

- A **Dockerfile** that creates a lightweight container based on `python:3.13-slim-bookworm`:
  - Installs `uv` to manage multiple Python versions.
  - Installs Python versions 3.7 to 3.14 in `/home/ciuser/.local/bin`.
  - Sets up a non-root user (`ciuser`) and configures the environment.
  - Installs `tox` and the `tox-uv` plugin for multi-Python testing.
- A **tox.ini** file that configures tox to run tests in environments for all the specified Python versions.
- A simple test file, **test_dummy.py**, which contains dummy tests to verify that the environment works.
- A **test_build.sh** script located in the tests folder to build the Docker image and run the container, mounting
the tests directory so that tox can run all test environments.

## Project Structure

```plaintext
project-root/
├── Dockerfile
└── tests/
    ├── tox.ini
    ├── test_dummy.py
    └── test_build.sh
```

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) must be installed and running.
- (Optional) A Unix-like shell environment (Linux, macOS, or Git Bash on Windows) to run the provided shell script.

## How It Works

1. **Dockerfile**:  
   The Dockerfile in the root directory sets up the Python environment by:
   - Copying the necessary `uv` binaries.
   - Creating a non-root user.
   - Installing multiple Python versions into `/home/ciuser/.local/bin`.
   - Installing `tox` with the `tox-uv` plugin.
   - Setting the default command to run `tox`.

2. **tox.ini**:  
   Located in the `tests/` directory, this file defines the environments for Python 3.7 through 3.14:

    ```ini
    [tox]
    envlist = py37,py38,py39,py310,py311,py312,py313,py314

    [testenv]
    deps = pytest
    commands = pytest
    ```

   This instructs tox to create a testing environment for each Python version and run `pytest`.

3. **Test File**:  
   A simple test in `tests/test_dummy.py` verifies that tests run:

    ```python
   def test_always_passes():
       assert True
   ```

4. **test_build.sh**:  
   This script builds the Docker image from the project root and runs the container with the tests mounted. It overrides
   the default tox configuration to use the one in the tests folder.

## Usage

### Building and Testing with Docker

1. **Clone the Repository**

   ```bash
   git clone <repository_url>
   cd project-root
   ```

2. **Make the Test Script Executable**
   Navigate to the `tests/` directory and run:

   ```bash
   cd tests
   chmod +x test_build.sh
   ```

3. **Run the Build and Test Script**
   From the `tests/` directory, execute:

   ```bash
   ./test_build.sh
   ```

   This will:
   - Change the directory to the project root.
   - Build the Docker image (tagged as `multi-python-tox`).
   - Run the container, mounting the `tests/` directory so that `tox` can detect and run tests for all the installed Python versions.

### Executing tox with pre-built Docker image

The release of the Docker image is available on GitHub Container Registry. You can pull the image and run the container with the following command:

```bash
docker run -it -v $PWD:/work --workdir /work ghcr.io/codesquadnest/multi-python-tox:main
```

If everything is set up correctly, you should see output from tox running tests in environments for Python 3.7 through 3.14.

## Contributing

We welcome contributions via issues or pull requests. Your suggestions, improvements, and bug fixes are highly appreciated.

## License

This project is licensed under the [MIT License](LICENSE).
