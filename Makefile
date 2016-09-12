PARENT_DIR := $(shell dirname $(PWD))
ELK_APP_1 := $(PARENT_DIR)/nasanomics
ELK_APP_1_PROVISION := $(PARENT_DIR)/nasanomics/vps/vagrant/provision.sh


all: 
	@echo "ELK_APP_1 -->\t\t" ${ELK_APP_1}
	@echo "ELK_APP_1_PROVISION -->\t" ${ELK_APP_1_PROVISION}

prepare: 
	$(shell git clone git@github.com:emmanuellyautomated/nasanomics.git $(PARENT_DIR)/nasanomics)
	$(eval export ELK_APP_1=$(ELK_APP_1))
	$(eval export ELK_APP_1_PROVISION=$(ELK_APP_1_PROVISION))

clean:
	vagrant destroy -f
	- rm -rf $(ELK_APP_1)


.PHONY: prepare
