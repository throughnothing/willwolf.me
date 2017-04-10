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


publish: rebuild
	cd ${SRC} && ${STACK} exec ${SITE} rebuild

	git stash

	# Get previous files
	git fetch --all
	git checkout -b ${SITE_BRANCH} --track origin/${SITE_BRANCH}

	# Overwrite existing files with new files
	rsync -a --filter='P src/'         \
         --filter='P output/'        \
         --filter='P .hakyll-cache/' \
         --filter='P CNAME'          \
         --filter='P .git/'          \
         --filter='P .gitignore'     \
         --filter='P .stack-work'    \
         --delete-excluded           \
         output/ .

	# Commit
	git add -A
	git commit -m "Publish."

	# Push
	git push origin ${SITE_BRANCH}:${SITE_BRANCH}

	# Restoration
	git checkout ${DEVELOP_BRANCH}
	git branch -D ${SITE_BRANCH}
	git stash pop & exit 0

# Hakyll site definition compilation
compile:
	cd ${SRC} && ${STACK} build