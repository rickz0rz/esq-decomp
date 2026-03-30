#!/usr/bin/env python3
"""Report state-flow compare lanes and their semantic-filter wiring.

This helps catch cases where a `compare_sasc_*_state_flow_trial.sh` lane exists
but either:
- the referenced `awk -f` semantic filter is missing, or
- the lane points at an alias/mismatched filter name rather than the
  conventional `semantic_filter_sasc_<stem>_state_flow.awk` path.
"""

from __future__ import annotations

import argparse
import re
from dataclasses import dataclass
from pathlib import Path


RE_AWK_FILTER = re.compile(
    r"awk\s+(?:-[^ \n]+\s+)*-f\s+(src/decomp/scripts/[A-Za-z0-9_./-]+\.awk)"
)


@dataclass(frozen=True)
class LaneReport:
    compare_script: str
    referenced_filter: str | None
    referenced_exists: bool
    conventional_filter: str
    conventional_exists: bool

    @property
    def status(self) -> str:
        if self.referenced_filter is None:
            return "missing-ref"
        if not self.referenced_exists:
            return "missing-filter"
        if self.referenced_filter != self.conventional_filter:
            return "alias-filter"
        if not self.conventional_exists:
            return "missing-conventional"
        return "ok"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "List SAS/C state-flow compare scripts and whether their semantic "
            "filter wiring matches the conventional filename."
        )
    )
    parser.add_argument(
        "--only-problems",
        action="store_true",
        help="Hide rows whose referenced filter exists at the conventional path.",
    )
    return parser.parse_args()


def collect_reports(repo_root: Path) -> list[LaneReport]:
    reports: list[LaneReport] = []
    scripts_dir = repo_root / "src/decomp/scripts"

    for compare_path in sorted(scripts_dir.glob("compare_sasc_*_state_flow_trial.sh")):
        content = compare_path.read_text()
        matches = RE_AWK_FILTER.findall(content)
        referenced_filter = matches[0] if matches else None
        referenced_exists = False
        if referenced_filter is not None:
            referenced_exists = (repo_root / referenced_filter).exists()

        stem = compare_path.name[len("compare_") : -len("_trial.sh")]
        conventional_filter = f"src/decomp/scripts/semantic_filter_{stem}.awk"
        conventional_exists = (repo_root / conventional_filter).exists()

        reports.append(
            LaneReport(
                compare_script=str(compare_path.relative_to(repo_root)),
                referenced_filter=referenced_filter,
                referenced_exists=referenced_exists,
                conventional_filter=conventional_filter,
                conventional_exists=conventional_exists,
            )
        )

    return reports


def main() -> int:
    args = parse_args()
    repo_root = Path(__file__).resolve().parents[3]
    reports = collect_reports(repo_root)

    if args.only_problems:
        reports = [report for report in reports if report.status != "ok"]

    status_counts: dict[str, int] = {}
    for report in reports:
        status_counts[report.status] = status_counts.get(report.status, 0) + 1

    total_lanes = len(list((repo_root / "src/decomp/scripts").glob("compare_sasc_*_state_flow_trial.sh")))
    print(f"state-flow compare lanes: {total_lanes}")
    print(f"reported rows: {len(reports)}")
    for status in sorted(status_counts):
        print(f"{status}: {status_counts[status]}")
    print()

    header = (
        f"{'status':18}  {'compare_script':58}  "
        f"{'referenced_filter':52}  conventional_filter"
    )
    print(header)
    print("-" * len(header))

    for report in reports:
        ref = report.referenced_filter or "-"
        print(
            f"{report.status:18}  {report.compare_script:58}  "
            f"{ref:52}  {report.conventional_filter}"
        )

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
