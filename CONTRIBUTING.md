# Contributing

Thank you for your interest in contributing to this project! Please review the general process and scope before starting a contribution.

## Scope

The core requirements for this project are:

1. Start a Half-Life dedicated server easily with Docker.
2. Have the ability for users to install custom plugins, maps and server configurations by providing a way to manipulate the server directory. Commonly used server plugins are intentionally not provided as a default, these are considered a user concern as the server should only include what is provided out of the box from Valve. Consider creating your own [custom image](https://github.com/JamesIves/hlds-docker/blob/beta/container/README.md) or fork for these scenarios.
3. Have the ability to run servers for custom mods by providing a way to manipulate the server startup and directory.
4. Only support legal usage of Steam and Valve's titles. **It will not, and never will, support the ability to circumvent any licensing or other restrictions Valve imposes.** The project maintainers will report any shady behaviour directly to [Valve](https://www.valvesoftware.com/en/) and/or [GitHub](https://github.com).

## Process

1. File an issue on the [Issue board](https://github.com/JamesIves/hlds-docker/issues), or create a discussion on the [Discussions board](https://github.com/JamesIves/hlds-docker/discussions).
2. Once discussed and agreed upon, clone the project and base your changes on the `beta` branch.
3. Make your changes.
4. Validate your changes; at the very least, please build the image and start a server. [You can learn how to build the images using the guide located here](container/README.md).
5. Submit a pull request to the `beta` branch.
6. Once reviewed, your changes will be made available on DockerHub via the `-beta` tag, for example `jives/hlds:cstrike-beta`.
7. After some more tests, changes will be merged into the `main` branch where the production images will be published. This step will be performed by a project maintainer.
