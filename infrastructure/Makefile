PROJECTS := $(dir $(wildcard */Makefile))

.PHONY: all
upgrade-and-apply: $(PROJECTS)

.PHONY: $(PROJECTS)
$(PROJECTS):
	@echo --- Running $@
	@make -C $@ upgrade
	@make -C $@
