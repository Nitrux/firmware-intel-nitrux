#! /bin/bash

set -x

### Basic Packages
apt -qq update
apt -qq -yy install equivs git devscripts lintian --no-install-recommends

### Remove these files from upstream source.
files=(
    ".directory"
    "*LICENSE*"
)


echo "Removing files..."
for file in "${files[@]}"; do
    find . -type f -name "$file" -exec rm -f {} \; 2>/dev/null
done

echo "Cleanup complete."

### Install Dependencies
mk-build-deps -i -t "apt-get --yes" -r

### Build Deb
debuild -b -uc -us

### Move Deb to current directory because debuild decided
### that it was a GREAT IDEA TO PUT THE FILE ONE LEVEL ABOVE
mv ../*.deb .
