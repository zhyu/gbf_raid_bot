#!/usr/bin/env bash

kill $(ps aux | grep elixir | grep gbf_raid_bot | tr -s ' ' | cut -d ' ' -f 2)
