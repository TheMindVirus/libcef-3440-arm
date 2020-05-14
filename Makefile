CODENAME:="3440-arm"

CEF_URL:="https://github.com/chromiumembedded/cef.git"
CEF_CHECKOUT:="origin/3440"

DEPOT_TOOLS_URL:="https://chromium.googlesource.com/chromium/tools/depot_tools.git"
DEPOT_TOOLS_CHECKOUT:="origin/chrome/3865"
CHROMIUM_CHECKOUT:="origin/6e80b8a"
#MAY NEED GYP AND GN DEFINES HERE FOR ARM
#removed gclient sync from after the chromium checkout
AUTOMATE_OPTIONS:="--arm-build --minimal-distrib"

all:
	@echo "Building libcef-$(shell echo $(CODENAME))..."
	@mkdir -p "libcef-$(shell echo $(CODENAME))"
	@make -s _version
	@make -s _depot_tools
	@make -s _chromium
	@make -s _cef
	@rm -rf "./libcef-$(shell echo $(CODENAME))/chromium/src/out"
	@python2 "./libcef-$(shell echo $(CODENAME))/cef/tools/automate/automate-git.py" --download-dir="$$PWD/libcef-$(CODENAME)" --no-update $(shell echo $(AUTOMATE_OPTIONS))

_version:
	@echo "Generating version information..."
	VERSION_FORMAT=CODENAME=\"$(CODENAME)\""\n"; \
	VERSION_FORMAT=$$VERSION_FORMAT"\n"CEF_URL=\"$(CEF_URL)\"; \
	VERSION_FORMAT=$$VERSION_FORMAT"\n"CEF_CHECKOUT=\"$(CEF_CHECKOUT)\""\n"; \
	VERSION_FORMAT=$$VERSION_FORMAT"\n"DEPOT_TOOLS_URL=\"$(DEPOT_TOOLS_URL)\"; \
	VERSION_FORMAT=$$VERSION_FORMAT"\n"DEPOT_TOOLS_CHECKOUT=\"$(DEPOT_TOOLS_CHECKOUT)\"; \
	VERSION_FORMAT=$$VERSION_FORMAT"\n"CHROMIUM_CHECKOUT=\"$(CHROMIUM_CHECKOUT)\""\n"; \
	VERSION_FORMAT=$$VERSION_FORMAT"\n"AUTOMATE_OPTIONS=\"$(AUTOMATE_OPTIONS)\"; \
	echo "$$VERSION_FORMAT" > "./libcef-$(shell echo $(CODENAME))/VERSION"; \

_depot_tools:
	@echo "Fetching depot_tools..."
	if [ -d "./libcef-$(shell echo $(CODENAME))/depot_tools" ]; then \
		echo "Repository depot_tools already exists."; \
	else \
		git clone $(DEPOT_TOOLS_URL) "./libcef-$(shell echo $(CODENAME))/depot_tools"; \
		echo "Checking out depot_tools $(DEPOT_TOOLS_CHECKOUT)..."; \
		cd "./libcef-$(CODENAME)/depot_tools"; \
		git -c advice.detachedHead=false checkout $(DEPOT_TOOLS_CHECKOUT); \
	fi \

_chromium:
	@echo "Fetching chromium..."
	if [ -d "./libcef-$(shell echo $(CODENAME))/chromium" ]; then \
		echo "Repository chromium already exists."; \
	else \
		PATH=$$PATH:$$PWD/libcef-$(shell echo $(CODENAME))/depot_tools; \
		mkdir -p "./libcef-$(shell echo $(CODENAME))/chromium"; \
		cd "./libcef-$(shell echo $(CODENAME))/chromium"; \
		fetch --nohooks chromium; \
		echo "Checking out chromium $(CHROMIUM_CHECKOUT)..."; \
		cd "./src"; \
		git -c advice.detachedHead=false checkout $(CHROMIUM_CHECKOUT); \
		gclient runhooks; \
	fi \

_cef:
	@echo "Fetching cef..."
	if [ -d "./libcef-$(shell echo $(CODENAME))/cef" ]; \
	then \
		echo "Repository cef already exists."; \
	else \
		git clone $(CEF_URL) "./libcef-$(shell echo $(CODENAME))/cef"; \
		echo "Checking out cef $(CEF_CHECKOUT)..."; \
		cd "./libcef-$(shell echo $(CODENAME))/cef"; \
		git -c advice.detachedHead=false checkout $(CEF_CHECKOUT); \
	fi \

clean:
	@echo "Removing libcef-$(shell echo $(CODENAME))..."
	rm -rf "./libcef-$(shell echo $(CODENAME))"
	rm -rf "./depot_tools"

_clean_depot_tools:
	@echo "Removing depot_tools..."
	rm -rf "./libcef-$(shell echo $(CODENAME))/depot_tools"
	rm -rf "./depot_tools"

_clean_chromium:
	@echo "Removing chromium..."
	rm -rf "./libcef-$(shell echo $(CODENAME))/chromium"

_clean_cef:
	@echo "Removing cef..."
	rm -rf "./libcef-$(shell echo $(CODENAME))/cef"
