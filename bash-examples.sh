##################
# Script Options #
##################

# All the pairs below are equivalent

set -e 


set -u
set -o nounset

#######################
# Locating the script #
#######################

# Get the directory of a script
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Shorter, I can't see anything wrong with this but it might cause issues with symlinks etc
SOURCE=${BASH_SOURCE[0]}

#######################
# Parameter Expansion #
#######################

if [ -z "${VAR+xxx}" ]; then echo "VAR is not set at all"; fi
# Note that this is a little verbose, but is safe on set -u
if [ -z "${VAR-}" ] && [ "${VAR+xxx}" = "xxx" ]; then echo "VAR is set but empty"; fi

#################
# If statements #
#################

# TODO come up with a cleaner example
if [ "$(uname)" == "Darwin" ]; then
    # Do something under Mac OS X platform        
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Do something under GNU/Linux platform
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    # Do something under 32 bits Windows NT platform
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
    # Do something under 64 bits Windows NT platform
else
    echo "Unrecognised OS"
fi

#############
# Clipboard #
#############

# msys copy
echo "a"  | clip
# msys paste
cat /dev/clipboard
