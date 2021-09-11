# zfs-kernels
A script to maintain a local repository for kernels needed by archzfs.  



### Requirements
The following ruby gems are required:  

* ruby-progressbar  
* ruby-xz  

They can be installed with `gem install ruby-progressbar ruby-xz`.  



### Usage
Simply running `zfs-kernels-update-repo` will download all the configured
kernel packages within the `repo` subfolder.  
There's an hardcoded value of 3600 seconds between actual refreshes, to
avoid putting useless strain on archzfs' repo. However, should it be necessary,
it can be bypassed using the parameter `--force` or `-f`.  
If multiple versions of the same kernel are specified as a dependency, a prompt
will be shown to choose which one to add to the repository. This can be avoided
using the `--pick-newest` or `-n` parameter, which will pick by default the
newest version available.  



### Configuration

##### Setup which kernel versions you want to be in your repo
Kernel flavors to download can be set within `kernels.conf`.  
You can `kernels.conf.sample` to `kernels.conf` for a starting configuration.  
Every line matching `^linux` is considered an entry, while the rest is
ignored.  

##### Setup a custom hostname
Within `/etc/hosts` add the desired hostname:  
```
127.0.0.1 ... zfs-kernels.local
```

##### Add the repository
Add the repository within `/etc/pacman.conf` BEFORE the `[core]` repository:  
```
[zfs-kernels]
Server = http://zfs-kernels.local/$repo
```

##### Configure a webserver
You can setup the webserver of your choice to serve the packages.  
A sample configuration for nginx would be:  
```
server
{
  server_name zfs-kernels.local;
  root /path/to/zfs-kernels/repo;
  access_log /dev/null;
  error_log /dev/null;
}
```

