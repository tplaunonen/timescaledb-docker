TimescaleDB Docker container for ARM architecture. Intended to be run on Raspberry Pi.

## What is TimescaleDB?

TimescaleDB is an open-source database designed to make SQL scalable
for time-series data. For more information, see
the [Timescale website](https://www.timescale.com).

## How to use this image

This image is based on the
official
[TimescaleDB docker image](https://github.com/timescale/timescaledb-docker) so
the documentation for that image also applies here, including the
environment variables one can set, extensibility, etc. 

### Starting a TimescaleDB instance

```
$ docker run -d --name some-timescaledb -p 5432:5432 timescale/timescaledb
```

Then connect with an app or the `psql` client:

```
$ docker run -it --net=host --rm timescale/timescaledb psql -h localhost -U postgres
```

You can also connect your app via port `5432` on the host machine.

Note that you can also set an environmental variable, `TIMESCALEDB_TELEMETRY`, to set the level of [telemetry](https://docs.timescale.com/using-timescaledb/telemetry) in the Timescale docker instance. For example, to turn off telemetry, run:

```
$ docker run -d --name some-timescaledb -p 5432:5432 --env TIMESCALEDB_TELEMETRY=off timescale/timescaledb
```

The default telemetry level is `basic`.
