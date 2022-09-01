# archzfs-plus-kernel
A script to maintain a local repository for kernels needed by archzfs and their
relative ZFS packages.  

**NOTE:** ZFS packages are mirrored because updates may force the kernel to
update while leaving the headers behind, breaking any eventual dkms. This
ensures it won't happen.  



### Requirements
The following ruby gems are required:  

* ruby-progressbar  
* ruby-xz  

They can be installed with `gem install ruby-progressbar ruby-xz`.  



### Usage
Simply running `archzfs-plus-kernel-update-repo` will download all the
configured kernel package into the `repo` subfolder.  
There's an hardcoded value of 3600 seconds between actual refreshes, to
avoid putting useless strain on archzfs' repo. However, should it be necessary,
it can be bypassed using the parameter `--force` or `-f`.  
For other flags. run `archzfs-plus-kernel-update-repo --help`.  



### Configuration

##### Setup which kernel versions you want to be in your repo
Kernel flavors to download can be set within `kernels.conf`.  
You can `kernels.conf.sample` to `kernels.conf` for a starting configuration.  
Every line matching `^linux` is considered an entry, while the rest is
ignored.  

##### Setup a custom hostname
Within `/etc/hosts` add the desired hostname:  
```
127.0.0.1 ... archzfs-plus-kernel.local
```

##### Add the repository
Add the repository within `/etc/pacman.conf` BEFORE the `[core]` repository:  
```
[archzfs-plus-kernel]
Server = http://archzfs-plus-kernel.local/$repo
```

##### Configure a webserver
You can setup the webserver of your choice to serve the packages.  
A sample configuration for nginx would be:  
```
server
{
  server_name archzfs-plus-kernel.local;
  root /path/to/archzfs-plus-kernel/repo;
  access_log /dev/null;
  error_log /dev/null;
}
```

