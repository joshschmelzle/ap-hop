# ap-hop

SSH into a New Central managed Aruba AP by client MAC or AP BSSID. That's it.

![tape](tape2.gif)

## Install

```bash
curl -fsSL https://wifi.lol/ap-hop | bash
```

The installer will:
- Check for required dependencies (`curl`, `jq`, `sshpass`)
- Download `ap-hop` to `~/.local/bin/`
- Add `~/.local/bin` to your PATH if needed
- Tell you what to do next

Yes, we're curling bash scripts from the Internet. This is the way.

## Setup

Generate API client for the service (cluster) where your APs are: https://common.cloud.hpe.com/manage-account/api

You need the client ID and secret.

```bash
ap-hop
```

On first run without a profile, a config wizard will ask you questions. It only asks once.

```bash
ap-hop config
```

## Use

Your own Wi-Fi MAC:

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

## Dependencies

`curl`, `jq`, `sshpass`. You probably have two of these.

Should work on Linux and macOS.

 - brew install sshpass jq

Windows users: Good news! WSL2 lets you pretend you're on a real operating system.

## License

BSD-3-Clause

Free as in "free to use." Issues are free to be filed. Responses are not guaranteed but occasionally provided.
