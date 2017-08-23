#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
#set -o xtrace

# Get the repo and build directories, go to the build directory
repo_dir=$(dirname $0)
build_dir=$1
mkdir -p $build_dir
cd $build_dir

# Create extra symlinks
ln -s $repo_dir/deploy/ $build_dir
ln -s $repo_dir/scripts/ $build_dir
ln -s $repo_dir/setup/ $build_dir
ln -s $repo_dir/src/ $build_dir

# Create directory on online_backends
mkdir -p /opt/online_backends/remote_attestation/

# Build the server-side
echo "**** RA server environment setup ****"
server_dir=$build_dir/server
mkdir -p $server_dir
makeOutTmpDir=$(mktemp -d)
asclObj=/opt/ASCL/obj/serverlinux/ascl.o
make -C $repo_dir/setup -s  all-indipendent-clean OUTDIR=$makeOutTmpDir SRCDIR=$repo_dir/src ASCL=$asclObj DBG=1
mv $makeOutTmpDir/verifier_forwarder_exe $server_dir/ra_forwarder
mv $makeOutTmpDir/manager_exe $server_dir/ra_manager
rm -rf $makeOutTmpDir
echo "**** Server environment setup completed****"
echo ""

# Build objects
mkdir -p $build_dir/obj
cd $build_dir/obj
$repo_dir/setup/generate_racommons.sh -o .

# Set up database
$repo_dir/setup/database_setup.sh
