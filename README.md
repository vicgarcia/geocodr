This repository is a collection of scripts and configurations for creating a
Vagrant VM and installing the appropriate software to build an HTTP geocoding
service.


Assuming you're using OSX and have Vagrant installed :

```
# clone the repository
git clone https://github.com/vicgarcia/geocodr.git
```

```
# create the virtual machine (takes about 3 hours)
cd geocodr
vagrant up
```

```
# once the install completes, test with the cli tool
./geocodr.sh 905 w carmen, chicago il 60640
```

```
# you can ssh into the virtual machine and explore
vagrant ssh
cd /opt/geocodr
```

Ensure you have a good network connection, as downloading the dataset to
install uses alot of bandwidth.  Don't do this over a mobile network.

The installation will take two to three hours.  Make sure you're not using
battery power on a laptop while building this virtual machine.

By default, the dataset for only the state of Illinois is installed,
this can be changed in provision.sh near line 38.

The provision.sh script will :

 - install postgres, postgis, and related extensions and tools

 - load TIGER dataset for a state (or array of states) as specified

 - install nginx/php, configure api app for geocoder via http service


vic garcia | vicg4rcia.com
