#!/usr/bin/env bash
# Synchronize Labwc theme via Noctalia native template processor
exec noctalia msg templates-apply >/dev/null 2>&1 || labwc --reconfigure
