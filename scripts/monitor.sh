#!/usr/bin/env bash

set -u

if [[ $# -ne 1 ]]; then
  echo "Использование: $0 <имя-сервиса>" >&2
  exit 2
fi

service_name="$1"

if ! systemctl list-unit-files --type=service --no-legend "${service_name}.service" 2>/dev/null | grep -q .; then
  echo "Сервис '${service_name}' не найден." >&2
  exit 3
fi

service_status="$(systemctl is-active "${service_name}" 2>/dev/null || true)"
echo "Сервис: ${service_name}"
echo "Статус: ${service_status}"

if [[ "${service_status}" != "active" ]]; then
  echo "Последние 10 строк журнала:"
  journalctl -u "${service_name}" -n 10 --no-pager 2>/dev/null || echo "Журнал сервиса недоступен."
fi

error_pattern='error|failed|failure|critical'

if [[ -r /var/log/syslog ]]; then
  one_hour_ago="$(date --date='1 hour ago' '+%b %e %H:%M:%S')"
  error_count="$({ awk -v start="${one_hour_ago}" 'substr($0, 1, 15) >= start' /var/log/syslog || true; } | grep -Eic "${error_pattern}" || true)"
  log_source="/var/log/syslog"
else
  error_count="$(journalctl --since '1 hour ago' --no-pager 2>/dev/null | awk 'BEGIN { IGNORECASE=1 } /error|failed|failure|critical/ { count++ } END { print count+0 }')"
  log_source="systemd journal (syslog отсутствует)"
fi

echo "Ошибок за последний час: ${error_count}"
echo "Источник: ${log_source}"
