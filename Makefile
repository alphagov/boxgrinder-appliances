PATH := $(shell pwd)/bin:$(PATH)

UBUNTU_PRECISE_ROOT = $(shell ./bin/boxgrinder-dir ubuntu-precise.appl)/vmware-plugin

.PHONY: ubuntu-precise
ubuntu-precise: $(UBUNTU_PRECISE_ROOT)/ubuntu-precise.ova

$(UBUNTU_PRECISE_ROOT)/ubuntu-precise.ova: $(UBUNTU_PRECISE_ROOT)/ubuntu-precise.vmx
	cd $(dir $@) && \
	  ovftool ubuntu-precise.vmx ubuntu-precise.ovf && \
	  mv ubuntu-precise.ovf ubuntu-precise.ovf-pristine && \
	  ovf-customizer <ubuntu-precise.ovf-pristine >ubuntu-precise.ovf && \
	  openssl sha1 ubuntu-precise.ovf ubuntu-precise-disk1.vmdk > ubuntu-precise.mf && \
	  ubuntu-precise.ovf ubuntu-precise.ova

$(UBUNTU_PRECISE_ROOT)/ubuntu-precise.vmx: ubuntu-precise.appl
	boxgrinder-build -l boxgrinder-ubuntu-plugin $< -p vmware --platform-config type:personal,thin_disk:true

UBUNTU_PRECISE_BOXGRINDER_ROOT = $(shell ./bin/boxgrinder-dir ubuntu-precise-boxgrinder.appl)/vmware-plugin

.PHONY: ubuntu-precise-boxgrinder
ubuntu-precise-boxgrinder: $(UBUNTU_PRECISE_BOXGRINDER_ROOT)/ubuntu-precise-boxgrinder.ova

$(UBUNTU_PRECISE_BOXGRINDER_ROOT)/ubuntu-precise-boxgrinder.ova: $(UBUNTU_PRECISE_BOXGRINDER_ROOT)/ubuntu-precise-boxgrinder.vmx
	cd $(dir $@); ovftool $(notdir $<) $(notdir $@)

$(UBUNTU_PRECISE_BOXGRINDER_ROOT)/ubuntu-precise-boxgrinder.vmx: ubuntu-precise-boxgrinder.appl
	boxgrinder-build -l boxgrinder-ubuntu-plugin $< -p vmware --platform-config type:personal,thin_disk:true

.PHONY: clean
clean:
	rm -rf build/
