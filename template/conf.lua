#!/usr/bin/env tarantool


--==========================================
--= Config
local conf = {
    snapshot_period     = 10,
    snapshot_count      = 2,
    rows_per_wal        = 50,
    --console_url         = '10.0.1.1:3322', -- configure console ip
    --listen              = '10.0.1.1:3311', -- configure listen ip
    --replication_source  = {'10.0.1.4:3311', '10.0.1.1:3311', '10.0.1.3:3311'} %% configure other cluster nodes
  }
return conf
--==========================================


