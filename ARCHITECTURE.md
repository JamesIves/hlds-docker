# Architecture

This document describes the architecture of the hlds-docker project using diagrams to illustrate the build process, runtime behavior, CI/CD pipeline, and file system layout.

## High-Level Overview 🌍

The project has two primary user paths: end users pull pre-built images from Docker Hub or GitHub Container Registry, while developers clone the repository and build custom images locally. Both paths result in a running HLDS container. GitHub Actions workflows handle validation, beta publishing, and production releases across all 12 supported game variants.

```mermaid
graph TB
    subgraph Users
        A[End User] -->|docker pull / docker run| D[Pre-built Image]
        B[Developer] -->|docker compose build| E[Custom Image]
    end

    subgraph Registries
        D --- DH[Docker Hub<br>jives/hlds]
        D --- GH[GitHub Container Registry<br>ghcr.io/jamesives/hlds]
    end

    subgraph GitHub Actions
        CI[validate.yml] -->|Tests all 12 variants| V{Pass?}
        V -->|Yes| BETA[beta.yml]
        BETA -->|Push -beta tags| DH
        BETA -->|Push -beta tags| GH
        PROD[publish.yml] -->|Manual dispatch| DH
        PROD -->|Manual dispatch| GH
        PROD -->|Create release| REL[GitHub Release]
    end

    E -->|Runs locally| SRV[HLDS Server]
    D -->|Runs locally| SRV
```

## Docker Build Process 📦

The `Dockerfile` in `container/` uses a single-stage build on Ubuntu. SteamCMD downloads the requested game files during the image build.

```mermaid
flowchart TD
    A[Ubuntu Base Image] --> B[Install i386 Dependencies]
    B --> C[Create steam User & Directories]
    C --> D[Copy hlds.txt SteamCMD Script]
    D --> E[Substitute GAME and FLAG<br>variables into hlds.txt]
    E --> F[Download & Extract SteamCMD]
    F --> G[Run SteamCMD]
    G --> H["app_set_config 90 mod $GAME"]
    H --> I["app_update 90 $FLAG validate<br>(runs 3x for reliability)"]
    I --> J[Patch steam_appid.txt = 70]
    J --> K[Copy entrypoint.sh]
    K --> L[Copy Default Configs<br>into $GAME directory]
    L --> M[Copy Mods into<br>HLDS root]
    M --> N[Set Entrypoint]

    style A fill:#2d5aa0,color:#fff
    style N fill:#2d8a4e,color:#fff
```

## Container Runtime Flow ▶️

