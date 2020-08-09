#!/bin/bash
# Apache-2.0

echo -ne '     Hypervisor Entrypoint     )\r'
sleep 1

set -e

    if 
        [ "${1#-}" != "${1}" ] || [ -z "$(command -v "${1}")" ]; then
        set -- curl "$@"
    fi

exec "$@"
