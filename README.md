# vagrant-elk
A place where I learn to standup the ELK stack on a Vagrant box

### Usage
* Be sure you have this going on in your repo:

    + |- Vagrantfile
    + |- provision.sh
    + |- nginx_conf

* run `vagrant up`
* visit `http://localhost:8080` to access kibana
---

NOTE: nginx is password protected and the username and login are both `vagrant`. Change to something else if you'd like.
