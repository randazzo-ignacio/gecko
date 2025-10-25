source "$(dirname ${BASH_SOURCE[0]})/config.sh"

if [ ! -f ${TARGET} ]; then
  echo "File \"${TARGET}\" not found"
  echo "Modify $(realpath ${BASH_SOURCE[0]})"
  exit 1;
fi
