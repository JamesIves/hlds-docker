# GitHub Copilot Instructions for hlds-docker

## Repository Purpose

This repository provides a Dockerized solution for running the Half-Life Dedicated Server (HLDS), supporting various classic GoldSrc games and mods such as Counter-Strike, Team Fortress Classic, Day of Defeat, and more. The project aims to simplify the setup and management of HLDS servers using Docker, with support for custom configurations, plugins, and mods.

## Key Features

- Pre-built Docker images for multiple GoldSrc games and mods.
- Support for custom server configurations and plugins.
- Ability to build and run custom mods.
- Compatibility with both modern and legacy versions of HLDS.
- Automated workflows for building, validating, and publishing Docker images.

## Technologies Used

- **Docker**: For containerizing the HLDS server.
- **Docker Compose**: For managing multi-container setups and simplifying server configuration.
- **GitHub Actions**: For CI/CD workflows, including building, validating, and publishing Docker images.
- **Shell Scripting**: For managing server startup and configuration (`entrypoint.sh`).
- **SteamCMD**: For downloading and managing HLDS game files.

## Helpful Context for Copilot

1. **Dockerfile**:

   - The `Dockerfile` is located in the `container` directory and is used to build the HLDS server image.
   - It supports build arguments such as `GAME`, `FLAG`, `VERSION`, and `IMAGE` to customize the build process.

2. **Entrypoint Script**:

   - The `entrypoint.sh` script is responsible for initializing the server, copying configuration files, and starting the HLDS server with the specified game and arguments.

3. **Configuration Files**:
   - The `config` directory contains server configuration files (e.g., `server.cfg`, `motd.txt`) that are copied into the container during the build process or mounted as volumes at runtime.
     d d
4. **Mods Directory**:

   - The `mods` directory is used for custom mods and plugins. Files in this directory are copied into the container or mounted as volumes.

5. **Workflows**:

   - The repository includes GitHub Actions workflows for:
     - Validating Docker images (`validate.yml`).
     - Publishing beta images (`beta.yml`).
     - Publishing production images (`publish.yml`).

6. **Supported Games**:

   - The repository supports multiple GoldSrc games, including:
     - `valve` (Half-Life Deathmatch)
     - `cstrike` (Counter-Strike)
     - `czero` (Counter-Strike Condition Zero)
     - `dod` (Day of Defeat)
     - `tfc` (Team Fortress Classic)
     - `dmc` (Deathmatch Classic)
     - `gearbox` (Half-Life Opposing Force)
     - `ricochet` (Ricochet)

7. **Volume Mapping**:

   - The `docker-compose.yml` and `docker run` commands use volume mappings to allow users to provide custom configurations and mods at runtime.

8. **Validation**:
   - The `validate.yml` workflow ensures that the Docker image is functional by running the container and validating directory mappings and game data.

## Suggestions for Copilot

- Assist with writing or modifying Dockerfiles, shell scripts, and GitHub Actions workflows.
- Provide suggestions for managing environment variables and build arguments.
- Help with debugging volume mappings and container runtime issues.
- Generate documentation for supported games, configuration options, and usage examples.
- Suggest improvements to CI/CD workflows, such as caching or parallelizing steps.

## Additional Notes

- The repository adheres to best practices for Docker image creation, including multi-stage builds and minimal base images.
- Contributions should align with the project's scope, focusing on ease of use, extensibility, and legal compliance with Valve's licensing terms. d