When the container starts, `entrypoint.sh` runs before the HLDS server binary. It first checks whether a `+map` argument was provided (warning the user if not, as the server won't be joinable without one). It then syncs any user-provided mods and config files from their temporary volume mount locations into the correct HLDS directories using `rsync`. Finally, it prints a branded startup banner and launches `hlds_run`.

```mermaid
flowchart TD
    START([Container Starts]) --> CHECK{"+map" in args?}
    CHECK -->|No| WARN[Print Warning:<br>Server may not be joinable]
    CHECK -->|Yes| MODS
    WARN --> MODS

    MODS{"/temp/mods<br>exists?"} -->|Yes| SYNC_MODS["rsync /temp/mods/*<br>→ /opt/steam/hlds/"]
    MODS -->|No| CFG
    SYNC_MODS --> CFG

    CFG{"/temp/config<br>exists?"} -->|Yes| SYNC_CFG["rsync /temp/config/*<br>→ /opt/steam/hlds/$GAME/"]
    CFG -->|No| BANNER
    SYNC_CFG --> BANNER

    BANNER[Print Startup Banner<br>Image · Version · Game] --> LAUNCH

    LAUNCH["Launch hlds_run<br>-game $GAME + args"]

    style START fill:#2d5aa0,color:#fff
    style LAUNCH fill:#2d8a4e,color:#fff
    style WARN fill:#c9a227,color:#000
```

## Volume Mapping Architecture 💾

Users provide custom configurations and mods by placing files in `./config/` and `./mods/` on the host. These directories are volume-mounted into temporary locations inside the container (`/temp/config` and `/temp/mods`). On startup, the entrypoint script uses `rsync` to copy them into the correct HLDS directories — configs go into the game-specific folder (`/opt/steam/hlds/$GAME/`) and mods go into the HLDS root (`/opt/steam/hlds/`). This two-step approach ensures files are synced with correct ownership and directory structure, even when overwriting existing files from the base image.

```mermaid
flowchart LR
    subgraph Host
        HC["./config/"]
        HM["./mods/"]
    end

    subgraph Container - Temp
        TC["/temp/config/"]
        TM["/temp/mods/"]
    end

    subgraph Container - HLDS
        GD["/opt/steam/hlds/$GAME/"]
        HR["/opt/steam/hlds/"]
    end

    HC -->|"Volume Mount"| TC
    HM -->|"Volume Mount"| TM
    TC -->|"rsync by entrypoint.sh"| GD
    TM -->|"rsync by entrypoint.sh"| HR
```

### Config Sync Example

```
Host: ./config/                    Container: /opt/steam/hlds/cstrike/
├── mapcycle.txt          ──→      ├── mapcycle.txt
├── motd.txt              ──→      ├── motd.txt
├── maps/                          ├── maps/
│   └── crazytank.bsp     ──→     │   └── crazytank.bsp
└── addons/                        └── addons/
    └── amxmodx/           ──→         └── amxmodx/
```

### Mods Sync Example

```
Host: ./mods/                      Container: /opt/steam/hlds/
├── decay/                ──→      ├── decay/
│   ├── autoexec.cfg               │   ├── autoexec.cfg
│   ├── models/                    │   ├── models/
│   └── maps/                      │   └── maps/
└── svencoop/             ──→      └── svencoop/
```

## CI/CD Pipeline 🔄

The project uses a three-branch workflow. Feature branches trigger validation only. The `beta` branch triggers beta image publishing for testing. Production releases are triggered manually via `workflow_dispatch` on `publish.yml`, which bumps the version, builds and validates all 12 game variants, pushes to both registries, and creates a GitHub Release.

### Branch Strategy

```mermaid
gitGraph
    commit id: "initial"
    branch beta
    commit id: "feature-1"
    commit id: "feature-2"
    checkout main
    merge beta id: "release-v1.0.0" tag: "v1.0.0"
    checkout beta
    commit id: "fix-1"
    checkout main
    merge beta id: "release-v1.0.1" tag: "v1.0.1"
```

### Workflow Triggers

Each workflow is triggered by a specific event. Feature branch pushes run validation, beta branch pushes build and publish beta images, production releases are manually dispatched, pull requests get auto-labeled, and sponsor data is refreshed on a daily cron schedule.

```mermaid
flowchart TD
    subgraph Triggers
        PUSH_FEAT["Push to feature branch"]
        PUSH_BETA["Push to beta"]
        DISPATCH["Manual Dispatch"]
        PR["Pull Request"]
        CRON["Daily Cron"]
    end

    subgraph Workflows
        VAL["validate.yml<br>Build & Test"]
        BETA_WF["beta.yml<br>Build · Test · Publish Beta"]
        PUB["publish.yml<br>Version · Build · Test · Publish · Release"]
        LABEL["label.yml<br>Auto-label PR"]
        SPONSOR["sponsors.yml<br>Update Sponsors"]
    end

    PUSH_FEAT --> VAL
    PUSH_BETA --> BETA_WF
    DISPATCH --> PUB
    PR --> LABEL
    CRON --> SPONSOR

    style VAL fill:#e6a817,color:#000
    style BETA_WF fill:#c97a2d,color:#fff
    style PUB fill:#2d8a4e,color:#fff
    style LABEL fill:#6a5acd,color:#fff
    style SPONSOR fill:#e75480,color:#fff
```

### Production Publish Pipeline Detail

The production publish workflow is the most complex pipeline. It starts with a version bump, then builds each of the 12 game variants in parallel. For each variant, it strips the `-legacy` suffix from the game name (if present) and sets the appropriate SteamCMD beta flag. After building, it runs the container with test configurations to validate that volume mappings and game data are correct before pushing to both Docker Hub and GitHub Container Registry. Only after all builds pass does it create the Git tag and GitHub Release.

```mermaid
flowchart TD
    A[Manual Dispatch<br>with version input] --> B[Version Job]
    B --> C["Bump semver tag<br>(dry run)"]
    C --> D[Build Job - Matrix x12]

    D --> E[Login to Docker Hub + GHCR]
    E --> F[Set GAME env var<br>Strip -legacy suffix]
    F --> G{Legacy variant?}
    G -->|Yes| H["Set FLAG=-beta steam_legacy"]
    G -->|No| I[FLAG empty]
    H --> J
    I --> J[Build Image Locally]
    J --> K[Run Container with Test Config]
    K --> L{Validate Directory<br>Mappings}
    L -->|Pass| M[Push to Docker Hub<br>jives/hlds:game<br>jives/hlds:game-version]
    L -->|Fail| X[❌ Build Fails]
    M --> N[Push to GHCR<br>ghcr.io/jamesives/hlds:game<br>ghcr.io/jamesives/hlds:game-version]

    N --> O[Publish Job]
    O --> P[Bump Version + Create Git Tag]
    P --> Q[Create GitHub Release]

    style A fill:#2d5aa0,color:#fff
    style Q fill:#2d8a4e,color:#fff
    style X fill:#cc3333,color:#fff
```

## Validation Test Matrix ✅

The validation workflow runs against all 12 supported game variants in parallel (8 modern + 4 legacy). For each variant, it builds the Docker image, creates mock config and mod files, starts the container, then validates that mods sync to the HLDS root, configs sync to the game directory, and the correct game data is present. This ensures that volume mapping and the entrypoint sync logic work correctly for every supported game.

```mermaid
flowchart LR
    subgraph Modern
        V[valve]
        CS[cstrike]
        CZ[czero]
        DMC[dmc]
        GB[gearbox]
        RC[ricochet]
        DOD[dod]
        TFC[tfc]
    end

    subgraph Legacy
        VL[valve-legacy]
        CSL[cstrike-legacy]
        CZL[czero-legacy]
        TFCL[tfc-legacy]
    end

    subgraph Validation Steps
        S1["1. Build Image"]
        S2["2. Create Test Files"]
        S3["3. Run Container"]
        S4["4. Validate Mods Sync"]
        S5["5. Validate Config Sync"]
        S6["6. Validate Game Data"]
        S7["7. Cleanup"]
    end

    V & CS & CZ & DMC & GB & RC & DOD & TFC & VL & CSL & CZL & TFCL --> S1
    S1 --> S2 --> S3 --> S4 --> S5 --> S6 --> S7
```

## Container File System Layout 📂

Inside the container, all HLDS files live under `/opt/steam/hlds/`. The `valve/` directory is always present as the base game. The active game directory (`$GAME/`) contains the server configuration files (`server.cfg`, `autoexec.cfg`, `default.cfg`, `motd.txt`), maps, and any user-installed addons. The `steam_appid.txt` file is patched to contain `70` (Half-Life's app ID) to work around a known Steam client issue. Custom mods synced from `/temp/mods` appear as sibling directories alongside the built-in game folders.

```mermaid
flowchart TD
    ROOT["/opt/steam/"] --> HLDS["/opt/steam/hlds/"]
    ROOT --> STEAM["/opt/steam/.steam/"]
    STEAM --> SDK["sdk32 → linux32 symlink"]

    HLDS --> GAME_DIR["$GAME/<br>(e.g., cstrike/)"]
    HLDS --> VALVE["valve/<br>(always present)"]
    HLDS --> APPID["steam_appid.txt<br>(contains: 70)"]
    HLDS --> HLDS_RUN["hlds_run<br>(server binary)"]
    HLDS --> CMD["steamcmd.sh"]
    HLDS --> CUSTOM_MOD["custom mod dirs<br>(from /temp/mods)"]

    GAME_DIR --> CFG["server.cfg"]
    GAME_DIR --> AUTO["autoexec.cfg"]
    GAME_DIR --> DEF["default.cfg"]
    GAME_DIR --> MOTD["motd.txt"]
    GAME_DIR --> MAPS["maps/"]
    GAME_DIR --> PLUGINS["addons/<br>(user-installed)"]

    style ROOT fill:#2d5aa0,color:#fff
    style HLDS fill:#3a7cc3,color:#fff
    style GAME_DIR fill:#2d8a4e,color:#fff
```

## Network Architecture 🌐

The HLDS container exposes two ports. Port `27015` handles both game traffic (UDP) and RCON remote administration (TCP). Port `26900` (UDP) is used to communicate with the Steam master server, which registers the server in the public server browser so players can discover and join it.

```mermaid
flowchart LR
    PLAYER["Game Client<br>(Steam)"] -->|"UDP 27015"| SERVER["HLDS Container<br>Port 27015"]
    RCON["RCON Client"] -->|"TCP 27015"| SERVER
    SERVER -->|"UDP 26900"| MASTER["Steam Master<br>Server"]

    style PLAYER fill:#2d5aa0,color:#fff
    style SERVER fill:#2d8a4e,color:#fff
    style MASTER fill:#6a5acd,color:#fff
```

## SteamCMD Install Script ⚙️

The `hlds.txt` script drives SteamCMD during the Docker build. It logs in anonymously, configures app ID `90` (Half-Life) with the requested game mod, then runs `app_update` three times with the `validate` flag. The triple-run is intentional — SteamCMD downloads can be unreliable, and running the update multiple times ensures all files are fully downloaded even on flaky connections. `@ShutdownOnFailedCommand 0` prevents SteamCMD from aborting on transient errors.

```mermaid
sequenceDiagram
    participant SC as SteamCMD
    participant Steam as Steam Servers

    SC->>SC: @ShutdownOnFailedCommand 0
    SC->>SC: @NoPromptForPassword 1
    SC->>SC: force_install_dir ./hlds
    SC->>Steam: login anonymous
    SC->>SC: app_set_config 90 mod $GAME
    SC->>Steam: app_update 90 $FLAG validate (attempt 1)
    SC->>Steam: app_update 90 $FLAG validate (attempt 2)
    SC->>Steam: app_update 90 $FLAG validate (attempt 3)
    SC->>SC: quit

    Note over SC,Steam: 3 update attempts ensure<br>complete download even<br>on unreliable connections
```

## User Interaction Paths 🧑‍💻

There are two main ways to use the project. End users pull a pre-built image from a registry and run it directly with `docker run` or `docker compose up`. Developers who want to customize the build clone the repository, set the `GAME` environment variable, and build from the `container/` directory. Both paths converge at runtime, where users can optionally add custom configs and mods via volume mounts before connecting to the server through Steam.

```mermaid
flowchart TD
    USER([User]) --> CHOICE{How to run?}

    CHOICE -->|Pre-built Image| PULL["docker pull jives/hlds:cstrike"]
    CHOICE -->|Custom Build| CLONE["Clone repository"]

    PULL --> RUN_PRE["docker run / docker compose up<br>with volume mounts"]
    CLONE --> SET_GAME["export GAME=cstrike"]
    SET_GAME --> BUILD["cd container && docker compose build"]
    BUILD --> RUN_CUSTOM["docker compose up"]

    RUN_PRE --> CONFIG{Custom config?}
    RUN_CUSTOM --> CONFIG

    CONFIG -->|Yes| ADD_CFG["Add files to ./config/"]
    CONFIG -->|No| PLAY

    ADD_CFG --> MODS{Custom mods?}
    MODS -->|Yes| ADD_MODS["Add mod dirs to ./mods/"]
    MODS -->|No| PLAY

    ADD_MODS --> PLAY([Connect via Steam])

    style USER fill:#2d5aa0,color:#fff
    style PLAY fill:#2d8a4e,color:#fff
```
