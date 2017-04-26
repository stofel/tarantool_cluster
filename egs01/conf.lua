#!/usr/bin/env tarantool


--==========================================
--= Config
local conf = {
    snapshot_period     = 60,
    snapshot_count      = 2,
    rows_per_wal        = 10000,
    console_url         = '10.0.1.2:3322',
    listen              = '10.0.1.2:3311',
    replication_source  = {'10.0.1.4:3311', '10.0.1.1:3311', '10.0.1.3:3311'}
    --replication_source  = {'10.0.1.4:3311', '10.0.1.3:3311'}
  }
return conf
--==========================================

