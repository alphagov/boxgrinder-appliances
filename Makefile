TOPDIR := $(dir $(lastword $(MAKEFILE_LIST)))

provider ?= vmware

provider_args_vmware ?= --platform-config type:personal,thin_disk:true
#provider_args_virtualbox ?= ....

# If not set pull the default provider args for the current provider type
provider_args ?= ${provider_args_${provider}}

ubuntu-precise: plugins := -l boxgrinder-ubuntu-plugin
ubuntu-precise-boxgrinder: plugins := -l boxgrinder-ubuntu-plugin

# Export all variables to submake
export
# Don't delete intermediate files - we want the .mf file etc.
.SECONDARY:

%: %.appl
	$(eval build_dir=$(shell $(TOPDIR)bin/boxgrinder-introspect $@.appl --build-dir)/$(provider)-plugin)
	$(eval appl_name=$(shell $(TOPDIR)bin/boxgrinder-introspect $@.appl --name))
	$(eval appl_file:=$<)
	$(MAKE) $(build_dir)/$(appl_name).ova


$(build_dir)/$(appl_name).vmx: $(appl_file)
	boxgrinder-build $(plugins) $< -p $(provider) $(provider_args)


# Need to call it %.ovf then move it so the references in the file are right
# And we need to CD into the dir so that the paths are relative to the dir its in.
%-pristine.ovf %-disk1.vmdk: %.vmx
	cd $(@D) && \
	ovftool $(notdir $(basename $<)).vmx $(notdir $(basename $<)).ovf
	mv $(basename $<).ovf $(basename $<)-pristine.ovf

%.ovf: %-pristine.ovf
	$(TOPDIR)bin/ovf-customizer $(shell $(TOPDIR)bin/boxgrinder-introspect $(appl_file) --os-type) < $< > $@

# Checksum file.
%.mf: %.ovf %-disk1.vmdk
	cd $(@D) && openssl sha1 $(notdir $^) > $(notdir $@)

%.ova: %.ovf %.mf %-disk1.vmdk
	ovftool $< $@

.PHONY: clean
clean:
	rm -rf build/
