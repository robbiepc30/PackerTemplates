# Packer Templates

*** This was originally a forked repo from mwrock/packer-templates. Credit goes to Matt Wrock. ***
I started to make a lot of changes and decided it would be better to put this into its own repo instead of a fork.

A Packer template that simplifies the creation of minimally-sized Windows Vagrant boxes.


## Prerequisites

You need the following to run the template:

1. [Packer](https://packer.io/docs/installation.html) installed with a minimum version of 0.8.6.
2. [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

## Invoking the template
Invoke `packer` to run the template like this:
```
packer build -force 2012r2-parallels.json
```

## Troubleshooting Boxstarter package run
[Boxstarter](http://boxstarter.org) is used as the means of provisioning except on Nano Server. Due to the fact that provisioning takes place in the builder and not a provisioner, it can be difficult to gain visibility into why things go wrong from the same console where `packer` is run.

Boxstarter will log all package activity output to `$env:LocalAppData\Boxstarter\boxstarter.log` on the guest.
