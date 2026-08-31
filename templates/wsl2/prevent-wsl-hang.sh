#!/bin/bash
set -Eeuo pipefail

readonly services=(
    accounts-daemon.service
    atd.service
    motd-news.service
    sudo.service
    systemd-networkd-wait-online.service
)

dry_run=false
case "${1:-}" in
"")
    ;;
--dry-run)
    dry_run=true
    ;;
*)
    echo "Usage: $0 [--dry-run]" >&2
    exit 2
    ;;
esac

if [[ ! -d /run/systemd/system ]]; then
    echo "systemd is not running; enable it in /etc/wsl.conf before using this script." >&2
    exit 1
fi

for service in "${services[@]}"; do
    if ! systemctl cat "$service" &>/dev/null; then
        echo "Skip missing unit: $service"
        continue
    fi

    if [[ "$dry_run" == true ]]; then
        echo "Would mask and stop: $service"
    else
        sudo systemctl mask --now "$service"
    fi
done

if [[ "$dry_run" == true ]]; then
    echo "No changes made."
else
    echo "Applied WSL service masks. Restart WSL with: wsl.exe --shutdown"
fi