Direct SSH access: copy the key below to a ~/.ssh/sadkey file, chmod 400 ~/.ssh/sadkey and ssh -i ~/.ssh/sadkey admin@18.116.230.125

You can also set a public SSH key in your dashboard and it will be put in all the VMs with a public IP.

-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAtSGpNzAy6fCEn5AmZ44/vP6Oo5NUYcb5BnXKTZkAETjVsuCr
OKuR/1kBnz5rWvONBNcaBuE0kF7DCTCHYSZBXCtnEFSrRzYdvrgTh4NB5JKX/STp
a150bme2kqDuw4dJYJ/gbsamUnPTvbtxPI6KjhLqYR7HpCXMJ4WCaC3Lx/lNY5Cw
xxrYZTeTO5u7yfDuf4uq4J6EQOyRYh73GosDaZiIrijtQJ07GESR/d68HEyZZ7K3
nH5iojOs2K836FVE893VwEZnEZzyn3ejOYVO9j6YAo62ob3K6Z7TAPGOGvKGERTV
6bI87LOlsi6745/ErpZFHugxgnWjSVjU6IugVwIDAQABAoIBACocsl/vZ9b2IY+L
jzJCY1VIhddIGLVG8nzrA+b4rIhUg3K8Q3LAiQgqJHNmqsURnPbEH/v7fiIWthe7
3a3bnBSWzraASPYcgdvmpju6a6Z94rJrU42v/zfwCwWaPwjculWpth9rNh4zacZR
/yjKJzKS+UUtR9NFKmsB4mjgROGwE4XNApV9sqoFxJFaPu03ej8zFwL5imuAoqLW
m7dnJ0q7MqJo/u4k8DU/YtyOpi5G4ZXCqqAjSPCotg8HSNQO2ImCma8/6USGOMIY
/zm/cNYJlqQG3IAFnj/CBnjqaQfY2nZTVZsVAtYdTCx+gmaXV7qRDQDyYZVJFZpW
12Hr++ECgYEA2xs2AKBbhcS2bKzsEAeS0fbeaK43llybghFtPOMMcRlAKCD8zKKm
W/sxEpOlGfEO8CU/yUTHlHOwng3oxqaVleq8BqUwHnlvtxtsgr1pmCKbZl8m3fi7
L0iiWhUIysKZ4De75yX5vBf4u3hJ/2eGRUnbyNRmBHG9SfIVkvLaZhECgYEA06GC
YgRvPt+aQi0xIufYJcv6DaiOQRc5LtfWzGDx96TUjHn1P7sEDfgR5lcQLCiRhLB5
0CMpUjTeYIjKgr26+CpUNZh/gDdGoZPobU3gfzToyjduwnNyKdP024dfbk9Tc3na
TZmwxqvmpMYBDE48krux+XoVQv8Z6lydZptuF+cCgYAfOdWMaU4h1lMZUduivTGT
ctdnm8yYRUJ0Wv9yefk/9RVLosfkchm7aiUoPJp/A/fZCbX5fS/kXEiDff/6r6sJ
3pZFbC1bansdYW8pgs0VvXjgMhdb8yLaLkPVCsJiAzHi3o6M9sCMqe3s6cvB9oMQ
ROJp0LtpTrxnWXTxqGKvwQKBgQCWeF5g3LBQLuHaLZGjNN79OMOI1JCYfS+eO76w
wDkqj9rEKq6SaqEeYYQwlzSbgRi+FE/4ChgGKCr4zinWvZnjew02sj/tZN/mYGjA
1r9JEtB1fuZUgYrpbJfLQrw6jVJTZ48s35rOF0k9XL9ABZyR47xOGlxlr0W42bLc
UqT7fwKBgGuhzBtNQ++RX4Cc57X9ma3wBMKMrvNINbaaH+cQgretvRymt5uDorul
6arEjvphut7kYKKrBxxa0t24helTaKIo3fWrGgxFq0pjCXyDEAMWR9FA557rrkm5
w1hcz+mzEfGmCaEvHa/HqgtlCSxjEdYkqEk4HJxdMHYE/Rrxv6/9
-----END RSA PRIVATE KEY-----
Scenario: "Venice": Am I in a container?

Level: Medium

Description: Try and figure out if you are inside a container (like a Docker one for example) or inside a Virtual Machine (like in the other scenarios).

Test: This scenario doesn't have a test (hence also no "Check My Solution" either).

Time to Solve: 30 minutes.

OS: Debian 11

Root (sudo) Access: No