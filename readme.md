# Packer Templates

**This was originally a forked repo from mwrock/packer-templates. Credit goes to Matt Wrock.**
I started to make a lot of changes and decided it would be better to put this into its own repo instead of a fork.

These packer templates will produce a vanilla windows vagrant box that are up to date with patches.  During the build process it will install Chocolatey and Boxstarter as part of the initial build provisioning process, however these will be removed at the end of the packer provision process to keep a vanilla windows image.

## Prerequisites

You need the following to run the template:

1. [Packer](https://packer.io/docs/installation.html) installed with a minimum version of 0.8.6.

## Invoking the template
Invoke `packer` to run the template like this:
```
packer build -force 2012r2-parallels.json
```

## Troubleshooting Boxstarter package run
[Boxstarter](http://boxstarter.org) is used as the means of provisioning except on Nano Server. Due to the fact that provisioning takes place in the builder and not a provisioner, it can be difficult to gain visibility into why things go wrong from the same console where `packer` is run.

Boxstarter will log all package activity output to `$env:LocalAppData\Boxstarter\boxstarter.log` on the guest.
