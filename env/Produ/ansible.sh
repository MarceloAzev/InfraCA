#!/bin/bash
cd /home/ubuntu
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py
sudo python3 -m pip install ansible
tee -a playbook.yml > /dev/null << EOT
- hosts: localhost
  become: yes
  tasks:
  - name: Download pip installer
    get_url:
      url: https://bootstrap.pypa.io/get-pip.py
      dest: /tmp/get-pip.py
  - name: instalando o python3
    apt:
      pkg:
      - python3
      - python3-pip
      update_cache: yes
  - name: 'git Clone'
    ansible.builtin.git:
      repo: https://github.com/alura-cursos/clientes-leo-api
      dest: /home/ubuntu/venv
      version: master
      force: yes #forçar para que sempre sobrer por para nova versão
  - name: Create app folder
    file:
      name: /opt/pythonapp
      state: directory
      recurse: yes
  - name: Install virtualenv module
    pip:
      name: virtualenv
      state: latest
  - name: 'instalando dependencias com pip (Django e Django rest)'
    pip:
      virtualenv: /home/ubuntu/venv/venv
      requirements: /home/ubuntu/venv/requirements.txt
  - name: 'Setup modificando a configuração do Host'
    lineinfile:
      path: /home/ubuntu/venv/setup/settings.py
      regexp: 'ALLOWED_HOSTS'
      line: 'ALLOWED_HOSTS = ["*"]'
      backrefs: yes
  - name: 'configurando o banco de dados'
    shell: '. /home/ubuntu/venv/venv/bin/activate; python /home/ubuntu/venv/manage.py migrate'
  - name: dados iniciais do DB
    shell: '. /home/ubuntu/venv/venv/bin/activate; python /home/ubuntu/venv/manage.py loaddata clientes.json'
  - name: 'inciando servidor'
    shell: '. /home/ubuntu/venv/venv/bin/activate; nohup python /home/ubuntu/venv/manage.py runserver 0.0.0.0:8080 &'
EOT

ansible-playbook playbook.yml