# dvdbackupx

*by Don Mahurin, 2009-01-09*

### Description:

dvdbackupx is a version of dvdbackup modified to find unused blocks and
seek past them, potentially avoiding bad sectors. Unused blocks are
found by using the libdvdnav vm (called libdvdvm here, but not really an
independent library ) to simulate the execution of pre,post and cell
commands to follow each title in the title set.

The intended use of this is to avoid potentially bad sectors that are
perhaps created by disc manufacturers attempting to prevent consumer
fair use or otherwise subverting the “limited time” copyright condition
of the US constitution.

### Usage:

dvdbackup -r u -M -i /dev/dvd -o /outdir

### Build

```
git clone https://github.com/dmahurin/libdvdnav.git
cd libdvdnav
autoreconf --install
make
sudo make install
cd ..
```

```
git clone https://github.com/dmahurin/dvdbackup.git
cd dvdbackup
dpkg-buildpackage -us -uc -b
```



