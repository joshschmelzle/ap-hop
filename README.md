# ap-hop

SSH into a New Central managed Aruba AP by client MAC or AP BSSID. That's it.

![tape](tape2.gif)

## Install

```bash
curl -o ~/.local/bin/ap-hop https://raw.githubusercontent.com/joshschmelzle/ap-hop/main/ap-hop
chmod +x ~/.local/bin/ap-hop
```

Yes, we're curling bash scripts from the internet. This is the way.

## Setup

Generate API client: https://common.cloud.hpe.com/manage-account/api

```bash
ap-hop config
```

The config wizard will ask you questions. Answer them honestly. It only asks once.

## Use

Use your own Wi-Fi MAC:

```bash
ap-hop
```

The script will figure out which AP you're yelling at.

Magic? No. AI? No. `iw` or `ifconfig` parsing? Yes.

Use a specific target Wi-Fi MAC or AP BSSID:

```bash
ap-hop de:ad:be:ef:de:ad
```

Works with colons, dashes, or no separators at all. We're not picky.

Show usage:

```bash
ap-hop --help
```

For when you forget everything.

## Requirements

`curl`, `jq`, `sshpass`. You probably have two of these.

Should work on Linux and macOS.

Windows users: Good news! WSL2 lets you pretend you're on a real operating system.

## License

BSD-3-Clause

Free as in "free to use." Issues are free to be filed. Responses are not guaranteed but occasionally provided.
