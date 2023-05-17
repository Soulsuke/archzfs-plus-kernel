# archzfs-plus-kernel
A script to maintain a local repository for kernels needed by archzfs and their
relative ZFS packages.  

**NOTE:** ZFS packages are mirrored because updates may force the kernel to
update while leaving the headers behind, breaking any eventual dkms. This
ensures it won't happen.  



### Usage
Install dependencies via `bundle install`.  
Simply running `archzfs-plus-kernel-update-repo` will download all the
configured kernel package into the `repo` subfolder.  
Should it be necessary to force an update ignoring the
`seconds_between_updates` setting, use the `--force` (or `-f`) parameter.  
For other flags run `archzfs-plus-kernel-update-repo --help`.  



### Configuration

##### Setup which kernel versions you want to be in your repo
Kernel flavors to download can be set within `config.yml`.  
You can copy `config.yml.sample` to `config.yml` as a starting configuration.  

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

