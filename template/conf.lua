--==========================================
--= Config
db_ip   = '10.0.1.1'
db_port = '3311'
console_port = '3312'
repl = {
 '10.0.1.1:' .. db_port,
 '10.0.1.2:' .. db_port,
 '10.0.1.3:' .. db_port,  
 '10.0.1.4:' .. db_port
}
local conf = {
    checkpoint_interval = 600,
    checkpoint_count    = 2,
    rows_per_wal        = 10000,
    replication         = repl,
    read_only           = false,
    listen              = db_ip .. ':' .. db_port
  }
return {box = conf, console_url = db_ip .. ':' .. console_port}
--==========================================

