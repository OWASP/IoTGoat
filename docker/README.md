# IoTGoat QEMU Docker Setup Guide

This guide provides the option to run a virtualized IoTGoat environment using Docker and Docker Compose, allowing access via SSH, HTTP, and HTTPS. This guide will walk you through the setup process, the prerequisites, and how to build and run the Docker container.

## Prerequisites

To run this environment, ensure you have the following installed:

1. [Docker](https://www.docker.com/get-started)
   - Docker is used to create and run the containerized environment.
2. [Docker Compose](https://docs.docker.com/compose/install/)
   - Docker Compose simplifies the orchestration of multi-container Docker applications.
3. [QEMU](https://www.qemu.org/download/)
   - The `qemu-img` tool from QEMU is used to convert the IoTGoat image to the qcow2 format.
4. [IoTGoat - Latest Release](https://github.com/OWASP/IoTGoat/releases/latest)
   - The IoTGoat image is used to run the IoT environment.
   - The image is required to be in qcow2 format.

## Files Overview

- **Dockerfile.qemu**: This Dockerfile defines the base Ubuntu image and installs QEMU, SSH, and other necessary components.
- **docker-compose.yml**: This file defines the services and networking configurations for Docker Compose.
- **IoTGoat-x86.qcow2**: This is the manually added IoTGoat image (in qcow2 format) that QEMU will use to run the IoT environment.

## Setup Instructions

### 1. Clone the Repository

First, clone the repository to your local machine:

```bash
git clone https://github.com/OWASP/IoTGoat
cd IoTGoat
```

### 2. Fetch and Convert the IoTGoat Image

Download the latest IoTGoat image (IoTGoat-x86.img.gz) from the [releases page](https://github.com/OWASP/IoTGoat/releases/latest) and convert it to qcow2 format using the following command:

Unzip the file and convert it to qcow2 format using the following command:

```bash
gunzip IoTGoat-x86.img.gz
qemu-img convert -f raw -O qcow2 IoTGoat-x86.img IoTGoat-x86.qcow2
```

The image should be added to the `docker` directory.

### 3. Project Structure

Ensure your project directory looks like this:

```
IoTGoat/
│
├── docker/                       # Docker files and configs
│   ├── Dockerfile.qemu           # QEMU environment setup
│   ├── docker-compose.yml        # Docker Compose config
│   ├── IoTGoat-x86.qcow2         # QCOW image (add manually)
│   └── README.md                 # Docker and QCOW setup instructions
│...
```

### 4. Build and Run the Docker Container

To build and run the IoTGoat QEMU environment, use the following command:

```bash
docker compose up --build
```

This will:

- Build the QEMU image using the Dockerfile.qemu.
- Run the container and expose the following services:
  - **SSH** on port `2222`
  - **HTTP** on port `8080`
  - **HTTPS/Web interface** on port `4443`

### 5. Accessing the Services

After running `docker-compose up --build`, the following services will be available:

#### SSH Access

To connect to the IoTGoat environment via SSH, run:

```bash
ssh -o HostKeyAlgorithms=+ssh-rsa iotgoatuser@localhost -p 2222
```

You will be prompted for a password when connecting via SSH. As part of the IoTGoat task, your objective is to find this password.

#### HTTP Access

To access the IoTGoat web environment via HTTP, open a browser and navigate to:

```bash
http://localhost:8080
```

#### Web Interface (HTTPS)

To access the IoTGoat web interface via HTTPS, navigate to:

```bash
https://localhost:4443
```

### 6. Stopping the Container

To stop the running container, press `CTRL+C` in the terminal running Docker Compose, or use:

```bash
docker-compose down
```

This will stop and remove the container.

### 7. Persistent Data

The IoTGoat environment is configured to persist its data inside a Docker volume. The volume is mapped to the `/opt` directory inside the container, so any data generated will not be lost when the container is stopped.

To remove the volume and reset the environment, use:

```bash
docker-compose down -v
```

### 8. Rebuilding the Container

If you make changes to the `Dockerfile.qemu` or the project files, rebuild the container using:

```bash
docker-compose up --build
```

---

### Notes

- Verify SSH configuration and exposed ports to mitigate potential security risks and usage of default credentials.
- Ensure Docker and Docker Compose are correctly installed and running on your system.
- If you encounter any issues with ports, ensure that the ports specified in `docker-compose.yml` (2222, 8080, 4443) are available on your host system.
- For a clean environment reset, use `docker-compose down -v` to remove volumes and the container.
- QEMU is required on the host machine solely for using the qemu-img tool to convert the IoTGoat image to qcow2 format. It is not needed for any other tasks on the host.
- Ensure proper permissions for the `IoTGoat-x86.qcow2` file. Especially if Docker cannot access it. Run the following command to fix it:

```bash
chmod 644 /path/to/IoTGoat-x86.qcow2
```

---
