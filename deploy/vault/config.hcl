storage "raft" {
  path    = "/home/vault/data"
  node_id = "gyro"
}

listener "tcp" {
  address     = "127.0.0.1:8200"
  tls_disable = true
}

telemetry {
  disable_hostname = true
}

api_addr = "http://127.0.0.1:8200"
cluster_addr = "http://127.0.0.1:8201"
disable_mlock = true
ui = true
