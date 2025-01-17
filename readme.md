### Building

The netX flasher sources can be built with the [MBS docker image](https://github.com/muhkuh-sys/mbs-docker-images) from Muhkuh.

To start the MBS container and attach to it:
```
docker compose up -d
docker compose exec mbs bash
```

When starting the container for the first time:
```shell
# Install required tools 
apt update && apt install -y python3-pip && python3 -m pip install gitpython

# Disable git safe directory
git config --system --add safe.directory '*'
```

To build the netX flasher sources:
```shell
# Build all targets
python3 mbs/mbs

# Build for a specific target
python3 mbs/mbs --netx=NETX90
```