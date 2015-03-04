#!/bin/bash
set -e

declare -A aliases
aliases=(
	[jessie]='latest'
)

cd "$(dirname "$(readlink -f "$BASH_SOURCE[0]")")"

repos=( "$@" )
if [ ${#repos[@]} -eq 0 ]; then
	repos=( */ )
fi
repos=( "${repos[@]%/}" )

echo '# maintainer: InfoSiftr <github@infosiftr.com> (@infosiftr)'
echo '# maintainer: Trong Nghia Nguyen - resin.io <james@resin.io>'

for repo in "${repos[@]}"; do

	cd $repo
	versions=( */ )
	versions=( "${versions[@]%/}" )
	cd ..
	url='git://github.com/resin-io-library/buildpack-deps'
	for version in "${versions[@]}"; do
		versionAliases=( $version ${aliases[$version]} )
		
		for variant in curl scm; do
			commit="$(git log -1 --format='format:%H' -- "$repo/$version/$variant")"
			echo
			for va in "${versionAliases[@]}"; do
				if [ "$va" = 'latest' ]; then
					va="$variant"
				else
					va="$va-$variant"
				fi
				echo "$va: ${url}@${commit} $repo/$version/$variant"
			done
		done
		
		commit="$(git log -1 --format='format:%H' -- "$repo/$version")"
		echo
		for va in "${versionAliases[@]}"; do
			echo "$va: ${url}@${commit} $repo/$version"
		done
	done
done