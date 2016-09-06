# vagrant-elk
A place where to learn how to standup the ELK stack on a Vagrant box. A subnet will be created: one VM the ELK stack, the other an app server of your choosing. If in need, a Python app can be found [here](https://github.com/emmanuellyautomated/nasanomics). The Vagrantfile will need to know the location of said app, so set an `ELK_APP_1` environment variable to the path of the repo.

### Usage
* Be sure you have this going on in your root directory:

    + |- Vagrantfile
    + |- provision.sh
    + |- confs/
    + |---- nginx_conf
    + |---- 02-beats-input.conf
    + |---- 10-syslog-filter.conf
    + |---- 30-elasticsearch-output.conf

* run `vagrant up` if both `ELK_APP_1` and `ELK_APP_1_PROVISION` are set
    - otherwise `ELK_APP_1=/path/to/repo ELK_APP_1_PROVISION=/path/to/script vagrant up`
* visit kibana at 192.168.0.10
* visit nasanomics (or your app) at 192.168.20

### Future Plans
* configure Filebeat on app server to communicate with Logstash
* bash provisioning done in provision.sh will be migrated to ansible

---

NOTE: nginx is password protected and the username and login are both `vagrant`. Change to something else if you'd like.
