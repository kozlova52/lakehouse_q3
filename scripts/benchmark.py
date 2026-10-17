#!/usr/bin/env python3
"""Повторный замер длительности запроса через Trino HTTP API.
Запуск: python scripts/benchmark.py --query-file sql/05_benchmarks.sql
По умолчанию: http://localhost:9999, пользователь student.
"""
import argparse
import json
import time
import urllib.request
import urllib.error

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--url", default="http://localhost:9999/v1/statement")
    parser.add_argument("--user", default="student")
    parser.add_argument("--catalog", default="lakehouse")
    parser.add_argument("--schema", default="default")
    parser.add_argument("--query-file", required=True)
    parser.add_argument("--repeats", type=int, default=3)
    args = parser.parse_args()

    with open(args.query_file, "r", encoding="utf-8") as f:
        content = f.read()
    # SQL-файлы могут содержать комментарии; делим простые запросы по точке с запятой.
    statements = [s.strip() for s in content.split(";") if s.strip() and
                  any(line.strip() and not line.strip().startswith("--")
                      for line in s.splitlines())]
    if not statements:
        raise SystemExit("В файле не найдено SQL-запросов.")

    for idx, sql in enumerate(statements, 1):
        for run in range(1, args.repeats + 1):
            req = urllib.request.Request(
                args.url,
                data=sql.encode("utf-8"),
                headers={
                    "X-Trino-User": args.user,
                    "X-Trino-Catalog": args.catalog,
                    "X-Trino-Schema": args.schema,
                    "Content-Type": "text/plain; charset=utf-8",
                },
                method="POST",
            )
            start = time.perf_counter()
            try:
                with urllib.request.urlopen(req, timeout=120) as response:
                    payload = json.loads(response.read().decode("utf-8"))
                while payload.get("nextUri"):
                    with urllib.request.urlopen(payload["nextUri"], timeout=120) as response:
                        payload = json.loads(response.read().decode("utf-8"))
                    if payload.get("error"):
                        raise RuntimeError(payload["error"])
                elapsed = time.perf_counter() - start
                if payload.get("error"):
                    raise RuntimeError(payload["error"])
                print(f"query={idx} run={run} seconds={elapsed:.3f}")
            except (urllib.error.URLError, TimeoutError, RuntimeError) as exc:
                print(f"query={idx} run={run} FAILED: {exc}")
                break

if __name__ == "__main__":
    main()
