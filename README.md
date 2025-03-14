
# docker-electrumx

> Run an Electrum server with one command

An easily configurable Docker image for running an Electrum server.

## Usage

```
docker run \
  --add-host=host.docker.internal:host-gateway \
  -v /home/<your username>/electrumx:/data \
  -e DAEMON_URL=http://<kevacoind username>:<kevacoind password>@<kevacoid ip>:<rpc port> \
  -e DB_ENGINE=rocksdb \
  -p 50001:50001 \
  kevacoin-project/electrumx
```

If there's an SSL certificate/key (`electrumx.crt`/`electrumx.key`) in the `/data` volume it'll be used. If not, one will be generated for you.

You can view all ElectrumX environment variables here: https://github.com/spesmilo/electrumx/blob/master/docs/environment.rst

### Compact History

If you encounter error like this:

```
struct.error: 'H' format requires 0 <= number <= 65535
```
It is time to compact the history of the database by running the `electrumx_compact_history` script:

```
docker run \
  --add-host=host.docker.internal:host-gateway \
  -v /home/<your username>/electrumx:/data \
  -e DAEMON_URL=http://<kevacoind username>:<kevacoind password>@<kevacoid ip>:<rpc port> \
  -e DB_ENGINE=rocksdb \
  -p 50001:50001 \
  kevacoin-project/electrumx \
  /electrumx/electrumx_compact_history
```

### TCP Port

By default only the SSL port is exposed. You can expose the unencrypted TCP port with `-p 50001:50001`, although this is strongly discouraged.

### WebSocket Port

You can expose the WebSocket port with `-p 50004:50004`.

### RPC Port

To access RPC from your host machine, you'll also need to expose port 8000. You probably only want this available to localhost: `-p 127.0.0.1:8000:8000`.

If you're only accessing RPC from within the container, there's no need to expose the RPC port.

## License

MIT
