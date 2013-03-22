BOXGRINDER_ARCH := $(shell arch)
BOXGRINDER_BUILD_ROOT = build/appliances/$(BOXGRINDER_ARCH)

UBUNTU_PRECISE_ROOT = $(BOXGRINDER_BUILD_ROOT)/ubuntu/precise/ubuntu-precise/1.0/vmware-plugin

.PHONY: ubuntu-precise
ubuntu-precise: $(UBUNTU_PRECISE_ROOT)/ubuntu-precise.ova

$(UBUNTU_PRECISE_ROOT)/ubuntu-precise.ova: $(UBUNTU_PRECISE_ROOT)/ubuntu-precise.vmx
	cd $(dir $@); ovftool $(notdir $<) $(notdir $@)

$(UBUNTU_PRECISE_ROOT)/ubuntu-precise.vmx: ubuntu-precise.appl
	boxgrinder-build -l boxgrinder-ubuntu-plugin $< -p vmware --platform-config type:personal,thin_disk:true

.PHONY: clean
clean:
	rm -rf build/



