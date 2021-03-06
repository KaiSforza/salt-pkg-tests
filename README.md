# salt-pkg-tests

Salt states to automate salt package installation testing.

These states are used in conjunction with [salt-ssh](http://docs.saltstack.com/en/latest/topics/ssh/) to install
packages on a machine of any salt-supported operating system. By default, these states with install all
operating-system-specific packages located in the default methods as noted in the
[Salt Installation Documentation](http://docs.saltstack.com/en/latest/topics/installation/index.html).

This document assumes that there are no Salt packages installed on the target system.

## Set Up

The easiest way to perform package installation testing, currently, is to use
[Salt Cloud](http://docs.saltstack.com/en/latest/topics/cloud/) to spin up a VM that does not have Salt installed
yet using `--no-deploy`:
```
salt-cloud -p <cloud-profile-name> <minion-name> --no-deploy
```

Once the instance is up, add the VM, and other necessary details, to the salt-ssh roster:
```
cat >> /etc/salt/roster
<minion-name>
  host: <minion-hostname-or-IP>
  user: <user-name>
  passwd: <password>
```

Double check that the configuration is correct and simultaneously ignore the host keys:
```
salt-ssh -i <minion-name> test.ping
```

## State Execution

To execute these states by their default installation, do the following:
```
salt-ssh <minion-name> state.sls test_install
```

By passing in some pillar values via the command line, you can install packages from different repositories, depending
on the operating system. For example, by default, CentOS 6 and CentOS 7 both install from EPEL. However, there are
times that packages from EPEL-Testing or the Salt COPR repository need to be tested. You can install salt packages from
a different repository by adding a different value to the `pkg_repo` pillar key:
```
salt-ssh <minion-name> state.sls test_install pillar='{"pkg_repo": "copr"}'
```

By changing the value for the `testing` pillar key, you can install epel-testing for CentOS/RHEL 6 & 7, as well as
Fedora VMs like so:
```
salt-ssh <minion-name> state.sls test_install pillar='{"testing": "True"}'
```

### Supported Configurations

**Arch**:
- Default: Installs salt-zmq packages from Pacman stable
  - `salt-ssh <minion-name> state.sls test_install`
- Community-Testing:
  - `salt-ssh <minion-name> state.sls test_install pillar='{"testing": "True"}'`
- salt-raet vs salt-zmq packages:
  - By default, the salt-zmq packages are installed. However, you can change the installation to salt-raet by specifying
  the "transport" option via pillar on the CLI:
    - `salt-ssh <minion-name> state.sls test_install pillar='{"transport": "raet"}'`
  - You can also install the salt-raet packages from community-testing:
    - `salt-ssh <minion-name> state.sls test_install pillar='{"transport": "raet", "testing": "True"}'`

**RHEL/CentOS 5, 6, 7 and Fedora**:

The default is to installs packages from EPEL.  This can be overridden by
pillar data, `pillar={"pkg_repo": "copr"}` or `pillar={"pkg_repo": "koji"}`.
EPEL-Testing can be specified by pillar data as well, `pillar={"testing":
"True"}`.

RHEL/CentOS 5 requires an additional setup step to be executed before salt-ssh
can run:
```console
# echo yes | ssh <public-IP> "yum -y install epel-release && yum -y makecache && yum -y install python26"
```

```console
# salt-ssh -i <ssh-minion> test.ping
# salt-ssh <ssh-minion> state.sls test_install pillar='{"salt_version": "2015.5.2", "pkg_version": "3"}'
# salt-ssh <ssh-minion> state.sls test_setup pillar='{"salt_version": "2015.5.2", "pkg_version": "3"}'
# salt-ssh <ssh-minion> state.sls test_run pillar='{"salt_version": "2015.5.2", "pkg_version": "3"}'
# echo y | salt-cloud -d <ssh-minion>
```

- Packages that install:
  - salt-master
  - salt-minion
  - salt-api
  - salt-cloud
  - salt-ssh
  - salt-syndic

**Debian**:
- Default: Installs packages from debian.saltstack.com: Coming Soon!
- Debian's Salt Testing Repo:
  - `salt-ssh <minion-name> state.sls test_install pillar='{"testing": "True"}'`
- Packages that install:
  - salt-master
  - salt-minion
  - salt-api
  - salt-cloud
  - salt-ssh
  - salt-syndic

**Ubuntu**:
- Default: Installs packages from Salt's ppa:
  - `salt-ssh <minion-name> state.sls test_install`
- Testing:
  - `salt-ssh <minion-name> state.sls test_install pillar='{"testing": "True"}'`
- Packages that install:
  - salt-master
  - salt-minion
  - salt-api
  - salt-cloud
  - salt-ssh
  - salt-syndic

**openSuse**:
- Default: Installs packages from opensuse build service repo devel:languages:python:
  - `salt-ssh <minion-name> state.sls test_install`
- Tumbleweed:
  - `salt-ssh <minion-name> state.sls test_install pillar='{"codename": "Tumbleweed"}'`
- Packages that install:
  - salt-master
  - salt-minion
  - salt-api
  - salt-cloud
  - salt-ssh
  - salt-syndic
