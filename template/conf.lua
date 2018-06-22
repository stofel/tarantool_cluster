--==========================================
--= Config
local conf = {
    checkpoint_interval = 600,
    checkpoint_count    = 2,
    rows_per_wal        = 10000,
    replication         = {'10.0.1.1:3311', '10.0.1.2:3311', '10.0.1.3:3311', '10.0.1.4:3311'},
    listen              = '10.0.1.1:3311'
  }
return {box = conf, console_url = '10.0.1.1:3322'}
--==========================================

