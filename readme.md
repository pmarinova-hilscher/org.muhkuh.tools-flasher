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

# Fix git error ‘detected dubious ownership in repository’
git config --global --add safe.directory $PWD
```

To build the netX flasher sources run:
```shell
python3 mbs/mbs
```