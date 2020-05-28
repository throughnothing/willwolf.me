SRC=src
STACK=stack
SITE=site
SITE_BRANCH=master
DEVELOP_BRANCH=dev
OUTPUT_DIR=output

build: compile
	cd ${SRC} && ${STACK} exec ${SITE} build

check: rebuild
	cd ${SRC} && ${STACK} exec ${SITE} check

clean: compile
	cd ${SRC} && ${STACK} exec ${SITE} clean

rebuild: compile
	cd ${SRC} && ${STACK} exec ${SITE} rebuild

serve: rebuild
	cd ${SRC} && ${STACK} exec ${SITE} watch

compile:
	cd ${SRC} && ${STACK} build