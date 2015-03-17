#!/bin/bash
set -e

repos='armv7hf rpi i386'
suites='jessie wheezy'

for repo in $repos; do
	case "$repo" in
	'rpi')
		baseImage='rpi-raspbian'
	;;
	'armv7hf')
		baseImage='armv7hf-debian'
	;;
	'i386')
		baseImage='i386-debian'
	;;
	esac
	for suite in $suites; do
		dockerfilePath=$repo/$suite
		mkdir -p $dockerfilePath
		sed -e s~#{FROM}~resin/$repo-buildpack-deps:$suite-scm~g Dockerfile.tpl > $dockerfilePath/Dockerfile
		mkdir -p $dockerfilePath/curl
		sed -e s~#{FROM}~resin/$baseImage:$suite~g Dockerfile.curl.tpl > $dockerfilePath/curl/Dockerfile

		mkdir -p $dockerfilePath/scm
		sed -e s~#{FROM}~resin/$repo-buildpack-deps:$suite-curl~g Dockerfile.scm.tpl > $dockerfilePath/scm/Dockerfile
	done

	# Only for armv7hf
	if [ $repo == 'armv7hf' ]; then
		suite='sid'
		dockerfilePath=$repo/$suite
		mkdir -p $dockerfilePath
		sed -e s~#{FROM}~resin/$repo-buildpack-deps:$suite-scm~g Dockerfile.tpl > $dockerfilePath/Dockerfile

		mkdir -p $dockerfilePath/curl
		sed -e s~#{FROM}~resin/$baseImage:$suite~g Dockerfile.curl.tpl > $dockerfilePath/curl/Dockerfile

		mkdir -p $dockerfilePath/scm
		sed -e s~#{FROM}~resin/$repo-buildpack-deps:$suite-curl~g Dockerfile.scm.tpl > $dockerfilePath/scm/Dockerfile
	fi

done
