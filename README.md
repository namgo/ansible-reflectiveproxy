Role Name
=========

This module forwards (mirrors?) a port to a middlebox over ssh-tunnel. The middlebox is then given a guest user who may access the forward.

Requirements
------------

Tested on Ubuntu hosts, doesn't install anything so should work fine on all Linux and maybe BSD.

Limitations
-----------

The role only allows one sshtunnel_guest_pubkey at the moment, adding support for multiple guest keys should be easy enough.

Role Variables
--------------

sshtunnel_{middlebox,forward}_user: usernames to create (!) for proxy hosts (defaults to proxy)
sshtunnel_{middlebox,forward}_home: home dir for users (defaults to /srv/proxy)

sshtunnel_pubkey: public key for tunnel system, only on middlebox
sshtunnel_privkey: private key for tunnel, only on forward

sshtunnel_onport: port to be used on middlebox (defaults to 2222)
sshtunnel_toport: active tcp port on forward (defaults to 22)

is_forward: tells role to install the system as forward (there's gotta be a better way to do this)
is_middlebox: tells role to install the system as middlebox

sshtunnel_guest_user: guest who we are giving access to (defaults to guest)
sshtunnel_guest_pubkey: guest user's public key

sshtunnel_middlebox_ip: hostname/ip to connect to from forward

Dependencies
------------

No dependencies.

Example Playbook
----------------

```

- hosts: forward
  roles:
    - role: namgo.sshtunnel
      tags: forward
      vars:
        is_forward: true
        sshtunnel_middlebox_ip: middlebox.host
        sshtunnel_privkey: "{{ lookup('file', 'example/middlebox') }}"
        sshtunnel_forward_home: "/srv/proxy"
        sshtunnel_forward_user: proxy
        sshtunnel_middlebox_user: proxy

- hosts: middlebox
  roles:
    - role: namgo.sshtunnel
      tags: middlebox
      vars:
        is_middlebox: true
        sshtunnel_guest_user: guestuser
        sshtunnel_guest_pubkey: "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCee6aWkS5VvD6WXZk2aRMaY7mCZJCbzSF4qgWBQa5ptkqWwK5xjFyDvRmCgxj3aeOWt8uhrr4ai9wBsLMbMAuwKgC8thszy2HeMs7HqDfBqKcJJ76UVB0ZJB6vEQUD7SYTEEX09ODronY3lNFxEKA2Y330v6L3Dm45Cv3tyeUQEYOU83B2EiBAj1dAg+5GIHIi5lP6Lw+C35aW9mqn4unUpL/jDYN+Kf4u+QWLFjxToa1CrQgkK8AISvxgn5Hiq8uJeXljsivgU7Bzh89Ry1KGcOBzoVLCU/62UX81isOXLlP68SQSimHCLFmzxMIvInelqjFKEtno09XcnrKg8ZR670DOwP99P19gTIwpj61djzc5aKpcOuJ/N6Yt7jhXnwyu27vcG92aFy04JOuR7jfEkyVmZe3JxrLJ+GbkRR8uwbTbf1rJc5iYA6EThos59h0Qmy5vTrlN/hrMIbpsmMvQjhnhW6MbT1WqsBXc3/wQlJuI/pZc51Wpil80vC99sIE="
        sshtunnel_middlebox_user: proxy
        sshtunnel_middlebox_home: "/srv/proxy"
        sshtunnel_pubkey: "{{ lookup('file', 'example/middlebox.pub') }}"

```

License
-------

BSD

