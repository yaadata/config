#!/usr/bin/env python3

import os
import subprocess
import sys
from enum import Enum


class Action(str, Enum):
    BOTH = "both"
    LOCAL = "local"
    REMOTE = "remote"


def git(*args):
    result = subprocess.run(["git", *args], capture_output=True, check=False)
    if result.returncode:
        sys.stderr.buffer.write(result.stdout + result.stderr)
        result.check_returncode()
    return result.stdout


def fail(message):
    sys.exit(message)


def branch_metadata(ref):
    rows = git(
        "for-each-ref",
        "--format=%(refname)%00%(objectname)%00%(upstream:remotename)%00%(upstream:remoteref)%00%(upstream)",
        ref,
    ).splitlines()
    exact = [
        row.split(b"\0")[1:] for row in rows if row.split(b"\0")[0] == os.fsencode(ref)
    ]
    if len(exact) != 1:
        fail("Expected exactly one local branch")
    return tuple(map(os.fsdecode, exact[0]))


def parse_worktrees(snapshot):
    records = []
    for block in snapshot.split(b"\0\0"):
        if not block:
            continue
        record = {}
        for field in block.split(b"\0"):
            key, _, value = field.partition(b" ")
            record[key] = value
        records.append(record)
    return records


branch, action_text = sys.argv[1:]
try:
    action = Action(action_text)
except ValueError:
    fail("Invalid deletion action")
ref = "refs/heads/" + branch
try:
    metadata = branch_metadata(ref)
    _, remote, merge_ref, tracking_ref = metadata
    delete_local = action is not Action.REMOTE
    delete_remote = action is not Action.LOCAL and all(
        (remote, merge_ref, tracking_ref)
    )
    expected_remote = None
    if delete_remote:
        if remote == "." or not merge_ref.startswith("refs/heads/"):
            fail("Upstream is not a branch on a remote")
        remote_urls = git("remote", "get-url", "--push", "--all", remote)
        if len(remote_urls.splitlines()) != 1:
            fail("Multiple push destinations are not supported")
        probe = subprocess.run(
            ["git", "rev-parse", "--verify", "--quiet", tracking_ref],
            capture_output=True,
            check=False,
        )
        if probe.returncode == 0:
            expected_remote = os.fsdecode(probe.stdout).strip()
        else:
            # Check the push destination, which may differ from the fetch URL.
            destination = os.fsdecode(remote_urls[:-1])
            advertised = git("ls-remote", "--refs", "--", destination, merge_ref)
            if any(
                line.split(b"\t", 1)[-1] == os.fsencode(merge_ref)
                for line in advertised.splitlines()
            ):
                fail(
                    "Remote branch exists but its tracking ref is missing. Fetch the remote first, then retry."
                )

    path = None
    if delete_local:
        snapshot = git("worktree", "list", "--porcelain", "-z")
        records = parse_worktrees(snapshot)
        matches = [r for r in records if r.get(b"branch") == os.fsencode(ref)]
        if len(matches) > 1:
            fail("Multiple worktrees use this branch; refusing deletion")
        path = os.fsdecode(matches[0][b"worktree"]) if matches else None
        current = os.path.realpath(
            os.fsdecode(git("rev-parse", "--show-toplevel")[:-1])
        )
        if path:
            if matches[0] is records[0] or os.path.realpath(path) == current:
                fail("Cannot remove the main or current worktree")
            if b"locked" in matches[0]:
                fail("Worktree is locked")

    if branch_metadata(ref) != metadata:
        fail("Branch or upstream changed during deletion preparation; retry")
    if (
        delete_remote
        and git("remote", "get-url", "--push", "--all", remote) != remote_urls
    ):
        fail("Remote destination changed during deletion preparation; retry")
    if delete_local:
        if git("worktree", "list", "--porcelain", "-z") != snapshot:
            fail("Worktree metadata changed during deletion preparation; retry")
        if path:
            git("worktree", "remove", "--force", "--", path)
        git("branch", "-D", "--", branch)
    if delete_remote and expected_remote is not None:
        git(
            "push",
            "--force-with-lease=" + merge_ref + ":" + expected_remote,
            "--",
            remote,
            ":" + merge_ref,
        )
except (subprocess.CalledProcessError, OSError) as error:
    fail(
        "Deletion stopped; earlier successful steps are not rolled back: " + str(error)
    )
