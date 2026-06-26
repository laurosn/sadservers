Direct SSH access: copy the key below to a ~/.ssh/sadkey file, chmod 400 ~/.ssh/sadkey and ssh -i ~/.ssh/sadkey admin@18.222.253.65

You can also set a public SSH key in your dashboard and it will be put in all the VMs with a public IP.

-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAuWDxF9THK0oTngl5U3TffNHnXOL/Brsp7leaQutXhStBIy31
gXclDA3KCLU2GCijvRdd6D91kHo+IEiwB2G5uTg2dR5mhLVLCz1yPm07PQ8DlJ5i
ZrTGCL/9VJqKbhOZ+yCJEltzZITZHL3HFFPr7Pcw49O4+iUVRfDVofHZeel9TUXE
WtZoD+aeVDbpeGOObPr8b4G1iqlgDoLIvXjmkOOGJFBhCVRUgNILDA65/5y54jIw
aJwiNYDimL5OS/rerTnmNq9CNblX1zrj1uEGzhW61qQzbHx0ThKK8fDFHG/jbeIJ
iycWHoAw6lNax4KI3HtikNe20/CvCycWSxcbEQIDAQABAoIBAH3uBNmTidk2cS0i
cnDnLAq27NyEt4nzCwEGMZzUEpg8Uft79RMFxPzzQRO5Rg4TTWfev8RNl6eV4y47
MplRIcFZFmVpSWtNXLU+AKW3vk40LNKA5YevtfertIQMl40/c5LM/1ChHzphpLuJ
j/uXJuXK5kNeSIJlPpZMjFN+36WYdsJi3XDlEjOa1Ye/tVoI1GP72A0zTSTVlgKl
xxApaYcCX9xwpZtFuvNZP+ZmJ9PyxM3MaGy85L4lPBKZFDWRNNflZ/Gbdob6FgJF
NclyyWrX3h79AYEuC1/vtMUCIa44hHQg2wjjmAlRPygQFxil6CivWp1BIwbirHfK
r3YibYECgYEA6/qiJi8aw7BWnr2LblObFPukribpfgAIrnXAAdwPg/fVxyeqBfk8
BErf0U39Pr7VZajtNXMMM465Nx8xTWmTVlib/8RkQ632prugek+AoBbCDusf3UOy
phquy5gFhmeI5+hpMKk5X+DRRVhtMz5fW70UGoreNCYPlh2C6lhjmb0CgYEAyRtK
JTXiirNNhO7TPkX1+q4aqg0YUYggvxLreoeFe4dGSetN4eroBYsp0rNQpvFRj2D2
SA04+vZlz63fCBGGbpAtGs1bXsCF8NddLvnq8TH10oWmpqxDl4/tcyUpQ04HlRg7
tzL92mqHFHU+h1pqtFR+CIOtDcnckeYaFB1JueUCgYBq1S8vpkexrFWqzBkhu4wM
NdjaVxeCSbWkdf6VWPFVR5Bq91QMHEfFkbg+Y9Zw36hwu8eYWRt/A/BqOh7x8wgX
IUqOwnS6BzoRRgRjGzcaQvNcGap1W763YIEd/xcRQDJE+30T4Kju9TMI9/2II4a8
W5+MXK44YbrQtU+dlKKS6QKBgD/YYBOsJb2u6t9XCs1sXIk3GNP/0EaiFvNSSFvg
BmqPKatx/onIj9yir6ZqsyIs3p3MRKPfPsW9z9i89F+VYL5dG1S0+Vr9eAhb9wNg
6EumdspdD+k+Kz9EvDegBpeNgC6/QMYKdDkRNM0z46QI+nNBl7mQRDJqcZIIISNd
oPhZAoGAFrgOdXU3NiQn/zXAKIA8WSEPZeHon/fphIDgjNQPQCMZ6e3W3185BbUR
YL3lJv5TCmc9PWoTgcG+egjU/HF/XC82wDyKpzvZwfVqxAmeJnI9CciV8KhaGnsi
I/2dUL6YIcT1q6uU3Zv9S1w8Abu886OYmZ6DoxjGeZjV0sau/gk=
-----END RSA PRIVATE KEY-----
Scenario: "Salta": Docker container won't start.

Level: Medium

Description: There's a "dockerized" Node.js web application in the /home/admin/app directory. Create a Docker container so you get a web app on port :8888 and can curl to it. For the solution to be valid, there should be only one running Docker container.

Test: curl localhost:8888 returns Hello World! from a running container.

Time to Solve: 30 minutes.

OS: Debian 11

Root (sudo) Access: No