port: 
[
  {
    containerPort = port;
    hostPort = port;
    protocol = "udp";
  }
  {
    containerPort = port;
    hostPort = port;
    protocol = "tcp";
  }
]
