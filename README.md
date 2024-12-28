# The Sons of the Forest Dedicated Server Image
Dedicated server for the Sons of the Forest. The server software is only available on Windows and therefore running with Wine in this image. 

## Configuration

The configuration of the server can be done in the [`dedicateddedicatedserver.cfg`](config/dedicatedserver.cfg) file. The settings can be overwritten by copying a custom version to `/data/userdata/dedicatedserver.cfg` or changing the config file and rebuilding the image.


### Sample compose.yml:

```yaml
services:
  sons-of-the-forest-server:
    image: ghcr.io/edemirkan/sons-of-the-forest-docker:latest
    container_name: sons_of_the_forest_server
    cap_add:
      - sys_nice
    volumes:
      - "/data/sons-of-the-forest/userdata:/forest/userdata"
      - "./config/dedicatedserver.cfg:/forest/userdata/dedicatedserver.cfg"
      - "./config/ownerswhitelist.txt:/forest/userdata/ownerswhitelist.txt"
    ports:
      - 0.0.0.0:8766:8766/udp
      - 0.0.0.0:27016:27016/udp
      - 0.0.0.0:9700:9700/udp
    restart: unless-stopped
```