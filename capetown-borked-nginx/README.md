Scenario: "Cape Town": Borked Nginx

Level: Medium

Type: Fix

Tags: nginx   systemd  

Access: Email

Description: There's an Nginx web server installed and managed by systemd. Running curl -I 127.0.0.1:80 returns curl: (7) Failed to connect to localhost port 80: Connection refused , fix it so when you curl you get the default Nginx page.

Root (sudo) Access: True

Test: curl -Is 127.0.0.1:80|head -1 returns HTTP/1.1 200 OK

Time to Solve: 30 minutes.

Direct SSH access: copy the key below to a ~/.ssh/sadkey file, chmod 400 ~/.ssh/sadkey and ssh -i ~/.ssh/sadkey admin@18.216.177.180

You can also set a public SSH key in your dashboard and it will be put in all the VMs with a public IP.

-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAtEIKZle3496ou1vCUMA/5E56vc7Fi4btwFunP1HHr6FmJGY8
XJNCYLMQ7p90NfGZCuoSe8C2H2lRwvJmg9iE6wVRJxGAxApjmoWYL9U36z6owltT
n2ROfXjrlyYTwpG/opsXq6nWN2nNbIwd4idwA/Vujx0JahSByMsIC+ONeKaGxuB0
4IKswiM2BgzmtwCQsWljwrarnTkS9cWJo4gg6208T2TnLLaFvzaTDOGnYTDlgcJ2
+Fy6TOzo0ouDNkd832cBTazvdfg15maUI3OcO1EneT6xwJR51OouYVjLx484xbWR
IhBS0Jotj0pqruhPwybgSKM8UrhCsnIPSXJ4PwIDAQABAoIBACA3YWZzLQGD7QI3
Xx5Rjdm/EP7VcscCIYHsn5KYiijgnsHIp+cfxpBD0LXlN77gZCroNM97XNF2YE+I
RTwxOWhLtfpWjX38IVsfn1iFMg5QT5cU/XgSVFjmgKyt+IAgznBAadWbcBbNSRKq
ZDjkNYfvmIfpd6JG8f8yEkkVrVYvmDVou5KJJkfzX+ssnystZLUV0B7rSEtEC0Hf
VoD1ArGa7PgEnNFKRHpLTRotZC5Fsg0aXMi+Ka0TDPE/2Zl+nDhtPymoDfLgZ8r5
c2tPlfqSPyV8t/n5Ocno8d8PU2X3RgYpzwrxXCRMygU/yxNa5MoB8ahmbGlpKoHj
fgNLfDECgYEA3yL38csuK9vQyeJFJeMvfXzE2Ug17q0C3mO+erEeQN1ndqzZT6Mb
3mKNAujkI12cGKZqwInKpIwZCdJbK9rS3hQFmDlOcB/jzc35pV+NptSggRD1U8Iq
ffRruY1AMcI4jM1sgzFwBLSMI00cKQMCnsf4AyjZ4rsICXDIHrLpRAcCgYEAzs5l
0C+FDMEhZvKobQ66dN6xf0AYPVSnoHnBHFwvhvS+T+AwQlKn+BuaCV2dKpYbYfwu
6OrHn4dUjydszGOPP0hddqd/1iZnZrtmm5B+ItCItA0mV/ff5wuOZOrM3EKbtxte
NOSTH8Kkqj54H3aoE3HjnuR3p/jTb4CFmGdLTAkCgYEAw8hr4yUScvshPDIj1/V5
stJp6fg5Eh2N2dGMzRxhXiql4HQTDJQiHMM91OLBYeJ91wcVvbBpNG2UfpCq3FTZ
FnBc5E7L6wegGvDybc7kfBAucHCPwRkprXBroNg2DjLK6YhJAOe80PQVzdeXsMhq
YSU2EJekbhMLHzVs8bqrf7sCgYEArwUuVUpiJ7ErO50RvXpBgrcVMMRlv0Htu3pP
XFkIQAbRKXhqXzbkwK1bZ6G6aVgwRHTQnn5UA0bc4WpUQYXgrYXo04pePjayO9dN
t0pJ9dzWVMrsMHavHzJAiFfOmHomnoii6dCoUrC/+vRzZO1ewVYZdVeVjKqhBjSW
26xPpUECgYAVjA9r60k/WFMNARw6moleHuImPYH29dVyTVMyUkBPYI6Qgol/ZUF4
sMgWtEqJaZRMRryj3IoASsRhVXfR9bA7uYtD7rI9vTtimNnHoKxcHFGsdvqjE4OZ
iDYazd06uAKxZ77DdbWXbwB/lvuBeT2fAVfzOSao+ZwN5OKWzLnsgA==
-----END RSA PRIVATE KEY-----