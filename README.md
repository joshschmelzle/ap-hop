# ap-hop

SSH into a Central managed Aruba AP by client MAC. That's it.

![tape](tape.gif)

## Install

```bash
curl -o ~/.local/bin/ap-hop https://raw.githubusercontent.com/joshschmelzle/ap-hop/main/ap-hop
chmod +x ~/.local/bin/ap-hop
```

## Setup

```bash
ap-hop config
```

## Use

```bash
ap-hop de:ad:be:ef:de:ad
```

## Requirements

`curl`, `jq`, `sshpass`. You probably have two of these.

## License

BSD-3-Clause
