#!/usr/bin/env bash

debug()
{

echo pubkey is $(cat /root/.ssh/authorized_keys)
echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
echo "AuthorizedKeysFile	.ssh/authorized_keys .ssh/authorized_keys2" >> /etc/ssh/sshd_config
cat /etc/ssh/sshd_config
}

pubkey="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDYg7VmJJQ/Yrg4JE86kcDTM+mfpq/8N1u7obW07HIy/wfPugNCRUBlPsCl54FEPAVXTaHyGF+1HYfr1MVvH6M1vJP0PKAiobUhtihXz3JfEqDiGHBoOWg7lBwpTw2eZj7ZjAPxdtrbUVVj3IghKd42APtkQqV+g/c+5fDZk+3zBJDl+oYuVLVuYXPMp9m8WLOe0Dskpeo2TEwFQvdbUhMHcXAQZCLf9NzvK/2PrbmhTfRxz0ZvZ8ZZQyuXcg1oCTDV9Xrne9zFpZgHXyE0/Qv07pHsVy9b2uK7SrJyiF67XNrR8sQbUx+cHlDldI7q+p5VVzmi2m9KHqt29bSCa0/BgAgUG6XLk+VreSFN85s2jGoP5iBle+fjv/uIke8Ja6gpfvB3sYUXIcnOHiL6YHyS5Cd8Gl7D8H9cZ9KKQT1uk65J6X1lR9LT4fTybTKe3Us92juzTSDHHyvBpDd1b0hO4uIEAaZGhpZ8JdsN82OBtX5E9GDe5pZfU2REwOAwQ8U= coran@YY-Lenovo"
sshflags=""
PORT=2222
# check if pubkey exists
if [[ ! -z "$pubkey" ]]
then
echo "$pubkey" > $HOME/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
else
echo pubkey is NOT set
env
fi
# check if a different port
if [[ ! -z "$sshport" ]]
then
echo sshport : $sshport
PORT=$sshport
fi

if [[ ! -z "$debug" ]]
then
debug
sshflags="-ddd"
fi


if [ -f /run/sshd ] 
then
   echo "/run/sshd exists"
else
   mkdir /run/sshd
fi

exec 2>&1 \
        s6-setuidgid root /usr/sbin/sshd -D $sshflags -e -p $PORT
