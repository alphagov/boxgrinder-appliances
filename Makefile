BOXGRINDER_ARCH := $(shell arch)
BOXGRINDER_BUILD_ROOT = build/appliances/$(BOXGRINDER_ARCH)

UBUNTU_PRECISE_ROOT = $(BOXGRINDER_BUILD_ROOT)/ubuntu/precise/ubuntu-precise/1.0/vmware-plugin

.PHONY: ubuntu-precise
ubuntu-precise: $(UBUNTU_PRECISE_ROOT)/ubuntu-precise.ova

$(UBUNTU_PRECISE_ROOT)/ubuntu-precise.ova: $(UBUNTU_PRECISE_ROOT)/ubuntu-precise.vmx
	cd $(dir $@); ovftool $(notdir $<) $(notdir $@)

$(UBUNTU_PRECISE_ROOT)/ubuntu-precise.vmx: ubuntu-precise.appl
	boxgrinder-build -l boxgrinder-ubuntu-plugin $< -p vmware --platform-config type:personal,thin_disk:true

UBUNTU_PRECISE_BOXGRINDER_ROOT = $(BOXGRINDER_BUILD_ROOT)/ubuntu/precise/ubuntu-precise-boxgrinder/1.0/vmware-plugin

.PHONY: ubuntu-precise-boxgrinder
ubuntu-precise-boxgrinder: $(UBUNTU_PRECISE_BOXGRINDER_ROOT)/ubuntu-precise-boxgrinder.ova

$(UBUNTU_PRECISE_BOXGRINDER_ROOT)/ubuntu-precise-boxgrinder.ova: $(UBUNTU_PRECISE_BOXGRINDER_ROOT)/ubuntu-precise-boxgrinder.vmx
	cd $(dir $@); ovftool $(notdir $<) $(notdir $@)

$(UBUNTU_PRECISE_BOXGRINDER_ROOT)/ubuntu-precise-boxgrinder.vmx: ubuntu-precise-boxgrinder.appl ubuntu-precise-boxgrinder-postinstall.sh
	boxgrinder-build -l boxgrinder-ubuntu-plugin $< -p vmware --platform-config type:personal,thin_disk:true

.PHONY: clean
clean:
	rm -rf build/



