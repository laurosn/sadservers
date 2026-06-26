Scenario: "Manhattan": can't write data into database.

Level: Medium

Type: Fix

Tags: disk volumes   postgres   systemd  

Access: Public

Description: Your objective is to be able to insert a row in an existing Postgres database. The issue is not specific to Postgres and you don't need to know details about it (although it may help).

Helpful Postgres information: it's a service that listens to a port (:5432) and writes to disk in a data directory, the location of which is defined in the data_directory parameter of the configuration file /etc/postgresql/14/main/postgresql.conf. In our case Postgres is managed by systemd as a unit with name postgresql.

Root (sudo) Access: True

Test: (from default admin user) sudo -u postgres psql -c "insert into persons(name) values ('jane smith');" -d dt

Should return:INSERT 0 1

Time to Solve: 40 minutes.

Private key

-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAq48XHup9dmMpZwaZE0y7sdZc8uLar9hU6A6k2MPVVbyxmTgk
thDqSvMJkWzPO1ErxF1i0loswiFXEyUxlrJLK33nYVwBafJsrZOo1KS4S+SPL4pa
2nI0o4siHq3CF1dW2+vlXNtv3/FIz6glPthItav9Pe95y9clLXy4uC9HPrhXi9wI
8rYbuxAHLyYUCy3E0on2FgyN6pQm5BecVaQHSs0Pqzv9nvzmFSqgZteZ5E81kws7
WdrwB+NK3dDnE9ofuYSYHsZ64bAwCEssiIfcDM7aPeh+qKQuwkuect0f6pf9GJSX
suJhCzIKret1C+/mSzV/UsqER7N/6zaMcow2ZwIDAQABAoIBAASB+/+J9cX4kQvt
9nO1XnErysFvCIP6UTDPwbEYZDCehqQZ/4zxINbbT/MMQt2yIk5EjeYtDGQFcD5G
iekFwkfgRQYf3sGj5wsgiB0ePuFvnfuHzR9UROHPNBROSH1IhDW/GwW3llbyBhG+
v0vJbw+m9z57Xl3mx0lMr6XXSC3zqv1YIS7/nSP2OSJhxieY4SEDLoMygFi6UTcR
C2kyqSgf25R52x8n2EkTJZGwg+JcwYX0eLxuVl64NV+cnW9O4kd+lpNgnBzZFXly
zhpw9B/Kefsj4PnlfGAgq4vQjk/kt4pl3dAXCLkypkHIHxPxF5r0ntqzBHL3uRWs
Rkqd8vECgYEA4oFENTsjBpsUhhq+439BdQHJKKburYdeNHqBFEs939WYpfyzP+MW
TntdB3xHWi1mdRQ8iF/rSbkCLkPURV9tkRanlFLzqUtlPTIm8dwMdyJp2yYJpz1Z
Nxe8qTTNUgVPqVzpLzdahfkXyYl9VoK0Zib1S5TBKpga3ZiNegbtI+MCgYEAweYn
D5waDJDDvaURLo8KO+kWgPbYXpHK6sYExPT7ECZDBp8oK0xCQKTjgQFx/BcmBMZ2
4moqsu+l7fKXroBYGlMM39MUmqlw9W7tSj80i8FGG7GcOPnxIj3gxZkHddHNnU4L
HdwJXsC6TGBvLkj78IZV73U1x2cFvvTMwbY3Eq0CgYAWE+uGFMGRP0R83daFbj3/
HbFx2POiznMMQnSaecsKKlO6uiruqz/dXoDu3dpGm+5EszhDQrY4dWQVBl+Gc4rG
faLP/lXpxoOTt3O8V2qPojcXOVnvhzdO+21UQOVSfVoKdBf2ljqonGMJLfGdoRfc
bSezukgp0rGrr9b6cfpjaQKBgCx/ZPdwG4pGrqUW/JpyuSaGl2OBQqZxTuASEYYh
snxCS595Zv6IwauUK6GvczknFtKBuUa8lo/571psEeM6EP35kTrMdi4INKQekNY5
KxXnhO9WE0QAGBaDnNG8DLo9K7Kt9l8j4AKeuCJO/zTgCvFn4tDRVUYtnmP0Sgkq
h/kBAoGBAImjccRcvYmscRi9zVHuepra6Fi4NsMDokysAogqtp0rEhFrdXn5Qsji
7vxUEkqQbwpPMJHqEx8ycjN+XMQoLjoR1xdOUrnJzYaVYvrUvp8xf9PKPhLgAMrB
0qO6Qz7b3XbL2TX/cJTjvNY5yUA7OZsR4m4gGEe/RgnPPWYCODIS
-----END RSA PRIVATE KEY-----

Direct SSH access: copy the key below to a ~/.ssh/sadkey file, chmod 400 ~/.ssh/sadkey and ssh -i ~/.ssh/sadkey admin@3.23.61.105