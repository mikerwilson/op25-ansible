# What is this thing?
This repo is an Ansible playbook that will build [boatbod's OP25](https://github.com/boatbod/op25) implementation on a Raspberry Pi 3 B (or better) in a
headless/remote configuration.  If you're an advanced Ansible user there are other options for use, hoever this guide
will not cover those.

This guide will help you set up your control machine and build the pi resulting in an audio feed you can listen to with 
a web browser on your local network.  The control machine can be MacOS, Linux, or Windows.

**NOTE**: This playbook does NOT have security in mind.  Please do not expose your scanner to the internet directly without
considering the implications and taking steps to protect yourself and your network.


# Installation Instructions

## System Prep (MacOS)
The preferred method of installing prereqs on the control machine is with [homebrew](https://brew.sh/).  If you haven't
installed it already, go into a terminal window and copy/paste this in there:
```shell 
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
This guide has been tested on the following configuration:
- Raspberry Pi 3 B+ 
- 16GB SanDisk SSD 
- RTL2832U USB dongle from [RTL-SDR.COM](http://www.rtl-sdr.com) and compatible antenna 
- Raspberry Pi OS Lite (64-bit) Debian Bullseye (released Sept 22, 2022)
- MacOS control machine

### Before getting started
You'll need the following things:
- Raspberry PI 3 B+ (or better)
- RTL-SDR.COM USB dongle (RTL2832U is highly recommended) and compatible antenna 
- SD card (16gb or more, the faster the better)
- SD card reader on the control machine. 
- SSH key (whatever is already in ~/.ssh is fine)

### Environment Setup
**Install packages**
    ```shell
    brew update
    brew install git
    brew install raspberry-pi-imager
    brew install ansible
    ```

**Clone repo** - Find a directory you'd like to work from and run `git clone https://github.com/mikerwilson/op25-ansible.git`


### Image SD card
1. Insert the SD card into your control machine and open the Raspberry Pi Imager.
2. Click `Operating System` and select `Raspberry Pi OS Lite (64-bit)` (0.3gb) making sure whatever you select has no 
   desktop environment.
3. Click `Storage` and choose your sd card from the list.
4. Click `Settings` button (little gear icon) and make the following settings:
   - Hostname: `radio`.local (recommend using this name at least the first time around so the instructions match).
   - Check `Enable SSH`, and `Allow public-key authenitcation only`, and add your ssh public key.
   - Check `Set username and password`, Username: `pi` (don't change this), and Password: `<your secure password>`
   - Check `Configure wireless LAN`, SSID, Password, and your `Wireless LAN country`
   - (optional but recommended) Check `Set locale settings`, Time Zone, and keyboard layout.
5. Click `SAVE`, then `WRITE`

Once the card is done writing, pop it into your powered-off Raspberry Pi.  Connect your USB RTL-SDR dongle to the Pi,
then power it on.

### Build the Pi!
#### Find the pi
Give your Pi a few minutes to power on and connect to your wireless network.  Once it's up and ready for you, if you
ping `radio.local` you should get an IP response like this meaning it's ready to go:
```text
➜  ~ ping radio.local
PING radio.local (192.168.1.95): 56 data bytes
64 bytes from 192.168.1.95: icmp_seq=0 ttl=64 time=3.604 ms
64 bytes from 192.168.1.95: icmp_seq=1 ttl=64 time=3.395 ms
64 bytes from 192.168.1.95: icmp_seq=2 ttl=64 time=3.678 ms
64 bytes from 192.168.1.95: icmp_seq=3 ttl=64 time=4.860 ms
^C
--- radio.local ping statistics ---
4 packets transmitted, 4 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 3.395/3.884/4.860/0.573 ms
➜  ~
```
#### Create your Ansible inventory
```shell
cp hosts.local.yml-example hosts.local.yml
nano hosts.local.yml
```
Edit the contents of `hosts.local.yml` with what you'd like to name your scanner (`sysname`), control channel list, and 
center frequency.  You can find the frequencies on radioreference.com, but the defaults will at least let the scanner 
build and compile.  You can change them in this file and rerun the playbook and it will automatically reconfigure the 
scanner for you.

Example:
```yaml
---
scanner:
  hosts:
    radio.local:
  vars:
    sysname: EBRCS OP25 Scanner
    control_channel_list: 774.45625,773.90625,774.18125,774.73125
    center_frequency: 774.45625
```

You can find the full list of variables in the playbook (including usernames and passwords) in the following file:
`roles/scanner/defaults/main.yml`

#### Run ansible!
This can take 30+ minutes to complete the first time.  Run this command from the repo root directory.
```shell
ansible-playbook -i hosts.local.yml site.yml
```

The Pi will reboot at the end of the initial run.  The output should look something like this:
```text
[...truncated...]
RUNNING HANDLER [scanner : enable and restart op25-rx] *****************************************************************
changed: [radio.local]

RUNNING HANDLER [scanner : enable and restart liquidsoap] **************************************************************
changed: [radio.local]

RUNNING HANDLER [scanner : reboot machine] *****************************************************************************
changed: [radio.local]

PLAY RECAP *************************************************************************************************************
radio.local                : ok=39   changed=33   unreachable=0    failed=0    skipped=0    rescued=0    ignored=1
```

The Ansible playbook is idempotent so it can be run at any time to confirm the configuration, update packages, etc.  It 
will only make the changes required to correct the configuration, including recompiling as needed if something updates.
This means that subsequent runs are usually quick and are a good way to confirm your overall configuration is correct.

# Use your scanner!
Assuming you haven't overridden any of the default variables, the following links should work for you:
- OP25 control interface: http://radio.local:8080
- Web-based radio audio feed: http://radio.local:8000/op25
- Web-based radio feed stats/control: http://radio.local (admin user: admin, pass: hackme)

## Customize it!
### Option A: Ansible
If you change the control channel list or center frequency you can rerun the ansible command to apply those changes.
This runs in about 30 seconds and is pretty easy.

### Option B: SSH
Radio configs can be found under /etc/op25 and can be edited with any text editor.  You'll need to run 
`sudo service op25-rx restart` to apply any changes.  Check out op25 and boatbod/op25's docs for details about how these
work.  You'll likely want to do this to set your whitelist.csv and blacklist.csv contents.
