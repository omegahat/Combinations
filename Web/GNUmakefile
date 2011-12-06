PKG_NAME=$(shell grep Package ../DESCRIPTION | sed -e 's/.*: //')

index.html: index.html.in configure
	./configure

include $(OMEGA_HOME)/R/Config/RPackageWebConfig

indexInstall:
	scp index.html $(TARGET_DIR)

configure: configure.in
	autoconf
	chmod +x $@